import QtQuick 2.0

UiButton {
    property bool isSelectedForum: siilihaimobile.selectedForumId === forumId
    text: alias
    rightText: unreadCount
    onClicked: isSelectedForum ? siilihaimobile.selectForum(0) : siilihaimobile.selectedForumId = forumId
    height: uiButtonHeight + (isSelectedForum ? groupListView.height : 0)
    Behavior on height { SmoothedAnimation { velocity: 800 } }
    clip: true
    GroupListView {
        id: groupListView
        width: parent.width * 0.9
        anchors.horizontalCenter: parent.horizontalCenter
        height: count * (uiButtonHeight + spacing)
        visible: isSelectedForum
        y: uiButtonHeight
    }
}
