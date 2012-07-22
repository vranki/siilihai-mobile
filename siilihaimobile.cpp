#include "siilihaimobile.h"
#include <QDesktopServices>
#include <QDebug>
#include <siilihai/parsermanager.h>
#include <siilihai/forumgroup.h>
#include <siilihai/forumthread.h>
#include <siilihai/forummessage.h>
#include <siilihai/forumsubscription.h>
#include <siilihai/forumparser.h>

SiilihaiMobile::SiilihaiMobile(QObject *parent, QDeclarativeContext* ctx, QObject *rootObj) :
    ClientLogic(parent), rootContext(ctx), rootObject(rootObj), currentSub(0), currentGroup(0),
    currentThread(0), haltRequested(false)
{
    if(!rootContext)  {
        closeUi();
        return;
    }
    rootContext->setContextProperty("subscriptions", QVariant::fromValue(subscriptionList));
    rootContext->setContextProperty("groups", QVariant::fromValue(groupList));
    rootContext->setContextProperty("threads", QVariant::fromValue(threadList));
    rootContext->setContextProperty("messages", QVariant::fromValue(messageList));
    QObject *appWindow = rootObject;
    Q_ASSERT(appWindow);
    connect(appWindow, SIGNAL(subscriptionSelected(int)), this, SLOT(subscriptionSelected(int)));
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
    connect(appWindow, SIGNAL(getParserDetails(int)), this, SLOT(getParserDetails(int)));
    connect(appWindow, SIGNAL(markThreadRead(bool)), this, SLOT(markThreadRead(bool)));
    connect(appWindow, SIGNAL(showMoreMessages()), this, SLOT(showMoreMessages()));
    connect(appWindow, SIGNAL(updateClicked()), this, SLOT(updateClicked()));
    connect(appWindow, SIGNAL(openInBrowser(QString)), this, SLOT(openInBrowser(QString)));
    messageDisplayed = true;
    offlineModeSet(true);
}

QString SiilihaiMobile::getDataFilePath() {
//    return "/home/cosmo/.local/share/data/Siilihai/Siilihai";
    return QDesktopServices::storageLocation(QDesktopServices::DataLocation);
}

void SiilihaiMobile::subscribeForum() {
    qDebug() << Q_FUNC_INFO;
    QMetaObject::invokeMethod(rootObject, "showSubscribeWizard");
}

void SiilihaiMobile::showLoginWizard() {
    qDebug() << Q_FUNC_INFO;
    QMetaObject::invokeMethod(rootObject, "showLoginWizard");
}

void SiilihaiMobile::errorDialog(QString message) {
    qDebug() << Q_FUNC_INFO << message;
    messageQueue.append(message);
    displayNextMessage();
}

void SiilihaiMobile::displayNextMessage() {
    qDebug() << Q_FUNC_INFO;
    if(messageDisplayed) return;
    if(messageQueue.isEmpty()) return;
    QVariant msg = messageQueue.takeFirst();
    QMetaObject::invokeMethod(rootObject, "showMessage", Q_ARG(QVariant, msg));
}

void SiilihaiMobile::closeUi() {
    qDebug() << Q_FUNC_INFO;
    QCoreApplication::quit();
}

void SiilihaiMobile::showMainWindow() {
    qDebug() << Q_FUNC_INFO;
    qDebug() << "Settings at " << settings->fileName();
    messageDisplayed = false;
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
        subscriptionSelected(0);
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

void SiilihaiMobile::subscriptionSelected(int parser) {
    qDebug() << Q_FUNC_INFO << parser;
    groupList.clear();
    currentSub = forumDatabase.value(parser);
    currentGroup = 0;
    currentThread = 0;
    if(currentSub) {
        foreach(ForumGroup *fg, currentSub->values()) {
            if(fg->isSubscribed())
                groupList.append(fg);
        }
    }
    rootContext->setContextProperty("groups", QVariant::fromValue(groupList));
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
    connect(&protocol, SIGNAL(listParsersFinished(QList <ForumParser*>)), this, SLOT(listParsersFinished(QList <ForumParser*>)));
    protocol.listParsers();
}

void SiilihaiMobile::listParsersFinished(QList <ForumParser*> parsers) {
    qDebug() << Q_FUNC_INFO << parsers.size();
    foreach(ForumParser *p, parsers) {
        parserList.append(p);
    }
    rootContext->setContextProperty("parserList", QVariant::fromValue(parserList));
}

void SiilihaiMobile::subscribeForum(int id, QString name) {
    subscribeForumWithCredentials(id, name, QString::null, QString::null);
}

void SiilihaiMobile::subscribeForumWithCredentials(int id, QString name, QString username, QString password) {
    qDebug() << Q_FUNC_INFO << id << name << username << password;
    ForumParser *fp = parserManager->getParser(id);
    Q_ASSERT(fp);
    ForumSubscription fs(this);
    fs.setParser(fp->id());
    fs.setAlias(fp->name());
    if(!username.isEmpty()) {
        fs.setUsername(username);
        fs.setPassword(password);
    }
    fs.setLatestThreads(settings->value("preferences/threads_per_group", 20).toInt());
    fs.setLatestMessages(settings->value("preferences/messages_per_thread", 20).toInt());

    Q_ASSERT(fp->isSane());
    forumAdded(&fs);
}

void SiilihaiMobile::showSubscribeGroup(ForumSubscription* forum) {
    subscriptionSelected(forum->parser());
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
    subscriptionSelected(currentSub->parser());
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
    subscriptionSelected(0);
    currentSub = 0;
    currentGroup = 0;
    currentThread = 0;
    unsubscribeForum(cs);
}

void SiilihaiMobile::getParserDetails(int id) {
    qDebug() << Q_FUNC_INFO << id;
    Q_ASSERT(id);
    connect(&protocol, SIGNAL(getParserFinished(ForumParser*)), this, SLOT(getParserFinished(ForumParser*)));
    protocol.getParser(id);
}

void SiilihaiMobile::getParserFinished(ForumParser* parser) {
    qDebug() << Q_FUNC_INFO << parser;
    if(!parser) return;
    disconnect(&protocol, SIGNAL(getParserFinished(ForumParser*)), this, SLOT(getParserFinished(ForumParser*)));
    QMetaObject::invokeMethod(rootObject, "parserDetails", Q_ARG(QVariant, parser->id()), Q_ARG(QVariant, parser->supportsLogin()));
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
    QMetaObject::invokeMethod(rootObject, "setBusy", Q_ARG(QVariant, newState != SH_READY));
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
    haltRequested = true;
    QMetaObject::invokeMethod(rootObject, "showHaltScreen");
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
