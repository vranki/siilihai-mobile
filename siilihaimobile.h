#ifndef SIILIHAIMOBILE_H
#define SIILIHAIMOBILE_H

#include <siilihai/clientlogic.h>
#include <qdeclarativecontext.h>
#include <siilihai/forumsubscription.h>
#include <siilihai/forumgroup.h>
#include <siilihai/forumthread.h>
#include <siilihai/forummessage.h>

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
protected:
    virtual QString getDataFilePath();
    virtual void showLoginWizard();
    virtual void errorDialog(QString message);
    virtual void closeUi();
    virtual void showMainWindow();
    virtual void showCredentialsDialog(ForumSubscription *fsub, QAuthenticator * authenticator);
private:
    void displayNextMessage();
    QList<QObject*> subscriptionList, groupList, threadList, messageList;
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
