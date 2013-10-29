import QtQuick 2.0

ListView {
    spacing: 10
    snapMode: ListView.SnapToItem
    model: subscriptions
    header: StatusIndicator {}
    delegate: ForumButton {}
    footer: SimpleButton {
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width / 3
        text: "+"
        buttonColor: "black"
        onClicked: siilihaimobile.subscribeForum()
    }
}
