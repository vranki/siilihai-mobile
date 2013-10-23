import QtQuick 2.0

Rectangle {
    id: uibutton
    property string text: ""
    property string rightText: ""
    property string smallText: ""
    property string icon: ""
    property int uiButtonHeight: 42
    property bool drawBorder: true
    signal clicked

    width: parent.width
    height: uiButtonHeight
    color: drawBorder ? "#f7f7f7" : "transparent"
    radius: 5
    border.color: drawBorder ? "black" : "transparent"
    Image {
        id: iconImage
        anchors.left: parent.left
        anchors.leftMargin: parent.width * 0.005
        anchors.top: parent.top
        anchors.topMargin: 4
        height: uiButtonHeight * 0.8
        width: height
        source: icon
    }
    Item {
        anchors.left: iconImage.right
        anchors.right: rightText.left
        width: parent.width * 0.7
        height: uiButtonHeight
        Text {
            text: uibutton.smallText
            font.pixelSize: uiButtonHeight * 0.25
            color: "gray"
            anchors.bottom: parent.bottom
            anchors.left: mainLabel.left
        }
        Text {
            id: mainLabel
            anchors.verticalCenter: parent.verticalCenter
            x: parent.width / 30
            text: uibutton.text
            color: "black"
            font.pointSize: uiButtonHeight *0.3
            width: parent.width * 0.8
            wrapMode: Text.Wrap
        }
    }
    Text {
        id: rightText
        anchors.top: parent.top
        anchors.right: parent.right
        text: uibutton.rightText
        color: text !== "0" ? "#7d7dc0" : "#bdbdee"
        font.pointSize: uiButtonHeight *0.7
    }
    MouseArea {
        anchors.fill: parent
        onClicked: parent.clicked()
    }
}
