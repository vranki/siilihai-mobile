import QtQuick 2.0
import "widgets"

ListView {
    spacing: 10
    snapMode: ListView.SnapToItem
    model: siilihaimobile.forumDatabase.subscriptions
    header: StatusIndicator {}
    delegate: ForumButton {}
    property var selectedForum
    footer: Column {
        width: parent.width
        Item { width:1; height: parent.width/8 }

        SimpleButton {
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width / 3
            height: width
            text: "+ Subscribe"
            buttonColor: "gray"
            bgColor: "white"
            onClicked: siilihai.subscribeForum()
            fontSize: height/8
        }
    }
}
