import QtQuick 2.0
import "widgets"

ButtonWithUnreadCount {
    property bool isSelectedForum: forumListView.selectedforum = modelData
    text: modelData.alias
    rightText: modelData.unreadCount
    icon: modelData.faviconUrl //.length > 0 ? faviconUrl : undefined
    iconEmblems: (modelData.beingSynced ? "S" : "") + (modelData.beingUpdated ? "U" : "")
    onClicked: {
        if(isSelectedForum) {
            forumListView.selectedforum = undefined
        } else {
            console.log("Selecting", modelData, modelData.id)
            forumListView.selectedforum = modelData
            for(var i=0;i < forumListView.selectedforum.errors; i++) {
                console.log("Forum errors:", forumListView.selectedforum.errors.length)
            }
        }
    }
    height: defaultButtonHeight + (isSelectedForum ? groupListView.height + settingsButton.height : 0)
    Behavior on height { SmoothedAnimation { velocity: 800 } }
    clip: true
    busy: modelData.beingUpdated || modelData.beingSynced || modelData.scheduledForUpdate
    GroupListView {
        id: groupListView
        width: parent.width * 0.9
        anchors.horizontalCenter: parent.horizontalCenter
        height: count * (defaultButtonHeight + spacing)
        visible: isSelectedForum
        y: defaultButtonHeight
        model: modelData.subscribedGroups
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
