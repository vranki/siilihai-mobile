#ifndef SIILIHAIMOBILE_H
#define SIILIHAIMOBILE_H

#include <siilihai/clientlogic.h>
#include <siilihai/forumdata/forumsubscription.h>
#include <siilihai/forumprobe.h>
#include <QStringList>
#include <QQmlContext>
#include <QQuickItem>
#include <QtQuick/QQuickView>

class SiilihaiMobile : public ClientLogic
{
    Q_OBJECT
    Q_PROPERTY(bool noBackButton READ noBackButton CONSTANT)
    Q_PROPERTY(QStringList errorMessages READ errorMessages NOTIFY errorMessagesChanged)

public:
    explicit SiilihaiMobile(QObject *parent, QQuickView *view);
    bool isHaltRequested() const;
    void setContextProperties();
    bool noBackButton() const; // Don't show back button in UI (=Android)
    QStringList errorMessages() const;

signals:
    void messagePosted(QString err);
    void showSubscribeForumDialog();
    void showForumSettingsDialog(ForumSubscription *sub);
    void errorMessagesChanged(QStringList errorMessages);

public slots:
    virtual void haltSiilihai();
    void reloadUi();
    void dismissMessages(); // Call to clear error message list
    void registerUser(QString user, QString password, QString email, bool sync);
    void postMessage(ForumSubscription *sub, QString grpId, QString thrId, QString subject, QString body);
    virtual void subscribeForum();

private slots:
    void registerFinished(bool success, QString motd, bool sync);
    void reloadUiReally();

protected:
    virtual void errorDialog(QString message);
    virtual void closeUi();

private:
    void subscribeFailed(QString reason);
    static bool sortThreadsByOrdernum(QObject *a, QObject *b);
    static bool sortMessagesByOrdernum(QObject *a, QObject *b);

    QQuickView *qQuickView;
    QString regOrLoginUser, regOrLoginPass;
    bool haltRequested;
    // True if user just added a forum.
    bool forumWasSubscribedByUser;
    QStringList m_errorMessages;
};

#endif // SIILIHAIMOBILE_H
