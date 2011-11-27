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
    qDebug() << appWindow->objectName();
    foreach(QObject *c, appWindow->children()) {
            qDebug() << "\t" << c->objectName();
    }


    connect(appWindow, SIGNAL(subscriptionSelected(int)), this, SLOT(subscriptionSelected(int)));
    connect(appWindow, SIGNAL(groupSelected(QString)), this, SLOT(groupSelected(QString)));
    connect(appWindow, SIGNAL(threadSelected(QString)), this, SLOT(threadSelected(QString)));
    connect(appWindow, SIGNAL(haltSiilihai()), this, SLOT(haltSiilihai()));
    //Q_ASSERT(false);
}

QString SiilihaiMobile::getDataFilePath() {
    return "/home/cosmo/.local/share/data/Siilihai/Siilihai";
//    return QDesktopServices::storageLocation(QDesktopServices::DataLocation);
}

void SiilihaiMobile::subscribeForum() {
    qDebug() << Q_FUNC_INFO;
}

void SiilihaiMobile::showLoginWizard() {
    qDebug() << Q_FUNC_INFO;
}

void SiilihaiMobile::errorDialog(QString message) {
    qDebug() << Q_FUNC_INFO << message;
//    Q_ASSERT(false);
}

void SiilihaiMobile::closeUi() {
    qDebug() << Q_FUNC_INFO;
    QCoreApplication::quit();
}

void SiilihaiMobile::showMainWindow() {
    qDebug() << Q_FUNC_INFO;
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
