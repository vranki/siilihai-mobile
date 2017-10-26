import QtQuick 2.0
import org.vranki.siilihai 1.0
import "widgets"

ListView {
    spacing: 10
    // snapMode: ListView.SnapToItem
    model: siilihaimobile.forumDatabase.subscriptions
    header: StatusIndicator {}
    delegate: ForumButton {}
    property var selectedForum

    footer: Column {
        width: parent.width
        Item { width:1; height: parent.width/8 }
        spacing: 10
        SimpleButton {
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width / 3
            height: width
            text: "+ Subscribe"
            buttonColor: "gray"
            bgColor: "white"
            onClicked: siilihai.subscribeForum()
            fontSize: height/8
            visible: siilihai.state === SiilihaiMobile.SH_READY // Ready
        }
        SimpleButton {
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width / 6
            height: width
            buttonColor: "gray"
            bgColor: "white"
            Image {
                source: "gfx/Gnome-preferences-system.svg"
                anchors.centerIn: parent
            }
            onClicked: settingsLoader.active = true
            visible: !subscribeForumDialog.active
                     && !threadListView.selectedGroup
                     && !settingsLoader.active
                     && !forumSettingsDialog.active
        }
    }
}
