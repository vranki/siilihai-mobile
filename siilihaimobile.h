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
    Q_PROPERTY(int selectedForumId READ selectedForumId WRITE selectForum NOTIFY selectedForumChanged)
    Q_PROPERTY(QString selectedGroupId READ selectedGroupId WRITE selectGroup NOTIFY selectedGroupIdChanged)
    Q_PROPERTY(QString selectedThreadId READ selectedThreadId WRITE selectThread NOTIFY selectedThreadIdChanged)

public:
    explicit SiilihaiMobile(QObject *parent, QQuickView &view);
    bool isHaltRequested();
    int selectedForumId() const;
    QString selectedGroupId() const;
    QString selectedThreadId() const;
signals:
    void selectedForumChanged(int arg);
    void selectedGroupIdChanged(QString arg);
    void selectedThreadIdChanged(QString arg);

public slots:
    virtual void haltSiilihai();
    void selectForum(int id=0);
    void selectGroup(QString id=QString::null);
    void selectThread(QString id=QString::null);
    void reloadUi();
    void dismissMessages();
    void registerUser(QString user, QString password, QString email, bool sync);
    void loginUser(QString user, QString password);
    void listSubscriptions();
    void subscribeForum(int id, QString name);
    void subscribeForumWithCredentials(int id, QString name, QString username, QString password);
    void getForumDetails(int id);
    void getForumUrlDetails(QString url);

private slots:
    virtual void subscribeForum();
    virtual void subscriptionFound(ForumSubscription *sub);
    virtual void subscriptionDeleted(QObject* subobj);
    void registerFinished(bool success, QString motd, bool sync);
    void loginFinished(bool success, QString motd, bool sync);
    void sendParserReportFinished(bool success);
    void listForumsFinished(QList <ForumSubscription*>);
    void showSubscribeGroups();
    void setGroupSubscribed(QString id, bool sub);
    void applyGroupSubscriptions();
    void credentialsEntered(QString u, QString p, bool remember);
    void unsubscribeCurrentForum();
    void showMoreMessages();
    void updateCurrentMessageModel();
    void probeResults(ForumSubscription *probedSub);
    void newForumAdded(ForumSubscription *sub);
    void reloadUiReally();

protected:
    virtual void changeState(siilihai_states newState);
    virtual void showLoginWizard();
    virtual void errorDialog(QString message);
    virtual void closeUi();
    virtual void showMainWindow();
    virtual void showSubscribeGroup(ForumSubscription* forum);
    virtual void showCredentialsDialog(CredentialsRequest *cr);

private:
    void subscribeFailed(QString reason);
    void setContextProperties();

    QQuickView &qQuickView;
    // @todo check if qt quick has smarter way for this
    QList<QObject*> subscriptionList, groupList, threadList, messageList, forumList, subscribeGroupList;
    QStringList errorMessageList;
    QQmlContext* rootContext;
    QQuickItem *rootObject;
    ForumSubscription *currentSub;
    ForumGroup *currentGroup;
    ForumThread *currentThread;
    QString regOrLoginUser, regOrLoginPass;
    bool haltRequested;
    ForumSubscription *newForum; // the one being subscribed
    ForumProbe probe;
};

#endif // SIILIHAIMOBILE_H
