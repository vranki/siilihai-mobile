import QtQuick 2.0
import ".."
import "../widgets"

SimpleButton {
    property bool valuesValid: username.length > 0 && password.length > 3 && email.length > 3
    objectName: "registerButton"
    text: registerAccount ? "" : "Register a new account"
    anchors.horizontalCenter: parent.horizontalCenter
    onClicked:  { useExitingAccount = false; registerAccount = true }
    height: defaultButtonHeight + contentC.height
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
            visible: registerAccount
        }
        SimpleTextEdit {
            id: username
            width: parent.width
            visible: registerAccount
            inputMethodHints: Qt.ImhNoAutoUppercase
        }
        Text {
            text: "Password"
            color: "white"
            width: parent.width
            visible: registerAccount
        }
        SimpleTextEdit {
            id: password
            width: parent.width
            visible: registerAccount
            inputMethodHints: Qt.ImhHiddenText | Qt.ImhNoAutoUppercase
        }
        Text {
            text: "E-mail address"
            color: "white"
            width: parent.width
            visible: registerAccount
        }
        SimpleTextEdit {
            id: email
            width: parent.width
            visible: registerAccount
            inputMethodHints: Qt.ImhNoAutoUppercase
        }
        SimpleCheckBox {
            id: sync
            text: "Sync between devices"
            checked: true
            visible: registerAccount
            width: parent.width
        }
        SimpleButton {
            text: "Register"
            width: parent.width / 3
            anchors.horizontalCenter: parent.horizontalCenter
            visible: registerAccount
            opacity: !loginWizard.busy && valuesValid ? 1 : 0.5
            onClicked: {
                if(loginWizard.busy || !valuesValid) return
                loginWizard.busy = true
                siilihaimobile.registerUser(username.text, password.text, email.text, sync.checked)
            }
        }
    }
}
