import QtQuick 2.0
import ".."
import "../widgets"

SimpleDialog {
    property bool useExitingAccount: false
    property bool registerAccount: false
    property bool busy: false
    id: loginWizard
    objectName: "loginWizard"
    opacity: 1
    Image {
        source: "../gfx/siilis3.png"
        opacity: 0.5
        visible: topItem
        NumberAnimation on x {
            running: true
            from: -parent.width
            to: loginWizard.width
            duration: 40000
            loops: Animation.Infinite
            onStopped: restart()
        }
    }

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
                text: "Welcome to Siilihai, the no-nonsense open source web forum reader. You need a Siilihai account to use synchronization between devices."
                font.pointSize: largePointSize
                wrapMode: Text.WordWrap
                color: "white"
                width: parent.width*0.9
            }
            Text {
                id: loginError
                color: "red"
                font.pointSize: largePointSize
                visible: text.length > 0
                width: parent.width
                wrapMode: Text.Wrap
            }
            LoginButton {
                id: loginButton
            }
            RegisterButton {
                id: registerButton
            }
            SimpleButton {
                text: "Use without account (sync disabled!)"
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
            topItem = false
        } else {
            loginError.text = "Registration failed - check username & password"
        }
    }

    function loginFinished(success, motd) {
        busy = false
        if(success) {
            topItem = false
        } else {
            loginError.text = "Login failed - check username & password"
        }
    }

    onTopItemChanged: Qt.inputMethod.hide();
}
