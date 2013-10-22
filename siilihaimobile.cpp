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
    currentSub(0), currentGroup(0), currentThread(0), haltRequested(false), newForum(0), m_selectedForumId(0),
    probe(0, protocol)
{
    if(!rootContext)  {
        closeUi();
        return;
    }
    setContextProperties();

    QObject *appWindow = rootObject;
    Q_ASSERT(appWindow);
    connect(appWindow, SIGNAL(groupSelected(QString)), this, SLOT(groupSelected(QString)));
    connect(appWindow, SIGNAL(threadSelected(QString)), this, SLOT(threadSelected(QString)));
    connect(appWindow, SIGNAL(haltSiilihai()), this, SLOT(haltSiilihai()));
    connect(appWindow, SIGNAL(registerUser(QString, QString, QString, bool)), this, SLOT(registerUser(QString,QString,QString,bool)));
    connect(appWindow, SIGNAL(loginUser(QString, QString)), this, SLOT(loginUser(QString,QString)));
    connect(appWindow, SIGNAL(listSubscriptions()), this, SLOT(listSubscriptions()));
    connect(appWindow, SIGNAL(subscribeForum(int, QString)), this, SLOT(subscribeForum(int, QString)));
    connect(appWindow, SIGNAL(subscribeForumWithCredentials(int, QString, QString, QString)), this, SLOT(subscribeForumWithCredentials(int, QString, QString, QString)));
    connect(appWindow, SIGNAL(subscribeGroups()), this, SLOT(showSubscribeGroups()));
    connect(appWindow, SIGNAL(setGroupSubscribed(QString, bool)), this, SLOT(setGroupSubscribed(QString, bool)));
    connect(appWindow, SIGNAL(applyGroupSubscriptions()), this, SLOT(applyGroupSubscriptions()));
    connect(appWindow, SIGNAL(credentialsEntered(QString, QString, bool)), this, SLOT(credentialsEntered(QString,QString,bool)));
    connect(appWindow, SIGNAL(unSubscribeCurrentForum()), this, SLOT(unsubscribeCurrentForum()));
    connect(appWindow, SIGNAL(getForumDetails(int)), this, SLOT(getForumDetails(int)));
    connect(appWindow, SIGNAL(getForumUrlDetails(QString)), this, SLOT(getForumUrlDetails(QString)));
    connect(appWindow, SIGNAL(markThreadRead(bool)), this, SLOT(markThreadRead(bool)));
    connect(appWindow, SIGNAL(confirmMessages()), this, SLOT(confirmMessages()));
    connect(appWindow, SIGNAL(showMoreMessages()), this, SLOT(showMoreMessages()));
    connect(appWindow, SIGNAL(updateClicked()), this, SLOT(updateClicked()));
    connect(appWindow, SIGNAL(openInBrowser(QString)), this, SLOT(openInBrowser(QString)));
    messageDisplayed = true; // Prevent messages until main win is shown
    offlineModeSet(true);

    connect(&showNextErrorTimer, SIGNAL(timeout()), this, SLOT(showNextError()));
    showNextErrorTimer.setSingleShot(true);
    showNextErrorTimer.setInterval(200);
}

void SiilihaiMobile::subscribeForum() {
    qDebug() << Q_FUNC_INFO;
    // Hangs QML for some reason!
    // QMetaObject::invokeMethod(rootObject, "showSubscribeWizard");
}

void SiilihaiMobile::showLoginWizard() {
    qDebug() << Q_FUNC_INFO;
    QMetaObject::invokeMethod(rootObject, "showLoginWizard");
}

void SiilihaiMobile::errorDialog(QString message) {
    // qDebug() << Q_FUNC_INFO << message << " queue " << messageQueue.size();
    messageQueue << message;
    showNextError();
}

void SiilihaiMobile::showNextError() {
    if(!messageDisplayed) {
        QMetaObject::invokeMethod(rootObject, "showErrorMessage", Q_ARG(QVariant, messageQueue.takeFirst()));
        messageDisplayed = true;
    } else {
        qDebug() << Q_FUNC_INFO << "message displayed, queueing";
    }
}

// requestedByUI means user has dismissed previous message
void SiilihaiMobile::confirmMessages() {
    qDebug() << Q_FUNC_INFO << "queue: " << messageQueue.size() << " by UI:" << " displayed:" << messageDisplayed;
    Q_ASSERT(messageDisplayed);
    messageDisplayed = false;
    if(!messageQueue.isEmpty()) {
        showNextErrorTimer.start(); // Delay
    }
}


void SiilihaiMobile::closeUi() {
    qDebug() << Q_FUNC_INFO;
    if(!QCoreApplication::closingDown())
        QCoreApplication::quit();
}

void SiilihaiMobile::showMainWindow() {
    qDebug() << Q_FUNC_INFO;
    qDebug() << "Settings at " << settings->fileName();
    messageDisplayed = false;
    //displayNextMessage(false);
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
    subscriptionList.removeAll(sub);
    if(sub==currentSub) {
        threadSelected(QString::null);
        groupSelected(QString::null);
        selectForum(0);
        currentSub = 0;
        currentGroup = 0;
        currentThread = 0;
    }
    rootContext->setContextProperty("subscriptions", QVariant::fromValue(subscriptionList));
    ClientLogic::subscriptionDeleted(subobj);
}

void SiilihaiMobile::showCredentialsDialog(CredentialsRequest *cr) {
    qDebug() << Q_FUNC_INFO << cr->subscription->alias() << 50;
    QMetaObject::invokeMethod(rootObject, "askCredentials", Q_ARG(QVariant, currentCredentialsRequest->subscription->alias()),
                              Q_ARG(QVariant, currentCredentialsRequest->credentialType==CredentialsRequest::SH_CREDENTIAL_HTTP?"HTTP":"forum") );
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
    rootContext->setContextProperty("messageQueue", QVariant::fromValue(messageQueue));
}



void SiilihaiMobile::groupSelected(QString id) {
    qDebug() << Q_FUNC_INFO << id;
    if(currentThread)
        disconnect(currentThread, 0, this, 0);
    threadList.clear();
    if(!id.isEmpty()) {
        currentGroup = currentSub->value(id);
        currentThread = 0;
        foreach(ForumThread *ft, currentGroup->values()) {
            threadList.append(ft);
        }
    }
    rootContext->setContextProperty("threads", QVariant::fromValue(threadList));
}

void SiilihaiMobile::threadSelected(QString id) {
    qDebug() << Q_FUNC_INFO << id;
    if(currentThread)
        disconnect(currentThread, 0, this, 0);
    if(!id.isEmpty()) {
        currentThread = currentGroup->value(id);
        connect(currentThread, SIGNAL(messageAdded(ForumMessage*)), this, SLOT(updateCurrentMessageModel()));
        connect(currentThread, SIGNAL(messageRemoved(ForumMessage*)), this, SLOT(updateCurrentMessageModel()));
        updateCurrentMessageModel();
    }
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

void SiilihaiMobile::registerUser(QString user, QString password, QString email, bool sync) {
    qDebug() << Q_FUNC_INFO << user << email << password;
    if(user.isEmpty() && password.isEmpty()) {
        // Use without account
        settings->setValue("account/noaccount", true);
        QMetaObject::invokeMethod(rootObject, "registrationFinished", Q_ARG(QVariant, true), Q_ARG(QVariant, ""));
        return;
    }
    regOrLoginUser = user.trimmed();
    regOrLoginPass = password.trimmed();
    connect(&protocol, SIGNAL(loginFinished(bool,QString,bool)), this, SLOT(registerFinished(bool,QString,bool)));
    protocol.registerUser(regOrLoginUser, regOrLoginPass, email, sync);
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
    }
    QMetaObject::invokeMethod(rootObject, "registrationFinished", Q_ARG(QVariant, success), Q_ARG(QVariant, motd));
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
    if(!regOrLoginUser.isEmpty()) {
        settings->setValue("account/username", regOrLoginUser);
        settings->setValue("account/password", regOrLoginPass);
        settings->sync();
    }
    QMetaObject::invokeMethod(rootObject, "loginFinished", Q_ARG(QVariant, success), Q_ARG(QVariant, motd));
}

void SiilihaiMobile::listSubscriptions() {
    connect(&protocol, SIGNAL(listForumsFinished(QList <ForumSubscription*>)), this, SLOT(listForumsFinished(QList <ForumSubscription*>)));
    protocol.listForums();
}

void SiilihaiMobile::listForumsFinished(QList <ForumSubscription*> forums) {
    qDebug() << Q_FUNC_INFO << forums.size();
    foreach(ForumSubscription *p, forums) {
        if(forumList.contains(p)) {
            p->deleteLater();
        } else {
            forumList.append(p);
        }
    }
    rootContext->setContextProperty("forumList", QVariant::fromValue(forumList));
}

void SiilihaiMobile::subscribeForum(int id, QString name) {
    subscribeForumWithCredentials(id, name, QString::null, QString::null);
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
}

void SiilihaiMobile::showSubscribeGroup(ForumSubscription* forum) {
    qDebug() << Q_FUNC_INFO << forum->toString();
    selectForum(forum->forumId());
    foreach(ForumGroup *fg, currentSub->values()) {
        subscribeGroupList.append(fg);
    }
    rootContext->setContextProperty("subscribeGroupList", QVariant::fromValue(subscribeGroupList));
    QMetaObject::invokeMethod(rootObject, "showSubscribeGroups");
}

void SiilihaiMobile::showSubscribeGroups(){
    qDebug() << Q_FUNC_INFO;
    if(!currentSub) return;
    showSubscribeGroup(currentSub);
}

void SiilihaiMobile::setGroupSubscribed(QString id, bool sub) {
    qDebug() << Q_FUNC_INFO << id << sub;
    if(!currentSub) return;
    ForumGroup *grp = currentSub->value(id);
    if(!grp) return;
    grp->setSubscribed(sub);
}

void SiilihaiMobile::applyGroupSubscriptions() {
    qDebug() << Q_FUNC_INFO;
    foreach(ForumGroup *group, currentSub->values()) {
        group->markToBeUpdated();
        group->setHasChanged(true);
        group->commitChanges();
    }
    selectForum(currentSub->forumId());
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
    threadSelected(QString::null);
    groupSelected(QString::null);
    selectForum(0);
    currentSub = 0;
    currentGroup = 0;
    currentThread = 0;
    unsubscribeForum(cs);
}

void SiilihaiMobile::getForumDetails(int id) {
    qDebug() << Q_FUNC_INFO << id;
    Q_ASSERT(id);
    if(newForum) {
        newForum->deleteLater();
    }
    newForum = 0;
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
        if(newForum->forumId()) {
            // Found
            QMetaObject::invokeMethod(rootObject, "forumDetails", Q_ARG(QVariant, newForum->forumId()), Q_ARG(QVariant, newForum->alias()), Q_ARG(QVariant, newForum->supportsLogin()));
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
        QMetaObject::invokeMethod(rootObject, "forumDetails", Q_ARG(QVariant, newForum->forumId()), Q_ARG(QVariant, newForum->alias()), Q_ARG(QVariant, newForum->supportsLogin()));
    } else {
        subscribeFailed("Adding forum failed, check log");
    }
}


void SiilihaiMobile::markThreadRead(bool read) {
    qDebug() << Q_FUNC_INFO << currentThread;
    if(!currentThread) return;
    foreach(ForumMessage *msg, currentThread->values()) {
        msg->setRead(read);
        msg->commitChanges();
    }
}

void SiilihaiMobile::changeState(siilihai_states newState) {
    ClientLogic::changeState(newState);
    QMetaObject::invokeMethod(rootObject, "setBusy",
                              Q_ARG(QVariant, newState != SH_READY && newState != SH_OFFLINE));
}

void SiilihaiMobile::showStatusMessage(QString message) {
    QMetaObject::invokeMethod(rootObject, "showStatusMessage", Q_ARG(QVariant, message));
}

void SiilihaiMobile::showMoreMessages() {
    qDebug() << Q_FUNC_INFO << currentThread;
    if(!currentThread) return;
    moreMessagesRequested(currentThread);
}

void SiilihaiMobile::haltSiilihai() {
    if(!haltRequested) {
        haltRequested = true;
        QMetaObject::invokeMethod(rootObject, "showHaltScreen");
        messageList.clear();
        threadList.clear();
        groupList.clear();
        subscriptionList.clear();

        setContextProperties();
    }
    ClientLogic::haltSiilihai();
}

bool SiilihaiMobile::isHaltRequested() {
    return haltRequested;
}

void SiilihaiMobile::openInBrowser(QString messageId) {
    if(!currentThread) return;
    ForumMessage *m = currentThread->value(messageId);
    if(m) QDesktopServices::openUrl(QUrl(m->url()));
}

int SiilihaiMobile::selectedForumId() const
{
    return m_selectedForumId;
}

void SiilihaiMobile::selectForum(int id) {
    qDebug() << Q_FUNC_INFO << id;
    if (m_selectedForumId != id) {
        m_selectedForumId = id;
        groupList.clear();
        currentSub = forumDatabase.value(id);
        currentGroup = 0;
        currentThread = 0;
        subscribeGroupList.clear();
        if(currentSub) {
            foreach(ForumGroup *fg, currentSub->values()) {
                if(fg->isSubscribed())
                    groupList.append(fg);
            }
        }
        rootContext->setContextProperty("groups", QVariant::fromValue(groupList));
        emit selectedForumChanged(id);
    }
}

void SiilihaiMobile::reloadUi() {
    qDebug() << Q_FUNC_INFO;
    QMetaObject::invokeMethod(this, "reloadUiReally", Qt::QueuedConnection);
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
