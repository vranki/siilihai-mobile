import QtQuick 2.0
import ".."

SimpleButton {
    property bool isSelectedForum: subscribeForumDialog.subscribeForumId === forumId
    Text {
        id: forumLabel
        text: modelData.alias
        color: "white"
        anchors.left: parent.left
        anchors.leftMargin: 5
        anchors.top: parent.top
        anchors.topMargin: 5
        font.pointSize: 15
    }
    anchors.horizontalCenter: parent.horizontalCenter
    height: 32 + (isSelectedForum ? forumDetails.height + 20 : 0)
    Behavior on height { SmoothedAnimation { velocity: 800 } }
    onClicked: {
        subscribeForumDialog.subscribeForumId = forumId
        siilihaimobile.getForumDetails(modelData.forumId)
    }

    Column {
        id: forumDetails
        width: parent.width * 0.9
        anchors.horizontalCenter: parent.horizontalCenter
        visible: isSelectedForum
        anchors.top: forumLabel.bottom
        anchors.topMargin: 10
        spacing: 10
        Text {
            text: newForum ? newForum.forumUrl : ""
            color: color1
            font.pointSize: 10
            anchors.horizontalCenter: parent.horizontalCenter
            MouseArea {
                anchors.fill: parent
                onClicked: Qt.openUrlExternally(newForum.forumUrl)
            }
        }
        Text {
            text: newForum ? (newForum.supportsLogin ? "Enter forum credentials below, if you have an account" :
                                                       "Login not supported") : "Getting details .."
            color: "white"
            font.pointSize: 12
            wrapMode: Text.WordWrap
        }
        Text {
            id: login
            visible: newForum && newForum.supportsLogin
            text: "Username"
            color: "white"
            font.pointSize: 15
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
            font.pointSize: 15
        }
        SimpleTextEdit {
            id: password
            visible: login.visible
            inputMethodHints: Qt.ImhHiddenText | Qt.ImhNoAutoUppercase
        }
        SimpleButton {
            visible: newForum
            text: "Subscribe"
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                siilihaimobile.subscribeForumWithCredentials(newForum.forumId, newForum.alias, username.text, password.text)
                subscribeForumDialog.topItem = false
            }
        }
    }
}
