import QtQuick 2.0

Rectangle {
    width: parent.width
    height: 42
    color: "transparent"
    radius: 10
    border.color: "black"
    Text {
        anchors.verticalCenter: parent.verticalCenter
        x: parent.width / 30
        text: name
        color: "black"
        font.pointSize: 30
    }
    Text {
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        text: unreadcount
        color: "black"
        font.pointSize: 25
    }
}
