import QtQuick 1.0
import com.nokia.meego 1.0

Page {
    property bool loggingIn: false
    enabled: !loggingIn

    RegistrationPage {
        id: registrationPage
    }
    anchors.fill: parent
    Column {
        spacing: 15
        anchors.centerIn: parent
        Text {
            text: "Welcome to Siilihai"
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
                id: loginUsername
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
                id: loginPassword
            }
        }
        Button {
            text: "Login"
            onClicked: {
                loggingIn = true
                appWindow.loginUser(loginUsername.text, loginPassword.text)
            }
        }
        Button {
            anchors.topMargin: 15
            text: "Register"

            onClicked: {
                appWindow.pageStack.push(registrationPage)
            }
        }
        ProgressBar {
            indeterminate: true
            width: parent.width
            visible: loggingIn
        }
    }
    Component.onCompleted: {
        appWindow.closeLogin.connect(closeLogin)
    }

    function closeLogin(success, motd) {
        console.log("closeLogin " + success + motd);
        loggingIn = false
        if(success) {
            appWindow.pageStack.pop(mainPage);
        } else {
            if(motd.length > 0) {
                appWindow.showMessage(motd);
            } else {
                appWindow.showMessage("Registration failed. Check your Internet connection etc.");
            }
        }
    }
}
