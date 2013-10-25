import QtQuick 2.0

Rectangle {
    property string text: ""
    signal clicked
    radius: 10
    color: "transparent"
    border.color: "white"
    border.width: 2
    Text {
        anchors.centerIn: parent
        color: "white"
        text: parent.text
    }
    MouseArea {
        anchors.fill: parent
        onClicked: parent.clicked()
    }
}
