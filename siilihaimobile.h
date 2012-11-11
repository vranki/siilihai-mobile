#ifndef SIILIHAIMOBILE_H
#define SIILIHAIMOBILE_H

#include <siilihai/clientlogic.h>
#include <qdeclarativecontext.h>
#include <QStringList>

class SiilihaiMobile : public ClientLogic
{
    Q_OBJECT
public:
    explicit SiilihaiMobile(QObject *parent, QDeclarativeContext* ctx, QObject *rootObj);
    bool isHaltRequested();
signals:

public slots:
    virtual void haltSiilihai();
private slots:
    virtual void subscribeForum();
    virtual void subscriptionFound(ForumSubscription *sub);
    virtual void subscriptionDeleted(QObject* subobj);
    void subscriptionSelected(int parser);
    void groupSelected(QString id);
    void threadSelected(QString id);
    void registerUser(QString user, QString password, QString email, bool sync);
    void registerFinished(bool success, QString motd, bool sync);
    void loginUser(QString user, QString password);
    void loginFinished(bool success, QString motd, bool sync);
    void sendParserReportFinished(bool success);
    void listSubscriptions();
    void listForumsFinished(QList <ForumSubscription*>);
    void subscribeForum(int id, QString name);
    void subscribeForumWithCredentials(int id, QString name, QString username, QString password);
    void getParserFinished(ForumParser *fp);
    void showSubscribeGroups();
    void setGroupSubscribed(QString id, bool sub);
    void applyGroupSubscriptions();
    void credentialsEntered(QString u, QString p, bool remember);
    void unsubscribeCurrentForum();
    void getParserDetails(int id);
    void markThreadRead(bool read);
    virtual void showStatusMessage(QString message);
    void showMoreMessages();
    void updateCurrentMessageModel();
    void openInBrowser(QString messageId);
    void displayNextMessage(bool requestedByUI=true);
protected:
    virtual QString getDataFilePath();
    virtual void changeState(siilihai_states newState);
    virtual void showLoginWizard();
    virtual void errorDialog(QString message);
    virtual void closeUi();
    virtual void showMainWindow();
    virtual void showSubscribeGroup(ForumSubscription* forum);
    virtual void showCredentialsDialog(CredentialsRequest *cr);

private:
    QList<QObject*> subscriptionList, groupList, threadList, messageList, forumList, subscribeGroupList;
    QDeclarativeContext* rootContext;
    QObject *rootObject;
    ForumSubscription *currentSub;
    ForumGroup *currentGroup;
    ForumThread *currentThread;
    QString regOrLoginUser, regOrLoginPass;
    QStringList messageQueue;
    bool messageDisplayed;
    bool haltRequested;
};

#endif // SIILIHAIMOBILE_H
