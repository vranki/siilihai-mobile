import QtQuick 1.1
import com.nokia.meego 1.0

PageStackWindow {
    id: appWindow
    initialPage: mainPage
    //initialPage: testMsgDisplay

    signal subscriptionSelected(int parser)
    signal groupSelected(string id)
    signal threadSelected(string id)
    signal haltSiilihai()
    signal registerUser(string username, string password, string email, bool sync)
    signal closeRegistration(bool success, string motd)
    signal loginUser(string username, string password)
    signal closeLogin(bool success, string motd)
    signal listSubscriptions()
    signal getParserDetails(int id)
    signal subscribeForum(int id, string name)
    signal subscribeForumWithCredentials(int id, string name, string user, string pass)
    signal unSubscribeCurrentForum()
    signal subscribeGroups()
    signal setGroupSubscribed(string id, bool sub)
    signal applyGroupSubscriptions();
    signal credentialsEntered(string u, string p, bool remember)
/*
    MessageDisplay {
        id: testMsgDisplay
        msgSubject: "subject"
        msgBody: "body"
        msgAuthor: "author"
        visible: false
    }
*/
    MainPage {
        id: mainPage
    }
    GroupListPage {
        id: groupListPage
    }
    ThreadListPage {
        id: threadListPage
    }
    MessageListPage {
        id: messageListPage
    }
    MessagePage {
        id: messagePage
    }
    LoginWizardPage {
        id: loginWizardPage
    }
    SubscribeWizardPage {
        id: subscribeWizardPage
    }
    ForumCredentialsPage {
        id: forumCredentialsPage
    }
    SubscribeGroupsPage {
        id: subscribeGroupsPage
    }
    CredentialsDialogPage {
        id: credentialsDialogPage
    }
    ToolBarLayout {
        id: commonTools
        visible: true
        ToolIcon {
            id: backButton
            platformIconId: "toolbar-back"
            onClicked: pageStack.pop()
            visible: appWindow.pageStack.currentPage != mainPage
        }
        ToolIcon {
            platformIconId: "toolbar-view-menu"
            anchors.right: (parent === undefined) ? undefined : parent.right
            onClicked: (myMenu.status == DialogStatus.Closed) ? myMenu.open() : myMenu.close()
        }
    }

    Menu {
        id: myMenu
        visualParent: pageStack
        MenuLayout {
            MenuItem {
                text: qsTr("Quit")
                onClicked: {
                    console.log("halting ")
                    appWindow.haltSiilihai()
                }
            }
            MenuItem {
                visible: groupListPage.status == PageStatus.Active
                text: "Unsubscribe Forum"
                onClicked: {
                    pageStack.pop()
                    appWindow.unSubscribeCurrentForum()
                }
            }
            MenuItem {
                visible: mainPage.status == PageStatus.Active
                text: "Subscribe to .."
                onClicked: {
                    appWindow.showSubscribeWizard()
                }
            }
        }
    }
    onSubscriptionSelected: {
        console.log("onSubscriptionSelected " + parser)
    }

    function showMessage(msg) {
        console.log("showMessage " + msg)
        messagePage.text = msg
        appWindow.pageStack.push(messagePage)
    }
    function showLoginWizard() {
        console.log("showLoginWizard")
        appWindow.pageStack.push(loginWizardPage)
    }

    function registrationFinished(success, motd) {
        console.log("registrationFinished")
        appWindow.closeRegistration(success, motd)
    }
    function loginFinished(success, motd) {
        console.log("loginFinished")
        appWindow.closeLogin(success, motd)
    }
    function showSubscribeWizard() {
        console.log("showSubscribeWizard ")
        appWindow.pageStack.push(subscribeWizardPage)
        appWindow.listSubscriptions()
    }
    function showSubscribeGroups() {
        console.log("showSubscribeGroups")
        appWindow.pageStack.push(subscribeGroupsPage)
    }
    function askCredentials(sub, type) {
        console.log("askCredentials " + sub + " " + type)
        credentialsDialogPage.forumname = sub
        credentialsDialogPage.credentialtype = type
        credentialsDialogPage.resetForm()
        pageStack.push(credentialsDialogPage)
    }
    function parserDetails(id, supportsLogin) {
        console.log("parserDetails " + id + " " + supportsLogin)
        forumCredentialsPage.supportsLogin = supportsLogin
        forumCredentialsPage.parserDownloaded = true
    }
}
