import QtQuick 1.0
import com.nokia.meego 1.0

Page {
    anchors.fill: parent
    property string forumname: "?"
    property string credentialtype: "?"
    Column {
        spacing: 15
        anchors.centerIn: parent
        Text {
            text: "Enter " + credentialtype + " credentials for " + forumname
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
            checked: true
        }

        Button {
            text: "Ok"
            onClicked: {
                appWindow.pageStack.pop(mainPage, true);
                appWindow.credentialsEntered(forumUsername.text, forumPassword.text, rememberCreds.checked)
            }
        }
    }
    function resetForm() {
        console.log("resetform")
        forumUsername.text = ""
        forumPassword.text = ""
        rememberCreds.checked = true
    }
}
