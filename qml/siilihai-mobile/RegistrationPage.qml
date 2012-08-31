import QtQuick 1.0
import com.nokia.meego 1.0

Page {
    tools: commonTools
    anchors.fill: parent
    property bool registering: false
    enabled: !registering
    Text {
        text: "Registration"
        width: parent.width
        color: "white"
    }
    Column {
        spacing: 15
        anchors.centerIn: parent

        Column {
            spacing: 4
            Text {
                text: "Username:"
                color: "white"
            }
            TextField {
                placeholderText: "Username"
                id: username
                text: loginUsername.text
            }
        }
        Column {
            spacing: 4
            Text {
                text: "E-mail address:"
                color: "white"
            }
            TextField {
                placeholderText: "E-mail address"
                id: email
            }
        }
        Column {
            spacing: 4
            Text {
                text: "Password:"
                color: "white"
            }
            TextField {
                placeholderText: "Password"
                echoMode: TextInput.Password
                id: password
                text: loginPassword.text
            }
            TextField {
                placeholderText: "Repeat"
                echoMode: TextInput.Password
                id: password2
            }
        }
        Column {
            spacing: 4
            CheckBox {
                id: sync
                text: "Synchronize with server"
                checked: true
            }
        }
        Button {
            text: "Continue"
            enabled: valuesValid() && !registering
            onClicked: {
                registering = true
                appWindow.registerUser(username.text, password.text, email.text, sync.checked)
            }
            function valuesValid() {
                if(username.text.length < 4) return false;
                if(password.text.length < 5 || password.text!=password2.text) return false;
                if(email.text.length<4 || email.text.indexOf("@")==-1 || email.text.indexOf(".")==-1) return false;
                return true;
            }
        }
        ProgressBar {
            indeterminate: true
            width: parent.width
            visible: registering
        }
    }

    Component.onCompleted: {
        appWindow.closeRegistration.connect(closeRegistration)
    }

    function closeRegistration(success, motd) {
        console.log("closeRegistration " + success + motd);
        registering = false
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
