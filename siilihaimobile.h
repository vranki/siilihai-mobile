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

public:
    explicit SiilihaiMobile(QObject *parent, QQuickView *view);
    bool isHaltRequested() const;
    void setContextProperties();
    bool noBackButton() const; // Don't show back button in UI (=Android)

signals:
    void messagePosted(QString err);

public slots:
    virtual void haltSiilihai();
    void reloadUi();
    void dismissMessages();
    void registerUser(QString user, QString password, QString email, bool sync);
    void loginUser(QString user, QString password);
    virtual void subscribeForum(); // Call to show dialog
    void subscribeForumWithCredentials(int id, QString name, QString username=QString::null, QString password=QString::null);
    void getForumDetails(int id);
    void getForumUrlDetails(QString url);
    void showSubscribeGroups(ForumSubscription *sub); // Remember to call applyGroupSubscriptions afterwards!
    void applyGroupSubscriptions();
    void credentialsEntered(QString u, QString p, bool remember);
    void postMessage(ForumSubscription *sub, QString grpId, QString thrId, QString subject, QString body);

private slots:
    void registerFinished(bool success, QString motd, bool sync);
    void loginFinished(bool success, QString motd, bool sync);
    void sendParserReportFinished(bool success);
    void listForumsFinished(QList <ForumSubscription*>);

    void probeResults(ForumSubscription *probedSub);
    void newForumAdded(ForumSubscription *sub);
    void reloadUiReally();

protected:
    virtual void showLoginWizard();
    virtual void errorDialog(QString message);
    virtual void closeUi();
    virtual void showMainWindow();
    virtual void showCredentialsDialog();

private:
    void subscribeFailed(QString reason);
    void deleteNewForum();
    void setObjectProperty(QString objectName, QString property, QString value);
    static bool sortThreadsByOrdernum(QObject *a, QObject *b);
    static bool sortMessagesByOrdernum(QObject *a, QObject *b);

    QQuickView *qQuickView;
    // @todo check if qt quick has smarter way for this
    QList<QObject*> subscribeGroupList, forumList;
    QStringList errorMessageList;
    QQuickView *quickView;
    QString regOrLoginUser, regOrLoginPass;
    bool haltRequested;
    ForumSubscription *newForum; // the one being subscribed
    ForumProbe probe;
    // True if user just added a forum.
    bool forumWasSubscribedByUser;
};

#endif // SIILIHAIMOBILE_H
