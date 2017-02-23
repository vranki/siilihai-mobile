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
    ClientLogic(parent), qQuickView(view), haltRequested(false),
    forumWasSubscribedByUser(false) {
    qmlRegisterType<UpdateError>("org.vranki.siilihai", 1, 0, "UpdateError");

    if(!view->rootContext())  {
        closeUi();
        return;
    }
    qQuickView->rootContext()->setContextProperty("siilihai", this);
    dismissMessages();
    setContextProperties();
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

void SiilihaiMobile::subscribeForum() {
    emit showSubscribeForumDialog();
}

void SiilihaiMobile::subscribeFailed(QString reason) {
    QMetaObject::invokeMethod(qQuickView->rootObject(), "subscribeFailed", Q_ARG(QVariant, reason));
}

void SiilihaiMobile::setContextProperties() {
    QQmlContext *rootContext = qQuickView->rootContext();
    rootContext->setContextProperty("siilihaimobile", this);
    rootContext->setContextProperty("messageQueue", QVariant::fromValue(errorMessageList));
}

bool SiilihaiMobile::noBackButton() const
{
#ifdef NO_BACK_BUTTON
    return true;
#endif
    return false;
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

void SiilihaiMobile::loginUser(QString user, QString password) {
    qDebug() << Q_FUNC_INFO << user;
    regOrLoginUser = user.trimmed();
    regOrLoginPass = password.trimmed();
    // connect(&m_protocol, SIGNAL(loginFinished(bool,QString,bool)), this, SLOT(loginFinished(bool,QString,bool)));
    m_protocol.login(user, password);
}
/*
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
*/

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
