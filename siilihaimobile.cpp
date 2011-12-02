#include "siilihaimobile.h"
#include <QDesktopServices>
#include <QDebug>

SiilihaiMobile::SiilihaiMobile(QObject *parent, QDeclarativeContext* ctx, QObject *rootObj) :
    ClientLogic(parent), rootContext(ctx), rootObject(rootObj)
{
    rootContext->setContextProperty("subscriptions", QVariant::fromValue(subscriptionList));
    rootContext->setContextProperty("groups", QVariant::fromValue(groupList));
    rootContext->setContextProperty("threads", QVariant::fromValue(threadList));
    rootContext->setContextProperty("messages", QVariant::fromValue(messageList));
    QObject *appWindow = rootObject;
    /*
    qDebug() << appWindow->objectName();
    foreach(QObject *c, appWindow->children()) {
            qDebug() << "\t" << c->objectName();
    }
    */
    connect(appWindow, SIGNAL(subscriptionSelected(int)), this, SLOT(subscriptionSelected(int)));
    connect(appWindow, SIGNAL(groupSelected(QString)), this, SLOT(groupSelected(QString)));
    connect(appWindow, SIGNAL(threadSelected(QString)), this, SLOT(threadSelected(QString)));
    connect(appWindow, SIGNAL(haltSiilihai()), this, SLOT(haltSiilihai()));
    connect(appWindow, SIGNAL(registerUser(QString, QString, QString, bool)), this, SLOT(registerUser(QString,QString,QString,bool)));
    connect(appWindow, SIGNAL(loginUser(QString, QString)), this, SLOT(loginUser(QString,QString)));

    messageDisplayed = true;
}

QString SiilihaiMobile::getDataFilePath() {
//    return "/home/cosmo/.local/share/data/Siilihai/Siilihai";
    return QDesktopServices::storageLocation(QDesktopServices::DataLocation);
}

void SiilihaiMobile::subscribeForum() {
    qDebug() << Q_FUNC_INFO;
    errorDialog(Q_FUNC_INFO);
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
    ClientLogic::subscriptionDeleted(subobj);
    ForumSubscription *sub = static_cast<ForumSubscription*> (subobj);
    subscriptionList.removeAll(sub);
    rootContext->setContextProperty("subscriptions", QVariant::fromValue(subscriptionList));
}

void SiilihaiMobile::showCredentialsDialog(ForumSubscription *fsub, QAuthenticator * authenticator) {
    qDebug() << Q_FUNC_INFO;
    Q_ASSERT(false);
}

void SiilihaiMobile::subscriptionSelected(int parser) {
    qDebug() << Q_FUNC_INFO << parser;
    groupList.clear();
    currentSub = forumDatabase.value(parser);
    currentGroup = 0;
    currentThread = 0;
    foreach(ForumGroup *fg, currentSub->values()) {
        if(fg->isSubscribed())
            groupList.append(fg);
    }
    rootContext->setContextProperty("groups", QVariant::fromValue(groupList));
}

void SiilihaiMobile::groupSelected(QString id) {
    qDebug() << Q_FUNC_INFO << id;
    threadList.clear();
    currentGroup = currentSub->value(id);
    currentThread = 0;
    foreach(ForumThread *ft, currentGroup->values()) {
        threadList.append(ft);
    }
    rootContext->setContextProperty("threads", QVariant::fromValue(threadList));
}

void SiilihaiMobile::threadSelected(QString id) {
    qDebug() << Q_FUNC_INFO << id;
    messageList.clear();
    currentThread = currentGroup->value(id);
    foreach(ForumMessage *fm, currentThread->values()) {
        messageList.append(fm);
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
    ClientLogic::loginFinished(success, motd, sync);
    disconnect(&protocol, SIGNAL(loginFinished(bool,QString,bool)), this, SLOT(loginFinished(bool,QString,bool)));
    settings->setValue("account/username", regOrLoginUser);
    settings->setValue("account/password", regOrLoginPass);
    settings->sync();
    QMetaObject::invokeMethod(rootObject, "loginFinished", Q_ARG(QVariant, success), Q_ARG(QVariant, motd));
}
