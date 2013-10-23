#ifndef SIILIHAIMOBILE_H
#define SIILIHAIMOBILE_H

#include <siilihai/clientlogic.h>
#include <siilihai/forumdata/forumsubscription.h>
#include <siilihai/forumprobe.h>
#include <QStringList>
#include <QTimer>
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

private slots:
    virtual void subscribeForum();
    virtual void subscriptionFound(ForumSubscription *sub);
    virtual void subscriptionDeleted(QObject* subobj);
    void registerUser(QString user, QString password, QString email, bool sync);
    void registerFinished(bool success, QString motd, bool sync);
    void loginUser(QString user, QString password);
    void loginFinished(bool success, QString motd, bool sync);
    void sendParserReportFinished(bool success);
    void listSubscriptions();
    void listForumsFinished(QList <ForumSubscription*>);
    void subscribeForum(int id, QString name);
    void subscribeForumWithCredentials(int id, QString name, QString username, QString password);
    void showSubscribeGroups();
    void setGroupSubscribed(QString id, bool sub);
    void applyGroupSubscriptions();
    void credentialsEntered(QString u, QString p, bool remember);
    void unsubscribeCurrentForum();
    void getForumDetails(int id);
    void getForumUrlDetails(QString url);
    void markThreadRead(bool read);
    virtual void showStatusMessage(QString message);
    void confirmMessages();
    void showMoreMessages();
    void updateCurrentMessageModel();
    void openInBrowser(QString messageId);
    void probeResults(ForumSubscription *probedSub);
    void newForumAdded(ForumSubscription *sub);
    void showNextError();
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
    QStringList messageQueue;
    QQmlContext* rootContext;
    QQuickItem *rootObject;
    ForumSubscription *currentSub;
    ForumGroup *currentGroup;
    ForumThread *currentThread;
    QString regOrLoginUser, regOrLoginPass;
    bool messageDisplayed;
    bool haltRequested;
    ForumSubscription *newForum; // the one being subscribed
    ForumProbe probe;
    QTimer showNextErrorTimer;
};

#endif // SIILIHAIMOBILE_H
