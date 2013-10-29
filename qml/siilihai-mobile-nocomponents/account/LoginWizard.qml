import QtQuick 2.0
import ".."

Flickable {
    property bool busy: false
    id: loginWizard
    objectName: "loginWizard"
    visible: false

    Rectangle {
        anchors.fill: parent
        color: "black"
    }
    Column {
        width: parent.width
        spacing: 20
        Text {
            text: "Welcome to Siilihai. You need a Siilihai account to use synchronization between devices."
            font.pointSize: 16
            wrapMode: Text.WordWrap
            color: "white"
            width: parent.width
        }
        SimpleButton {
            text: "Use existing account"
            anchors.horizontalCenter: parent.horizontalCenter
        }
        SimpleButton {
            text: "Register a new account"
            anchors.horizontalCenter: parent.horizontalCenter
        }
        SimpleButton {
            text: "Use without account (sync disabled)"
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                busy = true
                siilihaimobile.registerUser("", "", "", false)
            }
        }
    }

    function registrationFinished(success, motd) {
        busy = false
        if(success) {
            visible = false
        }
    }
}
