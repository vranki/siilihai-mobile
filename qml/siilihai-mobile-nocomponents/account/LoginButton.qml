import QtQuick 2.0
import ".."
import "../widgets"

SimpleButton {
    objectName: "loginButton"
    text: useExitingAccount ? "" : "Use existing account"
    anchors.horizontalCenter: parent.horizontalCenter
    onClicked: { useExitingAccount = true; registerAccount = false }
    height: 30 + contentC.height
    clip: true
    Behavior on height { SmoothedAnimation { velocity: 800 } }
    Column {
        id: contentC
        width: parent.width*0.9
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 10
        Item { width: 1; height: 1}
        Text {
            text: "Username"
            color: "white"
            width: parent.width
            visible: useExitingAccount
        }
        SimpleTextEdit {
            id: username
            width: parent.width
            visible: useExitingAccount
            inputMethodHints: Qt.ImhNoAutoUppercase
        }
        Text {
            text: "Password"
            color: "white"
            width: parent.width
            visible: useExitingAccount
        }
        SimpleTextEdit {
            id: password
            width: parent.width
            visible: useExitingAccount
            inputMethodHints: Qt.ImhHiddenText | Qt.ImhNoAutoUppercase
        }
        SimpleButton {
            text: "Login"
            width: parent.width / 3
            anchors.horizontalCenter: parent.horizontalCenter
            visible: useExitingAccount
            opacity: loginWizard.busy ? 0.5 : 1
            onClicked: {
                if(loginWizard.busy) return
                loginWizard.busy = true
                siilihaimobile.loginUser(username.text, password.text)
            }
        }
    }
}
