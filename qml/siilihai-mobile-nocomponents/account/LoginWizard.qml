import QtQuick 2.0
import ".."

Rectangle {
    anchors.fill: parent
    property bool useExitingAccount: false
    property bool registerAccount: false
    property bool busy: false
    id: loginWizard
    objectName: "loginWizard"
    visible: false
    color: "black"

    Flickable {
        anchors.fill: parent
        contentWidth: width
        contentHeight: childrenRect.height
        Column {
            y: 50
            width: parent.width*0.9

            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 30
            Text {
                text: "Welcome to Siilihai. You need a Siilihai account to use synchronization between devices."
                font.pointSize: 16
                wrapMode: Text.WordWrap
                color: "white"
                width: parent.width
            }
            LoginButton {
                id: loginButton
            }
            RegisterButton {
                id: registerButton
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
    }

    function registrationFinished(success, motd) {
        busy = false
        if(success) {
            visible = false
        }
    }
    function loginFinished(success, motd) {
        busy = false
        if(success) {
            visible = false
        }
    }
}
