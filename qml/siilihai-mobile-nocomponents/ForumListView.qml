import QtQuick 2.0
import "widgets"

ListView {
    spacing: 10
    snapMode: ListView.SnapToItem
    model: subscriptions
    header: StatusIndicator {}
    delegate: ForumButton {}
    footer: Item {
        width: parent.width * 0.5
        height: width
        anchors.horizontalCenter: parent.horizontalCenter
        SimpleButton {
            anchors.centerIn: parent
            width: parent.width / 2
            height: width
            text: "+ Subscribe"
            buttonColor: "gray"
            bgColor: "white"
            onClicked: siilihaimobile.subscribeForum()
        }
    }
}
