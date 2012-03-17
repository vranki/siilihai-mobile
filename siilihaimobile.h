#ifndef SIILIHAIMOBILE_H
#define SIILIHAIMOBILE_H

#include <siilihai/clientlogic.h>
#include <qdeclarativecontext.h>

class SiilihaiMobile : public ClientLogic
{
    Q_OBJECT
public:
    explicit SiilihaiMobile(QObject *parent, QDeclarativeContext* ctx, QObject *rootObj);

signals:

public slots:
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
    void listParsersFinished(QList <ForumParser*>);
    void subscribeForum(int id, QString name);
    void subscribeForumWithCredentials(int id, QString name, QString username, QString password);
    void getParserFinished(ForumParser *fp);
    void showSubscribeGroups();
    void setGroupSubscribed(QString id, bool sub);
    void applyGroupSubscriptions();
    void credentialsEntered(QString u, QString p, bool remember);
    void unsubscribeCurrentForum();
    void getParserDetails(int id);
    void markThreadRead();
    virtual void showStatusMessage(QString message);
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
    void displayNextMessage();
    QList<QObject*> subscriptionList, groupList, threadList, messageList, parserList, subscribeGroupList;
    QDeclarativeContext* rootContext;
    QObject *rootObject;
    ForumSubscription *currentSub;
    ForumGroup *currentGroup;
    ForumThread *currentThread;
    QString regOrLoginUser, regOrLoginPass;
    QStringList messageQueue;
    bool messageDisplayed;
};

#endif // SIILIHAIMOBILE_H
