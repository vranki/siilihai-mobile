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
    Q_PROPERTY(bool noBackButton READ noBackButton CONSTANT)

public:
    explicit SiilihaiMobile(QObject *parent, QQuickView *view);
    bool isHaltRequested() const;
    int selectedForumId() const;
    QString selectedGroupId() const;
    QString selectedThreadId() const;
    void setContextProperties();
    bool noBackButton() const; // Don't show back button in UI (=Android)
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
    virtual void subscribeForum(); // Call to show dialog
    void subscribeForumWithCredentials(int id, QString name, QString username=QString::null, QString password=QString::null);
    void getForumDetails(int id);
    void getForumUrlDetails(QString url);
    void unsubscribeCurrentForum();
    void showMoreMessages();
    void showSubscribeGroups(); // Remember to call applyGroupSubscriptions afterwards!
    void applyGroupSubscriptions();
    void credentialsEntered(QString u, QString p, bool remember);

private slots:
    virtual void subscriptionFound(ForumSubscription *sub);
    virtual void subscriptionDeleted(QObject* subobj);
    void groupDeleted();
    void threadDeleted();
    void messageDeleted();

    void registerFinished(bool success, QString motd, bool sync);
    void loginFinished(bool success, QString motd, bool sync);
    void sendParserReportFinished(bool success);
    void listForumsFinished(QList <ForumSubscription*>);
    void updateCurrentMessageModel();
    void updateCurrentThreadModel();
    void updateCurrentGroupModel(); // Updates the "groups" list
    void probeResults(ForumSubscription *probedSub);
    void newForumAdded(ForumSubscription *sub);
    void reloadUiReally();

protected:
    virtual void showLoginWizard();
    virtual void errorDialog(QString message);
    virtual void closeUi();
    virtual void showMainWindow();
    virtual void showCredentialsDialog();
    virtual void groupListChanged(ForumSubscription* sub);

private:
    void subscribeFailed(QString reason);
    void deleteNewForum();
    void setObjectProperty(QString objectName, QString property, QString value);

    QQuickView *qQuickView;
    // @todo check if qt quick has smarter way for this
    QList<QObject*> subscriptionList, groupList, threadList, messageList, forumList, subscribeGroupList;
    QStringList errorMessageList;
    QQuickView *quickView;
    ForumSubscription *currentSub;
    ForumGroup *currentGroup;
    ForumThread *currentThread;
    QString regOrLoginUser, regOrLoginPass;
    bool haltRequested;
    ForumSubscription *newForum; // the one being subscribed
    ForumProbe probe;
    // True if user just added a forum.
    bool forumWasSubscribedByUser;
};

#endif // SIILIHAIMOBILE_H
