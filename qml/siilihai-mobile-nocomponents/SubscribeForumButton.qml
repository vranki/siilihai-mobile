import QtQuick 2.0

SimpleButton {
    property bool isSelectedForum: subscribeForumDialog.subscribeForumId === forumId
    text: modelData.alias
    anchors.horizontalCenter: parent.horizontalCenter
    height: 32 + (isSelectedForum ? 100 : 0)
    onClicked: {
        subscribeForumDialog.subscribeForumId = forumId
        siilihaimobile.getForumDetails(modelData.forumId)
    }
}
