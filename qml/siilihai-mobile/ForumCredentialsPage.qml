// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    anchors.fill: parent
    property string forumname: ""
    property int forumid: -1
    property bool supportsLogin: false
    property bool parserDownloaded: false
    Column {
        spacing: 15
        anchors.centerIn: parent
        ProgressBar {
            indeterminate: true
            width: parent.width
            visible: !parserDownloaded
        }
        CheckBox {
            id: haveCredentials
            text: "I have user account on this forum"
            enabled: supportsLogin
            visible: supportsLogin
        }
        Label {
            text: "This forum does not support authentication"
            wrapMode: Text.Wrap
            visible: !supportsLogin
        }
        Column {
            spacing: 4
            Label {
                text: "Username:"
            }
            TextField {
                placeholderText: "Username"
                id: forumUsername
                enabled: haveCredentials.checked
            }
        }
        Column {
            spacing: 4
            Label {
                text: "Password:"
            }
            TextField {
                placeholderText: "Password"
                echoMode: TextInput.Password
                id: forumPassword
                enabled: haveCredentials.checked
            }
        }
        Button {
            text: "Continue"
            onClicked: {
                if(haveCredentials.checked) {
                    appWindow.subscribeForumWithCredentials(forumid, forumname, forumUsername.text, forumPassword.text)
                } else {
                    appWindow.subscribeForum(forumid, forumname)
                }

                appWindow.pageStack.pop(mainPage)
            }
        }
    }
}
