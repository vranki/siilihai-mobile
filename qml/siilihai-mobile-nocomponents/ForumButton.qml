import QtQuick 2.0
import "widgets"

ButtonWithUnreadCount {
    property bool isSelectedForum: forumListView.selectedForum = modelData
    text: modelData.alias
    rightText: modelData.unreadCount
    icon: modelData.faviconUrl
    iconEmblems: (modelData.beingSynced ? "S" : "") + (modelData.beingUpdated ? "U" : "") + (modelData.errors.length ? "!" : "")
    onClicked: {
        if(isSelectedForum) {
            forumListView.selectedForum = undefined
        } else {
            forumListView.selectedForum = modelData
            for(var i=0;i < forumListView.selectedForum.errors; i++) {
                console.log("Forum errors:", forumListView.selectedForum.errors.length)
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
        onClicked: if(shown) {
                       forumListView.selectedForum = modelData
                       forumSettingsDialog.active = true
                   }
        Image {
            source: "gfx/Folder-move2.svg"
            anchors.fill: parent
            z: -10
            fillMode: Image.PreserveAspectFit
        }
        Connections {
            target: siilihaimobile
            onGroupListChanged: {
                if(sub === modelData) {
                    forumListView.selectedForum = modelData
                    settingsButton.clicked()
                }
            }
        }
    }
}
