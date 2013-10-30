import QtQuick 2.0
import "widgets"

ButtonWithUnreadCount {
    property bool isSelectedForum: siilihaimobile.selectedForumId === forumId
    text: alias
    rightText: unreadCount
    icon: faviconUrl.length > 0 ? faviconUrl : undefined
    iconEmblems: (beingSynced ? "⇄" : "") + (beingUpdated ? "⟲" : "")
    onClicked: isSelectedForum ? siilihaimobile.selectForum(0) : siilihaimobile.selectedForumId = forumId
    height: uiButtonHeight + (isSelectedForum ? groupListView.height + settingsButton.height : 0)
    Behavior on height { SmoothedAnimation { velocity: 800 } }
    clip: true
    busy: beingUpdated || beingSynced || scheduledForUpdate
    GroupListView {
        id: groupListView
        width: parent.width * 0.9
        anchors.horizontalCenter: parent.horizontalCenter
        height: count * (uiButtonHeight + spacing)
        visible: isSelectedForum
        y: uiButtonHeight
    }
    SimpleButton {
        id: settingsButton
        anchors.top: groupListView.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        width: height*2
        //text: "☰"
        buttonColor: "black"
        onClicked: { forumSettingsDialog.topItem = true; siilihaimobile.showSubscribeGroups() }
        Image {
            source: "gfx/Folder-move2.svg"
            anchors.fill: parent
            z: -10
            fillMode: Image.PreserveAspectFit
        }
    }
}
