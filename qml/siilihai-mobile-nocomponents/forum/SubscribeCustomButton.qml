import QtQuick 2.0
import ".."
import "../widgets"

SimpleButton {
    text: enterUrl ? "" : "Enter URL.."
    anchors.horizontalCenter: parent.horizontalCenter
    objectName: "subscribeCustomButton"
    property bool probing: false
    property bool probeOk: false
    onClicked: { enterUrl = true }
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
            text: "Forum URL"
            color: "white"
            width: parent.width
            visible: enterUrl
        }
        SimpleTextEdit {
            id: url
            width: parent.width
            visible: enterUrl
            text: "http://"
            font.pixelSize: smallPixelSize
            inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhUrlCharactersOnly
            clearButton: true
        }
        Text {
            id: error
            color: "red"
            width: parent.width
            visible: enterUrl && text.length > 0
            font.bold: true
        }
        SimpleButton {
            text: "Check for support"
            width: parent.width * 0.9
            anchors.horizontalCenter: parent.horizontalCenter
            visible: enterUrl
            opacity: probing ? 0.5 : 1
            onClicked: {
                if(probing) return
                probeOk = false
                probing = true
                siilihaimobile.getForumUrlDetails(url.text)
            }
        }
        Text {
            id: login
            visible: enterUrl && probeOk && newForum && newForum.supportsLogin
            text: "Username"
            color: "white"
            font.pixelSize: largePixelSize
        }
        SimpleTextEdit {
            id: username
            focus: true
            visible: login.visible
            inputMethodHints: Qt.ImhNoAutoUppercase
        }
        Text {
            visible: login.visible
            text: "Password"
            color: "white"
            font.pixelSize: largePixelSize
        }
        SimpleTextEdit {
            id: password
            visible: login.visible
            inputMethodHints: Qt.ImhHiddenText | Qt.ImhNoAutoUppercase
        }
        SimpleButton {
            visible: login.visible
            text: "Subscribe"
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                siilihaimobile.subscribeForumWithCredentials(newForum.id, newForum.alias, username.text, password.text)
                subscribeForumDialog.topItem = false
                probeOk = false
                enterUrl = false
            }
        }
    }
    function probeFinished(success, msg) {
        probing = false
        if(success) {
            probeOk = true
        } else {
            error.text = msg
        }
    }
}
