import QtQuick 2.0

Rectangle {
    property string text: "?"
    signal clicked

    color: "white"
    height: parent.height
    width: height
    radius: 5
    scale: 0.9
    Text {
        anchors.centerIn: parent
        text: parent.text
        font.pixelSize: parent.height
    }
    MouseArea {
        id: mousearea
        anchors.fill: parent
        onClicked: parent.clicked()
    }
}
