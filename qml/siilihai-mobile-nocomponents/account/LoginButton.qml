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
        UserPassForm {
            id: upf
            visible: useExitingAccount
            optional: false
        }
        SimpleButton {
            text: "Login"
            enabled: !loginWizard.busy && upf.hasValues
            width: parent.width / 3
            anchors.horizontalCenter: parent.horizontalCenter
            visible: useExitingAccount
            onClicked: {
                loginWizard.busy = true
                siilihaimobile.loginUser(upf.username, upf.password)
            }
        }
    }
}
