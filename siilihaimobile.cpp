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

SiilihaiMobile::SiilihaiMobile(QObject *parent) :
    ClientLogic(parent)
  , haltRequested(false)
  , forumWasSubscribedByUser(false)
{
    qmlRegisterType<UpdateError>("org.vranki.siilihai", 1, 0, "UpdateError");
    qmlRegisterType<SiilihaiMobile>("org.vranki.siilihai", 1, 0, "SiilihaiMobile");
    qRegisterMetaType<SiilihaiState>();
}

void SiilihaiMobile::errorDialog(QString message) {
    qDebug() << Q_FUNC_INFO << message;
    m_errorMessages.append(message);
    emit errorMessagesChanged(m_errorMessages);
}

void SiilihaiMobile::dismissMessages() {
    m_errorMessages.clear();
    emit errorMessagesChanged(m_errorMessages);
}

void SiilihaiMobile::closeUi() {
    if(!QCoreApplication::closingDown())
        QCoreApplication::quit();
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
}

bool SiilihaiMobile::noBackButton() const
{
#ifdef NO_BACK_BUTTON
    return true;
#endif
    return false;
}

QStringList SiilihaiMobile::errorMessages() const
{
    return m_errorMessages;
}

bool SiilihaiMobile::sortMessagesByOrdernum(QObject *a, QObject *b) {
    return qobject_cast<ForumMessage*>(a)->ordernum() < qobject_cast<ForumMessage*>(b)->ordernum();
}

void SiilihaiMobile::registerUser(QString user, QString password, QString email, bool sync) {
    if(user.isEmpty() && password.isEmpty()) {
        // Use without account
        m_settings->setValue("account/noaccount", true);
        emit ClientLogic::loginFinished(true, QString::null, false);
    } else {
        regOrLoginUser = user.trimmed();
        regOrLoginPass = password.trimmed();
        connect(&m_protocol, SIGNAL(loginFinished(bool,QString,bool)), this, SLOT(registerFinished(bool,QString,bool)));
        m_protocol.registerUser(regOrLoginUser, regOrLoginPass, email, sync);
    }
}

void SiilihaiMobile::registerFinished(bool success, QString motd, bool sync) {
    disconnect(&m_protocol, SIGNAL(loginFinished(bool,QString,bool)), this, SLOT(registerFinished(bool,QString,bool)));
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
}

void SiilihaiMobile::haltSiilihai() {
    haltRequested = true;
    ClientLogic::haltSiilihai();
}

void SiilihaiMobile::setView(QQuickView *view)
{
    qQuickView = view;
    if(!view->rootContext())  {
        closeUi();
        return;
    }
    qQuickView->rootContext()->setContextProperty("siilihai", this);
    dismissMessages();
    setContextProperties();
}

bool SiilihaiMobile::isHaltRequested() const {
    return haltRequested;
}

void SiilihaiMobile::reloadUi() {
    QMetaObject::invokeMethod(this, "reloadUiReally", Qt::QueuedConnection);
}

void SiilihaiMobile::reloadUiReally() {
    QUrl src = qQuickView->source();
    qQuickView->engine()->clearComponentCache();
    qQuickView->setSource(QUrl());
    qQuickView->engine()->clearComponentCache();
    qQuickView->setSource(src);
    setContextProperties();
}
