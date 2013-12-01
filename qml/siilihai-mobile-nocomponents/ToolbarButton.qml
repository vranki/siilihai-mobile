import QtQuick 2.0

Rectangle {
    property string image: ""
    signal clicked

    color: "white"
    height: parent.height
    width: height
    radius: 5
    scale: 0.9
    Image {
        anchors.centerIn: parent
        source: parent.image
    }
    MouseArea {
        id: mousearea
        anchors.fill: parent
        onClicked: parent.clicked()
    }
}
