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
#include <siilihai/siilihaisettings.h>

SiilihaiMobile::SiilihaiMobile(QObject *parent, QQuickView *view) :
    ClientLogic(parent), qQuickView(view), currentSub(0), currentGroup(0), currentThread(0), haltRequested(false), newForum(0),
    probe(0, protocol), forumWasSubscribedByUser(false) {
    if(!view->rootContext())  {
        closeUi();
        return;
    }
    dismissMessages();
    setContextProperties();
    connect(&protocol, SIGNAL(listForumsFinished(QList <ForumSubscription*>)), this, SLOT(listForumsFinished(QList <ForumSubscription*>)));
}

void SiilihaiMobile::subscribeForum() {
    qDebug() << Q_FUNC_INFO;
    deleteNewForum();
    setObjectProperty("subscribeForumDialog", "topItem", "true");
    protocol.listForums();
}

// Receiver owns the forums!
void SiilihaiMobile::listForumsFinished(QList <ForumSubscription*> forums) {
    qDebug() << Q_FUNC_INFO << forums.size();
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
    qDebug() << Q_FUNC_INFO << "Settings at " << settings->fileName();
    qQuickView->rootContext()->setContextProperty("siilihaisettings", settings);
    if(state() == SH_OFFLINE)
        showStatusMessage("Started in offline mode");
}

void SiilihaiMobile::subscriptionFound(ForumSubscription *sub) {
    ClientLogic::subscriptionFound(sub);
    qDebug() << Q_FUNC_INFO << sub->toString();
    subscriptionList.append(sub);
    qQuickView->rootContext()->setContextProperty("subscriptions", QVariant::fromValue(subscriptionList));
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

void SiilihaiMobile::groupDeleted() {
    qDebug() << Q_FUNC_INFO;
    ForumGroup *grp = static_cast<ForumGroup*>(sender());
    updateCurrentGroupModel();
    subscribeGroupList.removeAll(grp);
    qQuickView->rootContext()->setContextProperty("subscribeGroupList", QVariant::fromValue(subscribeGroupList));
}

void SiilihaiMobile::threadDeleted() {
    qDebug() << Q_FUNC_INFO;
    // ForumThread *thr = static_cast<ForumThread*>(sender());
    updateCurrentThreadModel();
}

void SiilihaiMobile::messageDeleted() {
    qDebug() << Q_FUNC_INFO;
    updateCurrentMessageModel();
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

void SiilihaiMobile::postMessage(QString grpId, QString thrId, QString subject, QString body) {
    if(!currentSub || !currentSub->updateEngine()) {
        emit messagePosted("No forum selected!");
        return;
    }
    ForumGroup *grp = currentSub->value(grpId);
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
    if(currentSub->updateEngine()->postMessage(grp, thr, subject, body)) {
        emit messagePosted(QString::null);
    } else {
        emit messagePosted("Sending message failed");
    }
}

void SiilihaiMobile::groupListChanged(ForumSubscription *sub) {
    qDebug() << Q_FUNC_INFO << sub->toString();
    // Show subscribe groups after subbing a new forum
    if(forumWasSubscribedByUser && (currentSub == sub || !currentSub)) {
        selectForum(sub->id());
        showSubscribeGroups();
    }
}

void SiilihaiMobile::subscribeFailed(QString reason) {
    QMetaObject::invokeMethod(qQuickView->rootObject(), "subscribeFailed", Q_ARG(QVariant, reason));
}

void SiilihaiMobile::setContextProperties() {
    QQmlContext *rootContext = qQuickView->rootContext();
    rootContext->setContextProperty("siilihaimobile", this);
    rootContext->setContextProperty("subscriptions", QVariant::fromValue(subscriptionList));
    rootContext->setContextProperty("groups", QVariant::fromValue(groupList));
    rootContext->setContextProperty("threads", QVariant::fromValue(threadList));
    rootContext->setContextProperty("messages", QVariant::fromValue(messageList));
    rootContext->setContextProperty("subscribeGroupList", QVariant::fromValue(subscribeGroupList));
    rootContext->setContextProperty("messageQueue", QVariant::fromValue(errorMessageList));

    rootContext->setContextProperty("selectedforum", currentSub);
    rootContext->setContextProperty("selectedgroup", currentGroup);
    rootContext->setContextProperty("selectedthread", currentThread);
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

void SiilihaiMobile::updateCurrentMessageModel() {
    messageList.clear();
    if(currentThread) {
        foreach(ForumMessage *fm, currentThread->values()) {
            messageList.append(fm);
            connect(fm, SIGNAL(destroyed()), this, SLOT(messageDeleted()));
        }
    }
    qSort(messageList.begin(), messageList.end(), sortMessagesByOrdernum);
    qQuickView->rootContext()->setContextProperty("messages", QVariant::fromValue(messageList));
}

bool SiilihaiMobile::sortThreadsByOrdernum(QObject *a, QObject *b) {
    return qobject_cast<ForumThread*>(a)->ordernum() < qobject_cast<ForumThread*>(b)->ordernum();
}

void SiilihaiMobile::updateCurrentThreadModel() {
    threadList.clear();
    if(currentGroup) {
        foreach(ForumThread *ft, currentGroup->values()) {
            threadList.append(ft);
            connect(ft, SIGNAL(destroyed()), this, SLOT(threadDeleted()));
        }
    }
    qSort(threadList.begin(), threadList.end(), sortThreadsByOrdernum);
    qQuickView->rootContext()->setContextProperty("threads", QVariant::fromValue(threadList));
}

void SiilihaiMobile::updateCurrentGroupModel() {
    groupList.clear();
    if(currentSub) {
        foreach(ForumGroup *fg, currentSub->values()) {
            if(fg->isSubscribed()) {
                groupList.append(fg);
                connect(fg, SIGNAL(destroyed()), this, SLOT(groupDeleted()));
            }
        }
    }
    qQuickView->rootContext()->setContextProperty("groups", QVariant::fromValue(groupList));
}

void SiilihaiMobile::registerUser(QString user, QString password, QString email, bool sync) {
    qDebug() << Q_FUNC_INFO << user << email << password;
    if(user.isEmpty() && password.isEmpty()) {
        // Use without account
        settings->setValue("account/noaccount", true);
        QObject *lw = qQuickView->rootObject()->findChild<QObject*>("loginWizard");
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
        settings->setUsername(regOrLoginUser);
        settings->setPassword(regOrLoginPass);
        settings->setSyncEnabled(sync);
        settings->setValue("account/registered_here", true);
        settings->sync();
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
    connect(&protocol, SIGNAL(loginFinished(bool,QString,bool)), this, SLOT(loginFinished(bool,QString,bool)));
    protocol.login(user, password);
}

void SiilihaiMobile::loginFinished(bool success, QString motd, bool sync) {
    qDebug() << Q_FUNC_INFO;
    ClientLogic::loginFinished(success, motd, sync);
    disconnect(&protocol, SIGNAL(loginFinished(bool,QString,bool)), this, SLOT(loginFinished(bool,QString,bool)));
    if(success && !regOrLoginUser.isEmpty()) {
        settings->setUsername(regOrLoginUser);
        settings->setPassword(regOrLoginPass);
        settings->sync();
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
    newForum->setLatestThreads(settings->threadsPerGroup());
    newForum->setLatestMessages(settings->messagesPerThread());
    forumWasSubscribedByUser = true;
    forumAdded(newForum);
    Q_ASSERT(forumDatabase.contains(newForum->id()));
    selectForum(newForum->id());
    deleteNewForum();
}

void SiilihaiMobile::showSubscribeGroups() {
    Q_ASSERT(currentSub);
    qDebug() << Q_FUNC_INFO << currentSub->toString();
    subscribeGroupList.clear();
    qQuickView->rootContext()->setContextProperty("subscribeGroupList", 0);
    foreach(ForumGroup *fg, currentSub->values()) {
        subscribeGroupList.append(fg);
    }
    qQuickView->rootContext()->setContextProperty("subscribeGroupList", QVariant::fromValue(subscribeGroupList));
    setObjectProperty("forumSettingsDialog", "topItem", "true");
    forumWasSubscribedByUser=true;
}

// And authentications also!
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
    forumUpdateNeeded(currentSub); // Send credentials
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
            connect(&protocol, SIGNAL(forumGot(ForumSubscription*)), this, SLOT(newForumAdded(ForumSubscription*)));
            protocol.addForum(newForum);
        }
    }
}

void SiilihaiMobile::newForumAdded(ForumSubscription *sub) {
    disconnect(&protocol, SIGNAL(forumGot(ForumSubscription*)), this, SLOT(newForumAdded(ForumSubscription*)));
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

void SiilihaiMobile::showMoreMessages() {
    qDebug() << Q_FUNC_INFO << currentThread;
    if(!currentThread) return;
    moreMessagesRequested(currentThread);
}

void SiilihaiMobile::haltSiilihai() {
    qDebug() << Q_FUNC_INFO;
    haltRequested = true;
    ClientLogic::haltSiilihai();
}

bool SiilihaiMobile::isHaltRequested() const {
    return haltRequested;
}

void SiilihaiMobile::selectForum(int id) {
    qDebug() << Q_FUNC_INFO << id;

    if(currentSub !=  forumDatabase.value(id)) {
        selectGroup();
        if(currentSub) {
            foreach(ForumGroup *grp, currentSub->values()) {
                disconnect(grp, SIGNAL(destroyed()), this, 0);
            }
        }
        currentSub = forumDatabase.value(id);
        subscribeGroupList.clear();
        qQuickView->rootContext()->setContextProperty("selectedforum", currentSub);

        updateCurrentGroupModel();
        if(currentSub) { // Show subscribe groups if none are subbed
            int subscribedGroups = 0;
            foreach(ForumGroup *grp, currentSub->values()) {
                if(grp->isSubscribed()) subscribedGroups++;
            }
            if(!subscribedGroups) showSubscribeGroups();
        }
    }
}

void SiilihaiMobile::selectGroup(QString id) {
    qDebug() << Q_FUNC_INFO << id;
    Q_ASSERT(currentSub || id.isEmpty());
    if (!currentGroup || currentGroup->id() != id) {
        selectThread();
        if(currentGroup) {
            foreach(ForumThread *thr, currentGroup->values()){
                disconnect(thr, SIGNAL(destroyed()), this, 0);
            }
            disconnect(currentGroup, SIGNAL(destroyed()), this, 0);
        }
        currentGroup = currentSub ? currentSub->value(id) : 0;
        qQuickView->rootContext()->setContextProperty("selectedgroup", currentGroup);
        updateCurrentThreadModel();
    }
}

void SiilihaiMobile::selectThread(QString id) {
    qDebug() << Q_FUNC_INFO << id;
    Q_ASSERT(currentGroup || id.isEmpty());
    if(!currentThread || currentThread->id() != id) {
        if(currentThread) {
            foreach(ForumMessage *msg, currentThread->values()) {
                disconnect(msg, SIGNAL(destroyed()), this, 0);
            }
            disconnect(currentThread, 0, this, 0);
        }
        currentThread = 0;
        if(currentGroup) currentThread = currentGroup->value(id);
        if(currentThread) {
            connect(currentThread, SIGNAL(messageAdded(ForumMessage*)), this, SLOT(updateCurrentMessageModel()));
            connect(currentThread, SIGNAL(messageRemoved(ForumMessage*)), this, SLOT(updateCurrentMessageModel()));
        }
        updateCurrentMessageModel();
        qQuickView->rootContext()->setContextProperty("selectedthread", currentThread);
    }
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
