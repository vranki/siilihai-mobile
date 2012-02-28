import QtQuick 1.0
import com.nokia.meego 1.0

Page {
    anchors.fill: parent
    property string forumname: "?"
    Column {
        spacing: 15
        anchors.centerIn: parent
        Text {
            text: "Enter credentials for " + forumname
            wrapMode: Text.Wrap
            width: parent.width
        }
        Column {
            spacing: 4
            Text {
                text: "Username:"
            }
            TextField {
                placeholderText: "Username"
                id: forumUsername
            }
        }
        Column {
            spacing: 4
            Text {
                text: "Password:"
            }
            TextField {
                placeholderText: "Password"
                echoMode: TextInput.Password
                id: forumPassword
            }
        }
        CheckBox {
            id: rememberCreds
            text: "Remember"
        }

        Button {
            text: "Ok"
            onClicked: {
                appWindow.pageStack.pop(mainPage);
                appWindow.credentialsEntered(forumUsername.text, forumPassword.text, rememberCreds.checked)
            }
        }
    }
}
