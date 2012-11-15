import QtQuick 1.1
import com.nokia.meego 1.0

PageStackWindow {
    id: appWindow
    initialPage: mainPage
    //initialPage: testMsgDisplay

    // QML -> C++
    signal subscriptionSelected(int parser)
    signal groupSelected(string id)
    signal threadSelected(string id)
    signal haltSiilihai()
    signal registerUser(string username, string password, string email, bool sync)
    signal closeRegistration(bool success, string motd)
    signal loginUser(string username, string password)
    signal closeLogin(bool success, string motd)
    signal listSubscriptions()
    signal getForumDetails(int id)
    signal getForumUrlDetails(string url)
    signal subscribeForum(int id, string name)
    signal subscribeForumWithCredentials(int id, string name, string user, string pass)
    signal unSubscribeCurrentForum()
    signal subscribeGroups()
    signal setGroupSubscribed(string id, bool sub)
    signal applyGroupSubscriptions();
    signal credentialsEntered(string u, string p, bool remember)
    signal markThreadRead(bool read);
    signal showMoreMessages();
    signal updateClicked();
    signal openInBrowser(string id);
    signal displayNextMessage();

    Component.onCompleted: {
        console.log("Loaded")
    }
    Component.onDestruction: {
        console.log("QML exit")
        haltSiilihai()
    }
/*
    MessageDisplay {
        id: testMsgDisplay
        msgSubject: "subject"
        msgBody: "body"
        msgAuthor: "author"
        visible: false
    }
    Rectangle {
        color: "black"
        anchors.fill: parent
        z: -100
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
    HaltScreen {
        id: haltScreen
    }

    ToolBarLayout {
        id: commonTools
        Row {
        ToolIcon {
            id: backButton
            platformIconId: "toolbar-back"
            onClicked: {
                if(pageStack.currentPage==messagePage) {
                    pageStack.pop()
                    displayNextMessage();
                } else {
                    pageStack.pop()
                }
            }
            visible: appWindow.pageStack.currentPage != mainPage
        }
        ToolIcon {
            platformIconId: "toolbar-refresh"
            enabled: !mainPage.busy
            onClicked: appWindow.updateClicked()
            visible: !backButton.visible
//            anchors.left: backButton.right
        }
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

    Timer {
        id: statusmessagetimer
        interval: 5000; running: false; repeat: false
        onTriggered: mainPage.message = " "
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
        console.log("showSubscribeWizard cp=" + pageStack.currentPage + " busy=" + pageStack.busy)
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
    function forumDetails(id, name, supportsLogin) {
        console.log("forumDetails " + id + " " + name + " "+ supportsLogin)
        forumCredentialsPage.forumid = id
        forumCredentialsPage.forumname = name
        forumCredentialsPage.supportsLogin = supportsLogin
        forumCredentialsPage.forumDownloaded = true
    }
    function subscribeFailed() {
        subscribeWizardPage.selectionMode = 0;
        forumCredentialsPage.forumid = 0
        appWindow.pageStack.pop(mainPage);
    }
    function setBusy(busy) {
        console.log("setBusy " + busy)
        mainPage.busy = busy
    }
    function showStatusMessage(message) {
        console.log("showStatusMessage " + message)
        mainPage.message = message
        statusmessagetimer.restart()
    }
    function showHaltScreen() {
        console.log("showHaltScreen")
        pageStack.clear()
        pageStack.push(haltScreen, null, true)
    }
}
