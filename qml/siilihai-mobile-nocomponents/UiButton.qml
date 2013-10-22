import QtQuick 2.0

Rectangle {
    property string text: ""
    property string rightText: ""
    property string smallText: ""
    property int uiButtonHeight: 42
    signal clicked

    width: parent.width
    height: uiButtonHeight
    color: "#f7f7f7"
    radius: 5
    border.color: "black"
    Item {
        width: parent.width
        height: uiButtonHeight
        Text {
            text: parent.parent.smallText
            font.pixelSize: uiButtonHeight * 0.25
            color: "gray"
            anchors.bottom: parent.bottom
            anchors.left: mainLabel.left
        }
        Text {
            id: mainLabel
            anchors.verticalCenter: parent.verticalCenter
            x: parent.width / 30
            text: parent.parent.text
            color: "black"
            font.pointSize: uiButtonHeight *0.3
        }
        Text {
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            text: parent.parent.rightText
            color: "black"
            font.pointSize: uiButtonHeight *0.7
        }
    }
    MouseArea {
        anchors.fill: parent
        onClicked: parent.clicked()
    }
}
