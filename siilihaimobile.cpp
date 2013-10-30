#include "siilihaimobile.h"
#include <QDesktopServices>
#include <QDebug>
#include <QQmlEngine>

#include <siilihai/forumdata/forumgroup.h>
#include <siilihai/forumdata/forumthread.h>
#include <siilihai/forumdata/forummessage.h>
#include <siilihai/forumdata/forumsubscription.h>
#include <siilihai/parser/parsermanager.h>
#include <siilihai/parser/forumparser.h>
#include <siilihai/parser/forumsubscriptionparsed.h>
#include <siilihai/tapatalk/forumsubscriptiontapatalk.h>

SiilihaiMobile::SiilihaiMobile(QObject *parent, QQuickView &view) :
    ClientLogic(parent), qQuickView(view), rootContext(view.engine()->rootContext()), rootObject(view.rootObject()),
    currentSub(0), currentGroup(0), currentThread(0), haltRequested(false), newForum(0),
    probe(0, protocol)
{
    if(!rootContext)  {
        closeUi();
        return;
    }
    rootContext->setContextProperty("selectedforum", 0);
    rootContext->setContextProperty("selectedgroup", 0);
    rootContext->setContextProperty("selectedthread", 0);
    rootContext->setContextProperty("newForum", 0);
    rootContext->setContextProperty("forumList", 0);
    dismissMessages();
    setContextProperties();

    // offlineModeSet(true);
}

void SiilihaiMobile::subscribeForum() {
    qDebug() << Q_FUNC_INFO;
    QObject *lw = rootObject->findChild<QObject*>("subscribeForumDialog");
    if (lw) lw->setProperty("topItem", "true");
    connect(&protocol, SIGNAL(listForumsFinished(QList <ForumSubscription*>)), this, SLOT(listForumsFinished(QList <ForumSubscription*>)));
    protocol.listForums();
}

// Receiver owns the forums!
void SiilihaiMobile::listForumsFinished(QList <ForumSubscription*> forums) {
    qDebug() << Q_FUNC_INFO << forums.size();
    rootContext->setContextProperty("forumList", 0);
    qDeleteAll(forumList); // Delete 'em old

    foreach(ForumSubscription *p, forums)
        forumList.append(p);

    rootContext->setContextProperty("forumList", QVariant::fromValue(forumList));
}

void SiilihaiMobile::showLoginWizard() {
    qDebug() << Q_FUNC_INFO;
    QObject *lw = rootObject->findChild<QObject*>("loginWizard");
    if (lw) lw->setProperty("visible", "true");
}

void SiilihaiMobile::errorDialog(QString message) {
    if(!message.isEmpty()) errorMessageList.append(message);
    rootContext->setContextProperty("errormessages", errorMessageList);
}

void SiilihaiMobile::closeUi() {
    qDebug() << Q_FUNC_INFO;
    if(!QCoreApplication::closingDown())
        QCoreApplication::quit();
}

void SiilihaiMobile::showMainWindow() {
    qDebug() << Q_FUNC_INFO;
    qDebug() << "Settings at " << settings->fileName();
    if(state() == SH_OFFLINE)
        showStatusMessage("Started in offline mode");
}

void SiilihaiMobile::subscriptionFound(ForumSubscription *sub) {
    ClientLogic::subscriptionFound(sub);
    qDebug() << Q_FUNC_INFO << sub->toString();
    subscriptionList.append(sub);
    rootContext->setContextProperty("subscriptions", QVariant::fromValue(subscriptionList));
}

void SiilihaiMobile::subscriptionDeleted(QObject* subobj) {
    qDebug() << Q_FUNC_INFO;
    ForumSubscription *sub = static_cast<ForumSubscription*> (subobj);
    Q_ASSERT(sub);
    subscriptionList.removeAll(sub);
    if(sub==currentSub) {
        selectForum();
    }
    setContextProperties();
    ClientLogic::subscriptionDeleted(subobj);
}

void SiilihaiMobile::showCredentialsDialog(CredentialsRequest *cr) {
    qDebug() << Q_FUNC_INFO << cr->subscription->alias() << 50;
    QMetaObject::invokeMethod(rootObject, "askCredentials", Q_ARG(QVariant, currentCredentialsRequest->subscription->alias()),
                              Q_ARG(QVariant, currentCredentialsRequest->credentialType==CredentialsRequest::SH_CREDENTIAL_HTTP?"HTTP":"forum") );
}

void SiilihaiMobile::groupListChanged(ForumSubscription *sub) {
    qDebug() << Q_FUNC_INFO << sub->toString();
    if(currentSub == sub || !currentSub) {
        selectForum(sub->forumId());
        showSubscribeGroups();
    }
}

void SiilihaiMobile::subscribeFailed(QString reason) {
    QMetaObject::invokeMethod(rootObject, "subscribeFailed", Q_ARG(QVariant, reason));
}

void SiilihaiMobile::setContextProperties() {
    rootContext->setContextProperty("siilihaimobile", this);
    rootContext->setContextProperty("subscriptions", QVariant::fromValue(subscriptionList));
    rootContext->setContextProperty("groups", QVariant::fromValue(groupList));
    rootContext->setContextProperty("threads", QVariant::fromValue(threadList));
    rootContext->setContextProperty("messages", QVariant::fromValue(messageList));
    rootContext->setContextProperty("subscribeGroupList", QVariant::fromValue(subscribeGroupList));
    rootContext->setContextProperty("messageQueue", QVariant::fromValue(errorMessageList));
}

void SiilihaiMobile::updateCurrentMessageModel() {
    messageList.clear();
    if(currentThread) {
        foreach(ForumMessage *fm, currentThread->values()) {
            messageList.append(fm);
        }
    }
    rootContext->setContextProperty("messages", QVariant::fromValue(messageList));
}

void SiilihaiMobile::updateCurrentThreadModel() {
    threadList.clear();
    if(currentGroup) {
        foreach(ForumThread *ft, currentGroup->values()) threadList.append(ft);
    }
    rootContext->setContextProperty("threads", QVariant::fromValue(threadList));
}

void SiilihaiMobile::updateCurrentGroupModel() {
    groupList.clear();
    if(currentSub) {
        foreach(ForumGroup *fg, currentSub->values()) {
            if(fg->isSubscribed())
                groupList.append(fg);
        }
    }
    rootContext->setContextProperty("groups", QVariant::fromValue(groupList));
}

void SiilihaiMobile::registerUser(QString user, QString password, QString email, bool sync) {
    qDebug() << Q_FUNC_INFO << user << email << password;
    if(user.isEmpty() && password.isEmpty()) {
        // Use without account
        settings->setValue("account/noaccount", true);
        QObject *lw = rootObject->findChild<QObject*>("loginWizard");
        if (lw) QMetaObject::invokeMethod(lw, "registrationFinished", Q_ARG(QVariant, true), Q_ARG(QVariant, ""));
    } else {
        regOrLoginUser = user.trimmed();
        regOrLoginPass = password.trimmed();
        connect(&protocol, SIGNAL(loginFinished(bool,QString,bool)), this, SLOT(registerFinished(bool,QString,bool)));
        protocol.registerUser(regOrLoginUser, regOrLoginPass, email, sync);
    }
}

void SiilihaiMobile::registerFinished(bool success, QString motd, bool sync) {
    disconnect(&protocol, SIGNAL(loginFinished(bool,QString,bool)), this, SLOT(registerFinished(bool,QString,bool)));
    qDebug() << Q_FUNC_INFO << success << motd << sync;
    if (success) {
        settings->setValue("account/username", regOrLoginUser);
        settings->setValue("account/password", regOrLoginPass);
        settings->setValue("preferences/sync_enabled", sync);
        settings->setValue("account/registered_here", true);
        settings->sync();
    } else {
        errorDialog("Registration failed - \n" + motd);
    }
    QObject *lw = rootObject->findChild<QObject*>("loginWizard");
    if (lw) QMetaObject::invokeMethod(lw, "registrationFinished", Q_ARG(QVariant, success), Q_ARG(QVariant, motd));
    ClientLogic::loginWizardFinished();
}

void SiilihaiMobile::sendParserReportFinished(bool success) {
    qDebug() << Q_FUNC_INFO << success;
}

void SiilihaiMobile::loginUser(QString user, QString password) {
    qDebug() << Q_FUNC_INFO << user << password;
    regOrLoginUser = user.trimmed();
    regOrLoginPass = password.trimmed();
    connect(&protocol, SIGNAL(loginFinished(bool,QString,bool)), this, SLOT(loginFinished(bool,QString,bool)));
    protocol.login(user, password);
}

void SiilihaiMobile::loginFinished(bool success, QString motd, bool sync) {
    qDebug() << Q_FUNC_INFO;
    ClientLogic::loginFinished(success, motd, sync);
    disconnect(&protocol, SIGNAL(loginFinished(bool,QString,bool)), this, SLOT(loginFinished(bool,QString,bool)));
    if(success && !regOrLoginUser.isEmpty()) {
        settings->setValue("account/username", regOrLoginUser);
        settings->setValue("account/password", regOrLoginPass);
        settings->sync();
    }
    QObject *lw = rootObject->findChild<QObject*>("loginWizard");
    if (lw) QMetaObject::invokeMethod(lw, "loginFinished", Q_ARG(QVariant, success), Q_ARG(QVariant, motd));
}

void SiilihaiMobile::subscribeForumWithCredentials(int id, QString name, QString username, QString password) {
    qDebug() << Q_FUNC_INFO << id << name;

    Q_ASSERT(newForum->forumId());
    Q_ASSERT(newForum->forumId() == id);

    if(!username.isEmpty()) {
        newForum->setUsername(username);
        newForum->setPassword(password);
    }
    newForum->setLatestThreads(settings->value("preferences/threads_per_group", 20).toInt());
    newForum->setLatestMessages(settings->value("preferences/messages_per_thread", 20).toInt());

    forumAdded(newForum);
    newForum->deleteLater();
    newForum = 0;
    rootContext->setContextProperty("newForum", 0);
}

void SiilihaiMobile::showSubscribeGroups() {
    Q_ASSERT(currentSub);
    qDebug() << Q_FUNC_INFO << currentSub->toString();
    subscribeGroupList.clear();
    rootContext->setContextProperty("subscribeGroupList", 0);
    foreach(ForumGroup *fg, currentSub->values()) {
        subscribeGroupList.append(fg);
    }
    rootContext->setContextProperty("subscribeGroupList", QVariant::fromValue(subscribeGroupList));
    QObject *lw = rootObject->findChild<QObject*>("forumSettingsDialog");
    Q_ASSERT(lw);
    if (lw) lw->setProperty("topItem", "true");
}

void SiilihaiMobile::applyGroupSubscriptions() {
    qDebug() << Q_FUNC_INFO;
    Q_ASSERT(currentSub);
    subscribeGroupList.clear();
    setContextProperties();
    foreach(ForumGroup *group, currentSub->values()) {
        group->markToBeUpdated();
        group->setHasChanged(true);
        group->commitChanges();
    }
    updateCurrentGroupModel();
    ClientLogic::updateGroupSubscriptions(currentSub);
}

void SiilihaiMobile::credentialsEntered(QString u, QString p, bool remember) {
    qDebug() << Q_FUNC_INFO << u << remember;
    Q_ASSERT(currentCredentialsRequest);
    currentCredentialsRequest->authenticator.setUser(u);
    currentCredentialsRequest->authenticator.setPassword(p);
    currentCredentialsRequest->signalCredentialsEntered(remember);
}

void SiilihaiMobile::unsubscribeCurrentForum() {
    Q_ASSERT(currentSub);
    ForumSubscription *cs = currentSub;
    selectForum(0);
    unsubscribeForum(cs);
}

void SiilihaiMobile::getForumDetails(int id) {
    qDebug() << Q_FUNC_INFO << id;
    Q_ASSERT(id);
    if(newForum) {
        newForum->deleteLater();
    }
    newForum = 0;
    rootContext->setContextProperty("newForum", newForum);

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
    if(newForum)
        newForum->deleteLater();
    newForum = 0;
    rootContext->setContextProperty("newForum", newForum);

    connect(&probe, SIGNAL(probeResults(ForumSubscription*)), this, SLOT(probeResults(ForumSubscription*)));
    probe.probeUrl(url);
}

void SiilihaiMobile::probeResults(ForumSubscription *probedSub) {
    disconnect(&probe, SIGNAL(probeResults(ForumSubscription*)), this, SLOT(probeResults(ForumSubscription*)));
    if(!probedSub) {
        errorDialog("Unsupported forum");
        return;
    } else {
        newForum = ForumSubscription::newForProvider(probedSub->provider(), 0, true);
        newForum->copyFrom(probedSub);
        rootContext->setContextProperty("newForum", newForum);
        if(newForum->forumId()) {
            // Found
        } else {
            // Not found, adding
            connect(&protocol, SIGNAL(forumGot(ForumSubscription*)), this, SLOT(newForumAdded(ForumSubscription*)));
            protocol.addForum(newForum);
        }
    }
}

void SiilihaiMobile::newForumAdded(ForumSubscription *sub) {
    disconnect(&protocol, SIGNAL(forumGot(ForumSubscription*)), this, SLOT(newForumAdded(ForumSubscription*)));
    if(sub) {
        Q_ASSERT(sub->forumId());
        newForum->copyFrom(sub);
        rootContext->setContextProperty("newForum", newForum);
    } else {
        subscribeFailed("Adding forum failed, check log");
    }
}

void SiilihaiMobile::changeState(siilihai_states newState) {
    ClientLogic::changeState(newState);
}

void SiilihaiMobile::showMoreMessages() {
    qDebug() << Q_FUNC_INFO << currentThread;
    if(!currentThread) return;
    moreMessagesRequested(currentThread);
}

void SiilihaiMobile::haltSiilihai() {
    if(!haltRequested) {
        haltRequested = true;
        /*
        messageList.clear();
        threadList.clear();
        groupList.clear();
        subscriptionList.clear();
*/
        // setContextProperties();
    }
    ClientLogic::haltSiilihai();
}

bool SiilihaiMobile::isHaltRequested() {
    return haltRequested;
}

int SiilihaiMobile::selectedForumId() const
{
    return currentSub ? currentSub->forumId() : 0;
}

QString SiilihaiMobile::selectedGroupId() const {
    return currentGroup ? currentGroup->id() : QString::null;
}

void SiilihaiMobile::selectForum(int id) {
    qDebug() << Q_FUNC_INFO << id;
    if (selectedForumId() != id) {
        selectGroup();
        currentSub = forumDatabase.value(id);
        subscribeGroupList.clear();
        rootContext->setContextProperty("selectedforum", currentSub);
        updateCurrentGroupModel();
        emit selectedForumChanged(currentSub ? currentSub->forumId() : 0);
    }
}

QString SiilihaiMobile::selectedThreadId() const {
    return currentThread ? currentThread->id() : QString::null;
}

void SiilihaiMobile::selectGroup(QString id) {
    qDebug() << Q_FUNC_INFO << id;
    Q_ASSERT(currentSub || id.isEmpty());
    if (!currentGroup || currentGroup->id() != id) {
        selectThread();
        currentGroup = currentSub ? currentSub->value(id) : 0;
        rootContext->setContextProperty("selectedgroup", currentGroup);
        updateCurrentThreadModel();
        emit selectedGroupIdChanged(currentGroup ? currentGroup->id() : QString::null);
    }
}

void SiilihaiMobile::selectThread(QString id) {
    qDebug() << Q_FUNC_INFO << id;
    Q_ASSERT(currentGroup || id.isEmpty());
    if(currentThread)
        disconnect(currentThread, 0, this, 0);
    if(!currentThread || currentThread->id() != id) {
        currentThread = 0;
        if(currentGroup) currentThread = currentGroup->value(id);
        if(currentThread) {
            connect(currentThread, SIGNAL(messageAdded(ForumMessage*)), this, SLOT(updateCurrentMessageModel()));
            connect(currentThread, SIGNAL(messageRemoved(ForumMessage*)), this, SLOT(updateCurrentMessageModel()));
        }
        updateCurrentMessageModel();
        rootContext->setContextProperty("selectedthread", currentThread);
        emit selectedThreadIdChanged(currentThread ? currentThread->id() : QString::null);
    }
}

void SiilihaiMobile::reloadUi() {
    qDebug() << Q_FUNC_INFO;
    QMetaObject::invokeMethod(this, "reloadUiReally", Qt::QueuedConnection);
}

void SiilihaiMobile::dismissMessages()
{
    errorMessageList.clear();
    errorDialog(QString::null);
}

void SiilihaiMobile::reloadUiReally()
{
    QUrl src = qQuickView.source();
    qQuickView.engine()->clearComponentCache();
    qQuickView.setSource(QUrl());
    qQuickView.engine()->clearComponentCache();
    qQuickView.setSource(src);
    setContextProperties();
}
