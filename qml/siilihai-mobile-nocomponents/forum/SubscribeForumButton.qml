import QtQuick 2.0
import ".."
import "../widgets"

SimpleButton {
    property bool isSelectedForum: subscribeForumDialog.subscribeForumId === forumId && !enterUrl
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
    height: 42 + (isSelectedForum ? forumDetails.height + 20 : 0)
    Behavior on height { SmoothedAnimation { velocity: 800 } }
    onClicked: {
        if(isSelectedForum) return
        enterUrl = false
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
            text: newForum ? (newForum.supportsLogin ? "" : "Login not supported") : "Getting details .."
            color: "white"
            font.pointSize: 12
            wrapMode: Text.WordWrap
        }
        UserPassForm {
            id: upf
            visible: newForum && newForum.supportsLogin
            questionText: "Authenticate to forum"
            checked: false
        }
        SimpleButton {
            visible: newForum
            text: "Subscribe"
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                siilihaimobile.subscribeForumWithCredentials(newForum.forumId, newForum.alias, upf.username, upf.password)
                subscribeForumDialog.topItem = false
                subscribeForumDialog.subscribeForumId = 0
            }
        }
    }
}
