#include "siilihaimobile.h"
#include <QDesktopServices>
#include <QDebug>
#include <QQmlEngine>

#include <siilihai/forumdata/forumgroup.h>
#include <siilihai/forumdata/forumthread.h>
#include <siilihai/forumdata/forummessage.h>
#include <siilihai/forumdata/forumsubscription.h>
#include <siilihai/forumdata/updateerror.h>
#include <siilihai/parser/parsermanager.h>
#include <siilihai/parser/forumparser.h>
#include <siilihai/parser/forumsubscriptionparsed.h>
#include <siilihai/tapatalk/forumsubscriptiontapatalk.h>
#include <siilihai/siilihaisettings.h>

SiilihaiMobile::SiilihaiMobile(QObject *parent, QQuickView *view) :
    ClientLogic(parent), qQuickView(view), haltRequested(false), newForum(0),
    probe(0, m_protocol), forumWasSubscribedByUser(false) {
    qmlRegisterType<UpdateError>("org.vranki.siilihai", 1, 0, "UpdateError");

    if(!view->rootContext())  {
        closeUi();
        return;
    }
    qQuickView->rootContext()->setContextProperty("siilihai", this);
    dismissMessages();
    setContextProperties();
    connect(&m_protocol, SIGNAL(listForumsFinished(QList <ForumSubscription*>)), this, SLOT(listForumsFinished(QList <ForumSubscription*>)));
}

void SiilihaiMobile::subscribeForum() {
    deleteNewForum();
    setObjectProperty("subscribeForumDialog", "topItem", "true");
    m_protocol.listForums();
}

// Receiver owns the forums!
void SiilihaiMobile::listForumsFinished(QList <ForumSubscription*> forums) {
    qQuickView->rootContext()->setContextProperty("forumList", 0);
    qDeleteAll(forumList); // Delete 'em old
    forumList.clear();
    foreach(ForumSubscription *p, forums)
        forumList.append(p);

    qQuickView->rootContext()->setContextProperty("forumList", QVariant::fromValue(forumList));
}

void SiilihaiMobile::showLoginWizard() {
    qDebug() << Q_FUNC_INFO;
    setObjectProperty("loginWizard", "topItem", "true");
}

void SiilihaiMobile::errorDialog(QString message) {
    if(!message.isEmpty()) errorMessageList.append(message);
    qQuickView->rootContext()->setContextProperty("errormessages", errorMessageList);
}

void SiilihaiMobile::closeUi() {
    qDebug() << Q_FUNC_INFO;
    if(!QCoreApplication::closingDown())
        QCoreApplication::quit();
}

void SiilihaiMobile::showMainWindow() {
    qDebug() << Q_FUNC_INFO << "Settings at " << m_settings->fileName();
    qQuickView->rootContext()->setContextProperty("siilihaisettings", m_settings);
    if(state() == SH_OFFLINE)
        showStatusMessage("Started in offline mode");
}

void SiilihaiMobile::showCredentialsDialog() {
    Q_ASSERT(currentCredentialsRequest); // Set in clientlogic
    Q_ASSERT(currentCredentialsRequest->subscription);
    Q_ASSERT(!currentCredentialsRequest->subscription->alias().isNull());
    qDebug() << Q_FUNC_INFO << currentCredentialsRequest->subscription->alias();
    setObjectProperty("credentialsDialog", "forumAlias", currentCredentialsRequest->subscription->alias());
    setObjectProperty("credentialsDialog", "topItem", "true");
}

void SiilihaiMobile::credentialsEntered(QString u, QString p, bool remember) {
    qDebug() << Q_FUNC_INFO << u << remember;
    Q_ASSERT(currentCredentialsRequest);
    currentCredentialsRequest->authenticator.setUser(u);
    currentCredentialsRequest->authenticator.setPassword(p);
    currentCredentialsRequest->signalCredentialsEntered(remember);
}

void SiilihaiMobile::postMessage(ForumSubscription *sub, QString grpId, QString thrId, QString subject, QString body) {
    ForumGroup *grp = sub->value(grpId);
    if(!grp) {
        emit messagePosted("Group doesn't exist");
        return;
    }
    ForumThread *thr = 0;
    if(!thrId.isEmpty()) {
        thr = grp->value(thrId);
        if(!thr) {
            emit messagePosted("Thread doesn't exist");
            return;
        }
    }
    if(sub->updateEngine()->postMessage(grp, thr, subject, body)) {
        emit messagePosted(QString::null);
    } else {
        emit messagePosted("Sending message failed");
    }
}

void SiilihaiMobile::subscribeFailed(QString reason) {
    QMetaObject::invokeMethod(qQuickView->rootObject(), "subscribeFailed", Q_ARG(QVariant, reason));
}

void SiilihaiMobile::setContextProperties() {
    QQmlContext *rootContext = qQuickView->rootContext();
    rootContext->setContextProperty("siilihaimobile", this);
    rootContext->setContextProperty("subscribeGroupList", QVariant::fromValue(subscribeGroupList));
    rootContext->setContextProperty("messageQueue", QVariant::fromValue(errorMessageList));
    rootContext->setContextProperty("newForum", newForum);
    rootContext->setContextProperty("forumList", QVariant::fromValue(forumList));
}

bool SiilihaiMobile::noBackButton() const
{
#ifdef NO_BACK_BUTTON
    return true;
#endif
    return false;
}

void SiilihaiMobile::deleteNewForum() {
    if(newForum) {
        qQuickView->rootContext()->setContextProperty("newForum", 0);
        newForum->deleteLater();
        newForum = 0;
    }
}

void SiilihaiMobile::setObjectProperty(QString objectName, QString property, QString value) {
    QObject *object = qQuickView->rootObject()->findChild<QObject*>(objectName);
    if(!object) qDebug() << Q_FUNC_INFO << "Object " << objectName << " does not exist!";
    Q_ASSERT(object);
    object->setProperty(property.toUtf8(), QVariant::fromValue(value));
}

bool SiilihaiMobile::sortMessagesByOrdernum(QObject *a, QObject *b) {
    return qobject_cast<ForumMessage*>(a)->ordernum() < qobject_cast<ForumMessage*>(b)->ordernum();
}

void SiilihaiMobile::registerUser(QString user, QString password, QString email, bool sync) {
    qDebug() << Q_FUNC_INFO << user << email << password;
    if(user.isEmpty() && password.isEmpty()) {
        // Use without account
        m_settings->setValue("account/noaccount", true);
        QObject *lw = qQuickView->rootObject()->findChild<QObject*>("loginWizard");
        if (lw) QMetaObject::invokeMethod(lw, "registrationFinished", Q_ARG(QVariant, true), Q_ARG(QVariant, ""));
    } else {
        regOrLoginUser = user.trimmed();
        regOrLoginPass = password.trimmed();
        connect(&m_protocol, SIGNAL(loginFinished(bool,QString,bool)), this, SLOT(registerFinished(bool,QString,bool)));
        m_protocol.registerUser(regOrLoginUser, regOrLoginPass, email, sync);
    }
}

void SiilihaiMobile::registerFinished(bool success, QString motd, bool sync) {
    disconnect(&m_protocol, SIGNAL(loginFinished(bool,QString,bool)), this, SLOT(registerFinished(bool,QString,bool)));
    qDebug() << Q_FUNC_INFO << success << motd << sync;
    if (success) {
        m_settings->setUsername(regOrLoginUser);
        m_settings->setPassword(regOrLoginPass);
        m_settings->setSyncEnabled(sync);
        m_settings->setValue("account/registered_here", true);
        m_settings->sync();
        ClientLogic::loginWizardFinished();
    } else {
        errorDialog("Registration failed - \n" + motd);
    }
    QObject *lw = qQuickView->rootObject()->findChild<QObject*>("loginWizard");
    if (lw) QMetaObject::invokeMethod(lw, "registrationFinished", Q_ARG(QVariant, success), Q_ARG(QVariant, motd));
}

void SiilihaiMobile::sendParserReportFinished(bool success) {
    qDebug() << Q_FUNC_INFO << success;
}

void SiilihaiMobile::loginUser(QString user, QString password) {
    qDebug() << Q_FUNC_INFO << user << password;
    regOrLoginUser = user.trimmed();
    regOrLoginPass = password.trimmed();
    connect(&m_protocol, SIGNAL(loginFinished(bool,QString,bool)), this, SLOT(loginFinished(bool,QString,bool)));
    m_protocol.login(user, password);
}

void SiilihaiMobile::loginFinished(bool success, QString motd, bool sync) {
    qDebug() << Q_FUNC_INFO;
    ClientLogic::loginFinished(success, motd, sync);
    disconnect(&m_protocol, SIGNAL(loginFinished(bool,QString,bool)), this, SLOT(loginFinished(bool,QString,bool)));
    if(success && !regOrLoginUser.isEmpty()) {
        m_settings->setUsername(regOrLoginUser);
        m_settings->setPassword(regOrLoginPass);
        m_settings->sync();
    }
    QObject *lw = qQuickView->rootObject()->findChild<QObject*>("loginWizard");
    if (lw) QMetaObject::invokeMethod(lw, "loginFinished", Q_ARG(QVariant, success), Q_ARG(QVariant, motd));
}

void SiilihaiMobile::subscribeForumWithCredentials(int id, QString name, QString username, QString password) {
    qDebug() << Q_FUNC_INFO << id << name;

    Q_ASSERT(newForum->id());
    Q_ASSERT(newForum->id() == id);

    if(!username.isEmpty()) {
        newForum->setAuthenticated(true);
        newForum->setUsername(username);
        newForum->setPassword(password);
    }
    newForum->setLatestThreads(m_settings->threadsPerGroup());
    newForum->setLatestMessages(m_settings->messagesPerThread());
    forumWasSubscribedByUser = true;
    forumAdded(newForum);
    Q_ASSERT(m_forumDatabase.contains(newForum->id()));
    deleteNewForum();
}

void SiilihaiMobile::showSubscribeGroups(ForumSubscription *sub) {
    qDebug() << Q_FUNC_INFO << sub->toString();
    subscribeGroupList.clear();
    qQuickView->rootContext()->setContextProperty("subscribeGroupList", 0);
    foreach(ForumGroup *fg, sub->values()) {
        subscribeGroupList.append(fg);
    }
    qQuickView->rootContext()->setContextProperty("subscribeGroupList", QVariant::fromValue(subscribeGroupList));
    setObjectProperty("forumSettingsDialog", "topItem", "true");
    forumWasSubscribedByUser=true;
}

// And authentications also!
void SiilihaiMobile::applyGroupSubscriptions() {
    qDebug() << Q_FUNC_INFO;
    subscribeGroupList.clear();
    /*
    setContextProperties();
    foreach(ForumGroup *group, currentSub->values()) {
        group->markToBeUpdated();
        group->setHasChanged(true);
        group->commitChanges();
    }
    updateCurrentGroupModel();
    ClientLogic::updateGroupSubscriptions(currentSub);
    forumUpdateNeeded(currentSub); // Send credentials
    */
}

void SiilihaiMobile::getForumDetails(int id) {
    qDebug() << Q_FUNC_INFO << id;
    Q_ASSERT(id);
    deleteNewForum();
    connect(&probe, SIGNAL(probeResults(ForumSubscription*)), this, SLOT(probeResults(ForumSubscription*)));
    probe.probeUrl(id);
}

// Get by URL - need to probe
void SiilihaiMobile::getForumUrlDetails(QString urlString)
{
    qDebug() << Q_FUNC_INFO << urlString;
    QUrl url(urlString);
    if(!url.isValid()) {
        subscribeFailed("Invalid URL");
        return;
    }
    deleteNewForum();
    connect(&probe, SIGNAL(probeResults(ForumSubscription*)), this, SLOT(probeResults(ForumSubscription*)));
    probe.probeUrl(url);
}

void SiilihaiMobile::probeResults(ForumSubscription *probedSub) {
    disconnect(&probe, SIGNAL(probeResults(ForumSubscription*)), this, SLOT(probeResults(ForumSubscription*)));
    if(!probedSub) {
        QObject *lw = qQuickView->rootObject()->findChild<QObject*>("subscribeCustomButton");
        if (lw) QMetaObject::invokeMethod(lw, "probeFinished", Q_ARG(QVariant, false), Q_ARG(QVariant, "Unsupported forum"));
        return;
    } else {
        newForum = ForumSubscription::newForProvider(probedSub->provider(), 0, true);
        newForum->copyFrom(probedSub);
        qQuickView->rootContext()->setContextProperty("newForum", newForum);
        if(newForum->id()) {
            // Found
            QObject *lw = qQuickView->rootObject()->findChild<QObject*>("subscribeCustomButton");
            if (lw) QMetaObject::invokeMethod(lw, "probeFinished", Q_ARG(QVariant, true), Q_ARG(QVariant, ""));
        } else {
            // Not found, adding
            connect(&m_protocol, SIGNAL(forumGot(ForumSubscription*)), this, SLOT(newForumAdded(ForumSubscription*)));
            m_protocol.addForum(newForum);
        }
    }
}

void SiilihaiMobile::newForumAdded(ForumSubscription *sub) {
    disconnect(&m_protocol, SIGNAL(forumGot(ForumSubscription*)), this, SLOT(newForumAdded(ForumSubscription*)));
    if(sub) {
        Q_ASSERT(sub->id());
        newForum->copyFrom(sub);
        qQuickView->rootContext()->setContextProperty("newForum", newForum);
        QObject *lw = qQuickView->rootObject()->findChild<QObject*>("subscribeCustomButton");
        if (lw) QMetaObject::invokeMethod(lw, "probeFinished", Q_ARG(QVariant, true), Q_ARG(QVariant, ""));
    } else {
        QObject *lw = qQuickView->rootObject()->findChild<QObject*>("subscribeCustomButton");
        if (lw) QMetaObject::invokeMethod(lw, "probeFinished", Q_ARG(QVariant, false), Q_ARG(QVariant, "Adding forum failed, check log"));
    }
}

void SiilihaiMobile::haltSiilihai() {
    qDebug() << Q_FUNC_INFO;
    haltRequested = true;
    ClientLogic::haltSiilihai();
}

bool SiilihaiMobile::isHaltRequested() const {
    return haltRequested;
}

void SiilihaiMobile::reloadUi() {
    qDebug() << Q_FUNC_INFO;
    QMetaObject::invokeMethod(this, "reloadUiReally", Qt::QueuedConnection);
}

void SiilihaiMobile::dismissMessages() {
    errorMessageList.clear();
    errorDialog(QString::null);
}

void SiilihaiMobile::reloadUiReally() {
    QUrl src = qQuickView->source();
    qQuickView->engine()->clearComponentCache();
    qQuickView->setSource(QUrl());
    qQuickView->engine()->clearComponentCache();
    qQuickView->setSource(src);
    setContextProperties();
}
