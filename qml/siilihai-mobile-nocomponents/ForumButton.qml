import QtQuick 2.0
import "widgets"

ButtonWithUnreadCount {
    property bool isSelectedForum: siilihaimobile.selectedForumId === forumId
    text: alias
    rightText: unreadCount
    icon: faviconUrl.length > 0 ? faviconUrl : undefined
    iconEmblems: (beingSynced ? "S" : "") + (beingUpdated ? "U" : "")
    onClicked: isSelectedForum ? siilihaimobile.selectForum(0) : siilihaimobile.selectedForumId = forumId
    height: defaultButtonHeight + (isSelectedForum ? groupListView.height + settingsButton.height : 0)
    Behavior on height { SmoothedAnimation { velocity: 800 } }
    clip: true
    busy: beingUpdated || beingSynced || scheduledForUpdate
    GroupListView {
        id: groupListView
        width: parent.width * 0.9
        anchors.horizontalCenter: parent.horizontalCenter
        height: count * (defaultButtonHeight + spacing)
        visible: isSelectedForum
        y: defaultButtonHeight
    }
    SimpleButton {
        id: settingsButton
        property bool shown: isSelectedForum && !busy
        anchors.top: parent.top
        x: parent.width * 0.65
        anchors.topMargin: 5
        opacity: shown ? 1 : 0
        visible: opacity > 0
        Behavior on opacity { SmoothedAnimation { velocity: 1 } }
        width: height*2
        height: defaultButtonHeight*0.8
        buttonColor: "black"
        onClicked: if(shown) siilihaimobile.showSubscribeGroups()
        Image {
            source: "gfx/Folder-move2.svg"
            anchors.fill: parent
            z: -10
            fillMode: Image.PreserveAspectFit
        }
    }
}
