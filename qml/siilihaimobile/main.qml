import QtQuick 1.1
import com.nokia.meego 1.0

PageStackWindow {
    id: appWindow
    initialPage: mainPage

    signal subscriptionSelected(int parser)
    signal groupSelected(string id)
    signal threadSelected(string id)
    signal haltSiilihai()
    signal registerUser(string username, string password, string email, bool sync)
    signal closeRegistration(bool success, string motd)
    signal loginUser(string username, string password)
    signal closeLogin(bool success, string motd)

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
}
