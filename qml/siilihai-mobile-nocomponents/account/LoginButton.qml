import QtQuick 2.0
import ".."
import "../widgets"

SimpleButton {
    objectName: "loginButton"
    text: useExitingAccount ? "" : "Use existing account"
    anchors.horizontalCenter: parent.horizontalCenter
    height: defaultButtonHeight + contentC.height
    clip: true
    Behavior on height { SmoothedAnimation { velocity: 800 } }

    Component.onCompleted: {
        if(siilihaimobile.settings.username) {
            // Account already exists
            useExitingAccount = true
            registerAccount = false
            upf.username = siilihaimobile.settings.username
            upf.password = siilihaimobile.settings.password
        }
    }

    onClicked: {
        useExitingAccount = true
        registerAccount = false
    }
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
