import QtQuick 2.0

Rectangle {
    property string text: ""
    property bool enabled: true
    signal clicked
    radius: 10
    color: "transparent"
    border.color: "white"
    border.width: 2
    width: parent.width * 0.8
    height: 32
    opacity: enabled ? 1 : 0.5
    Text {
        anchors.centerIn: parent
        color: "white"
        text: parent.text
    }
    MouseArea {
        anchors.fill: parent
        onClicked: if(enabled) parent.clicked()
    }
}
