import QtQuick 2.0

Rectangle {
    property string text: ""
    property bool enabled: true
    property bool outline: true
    property bool centerText: true
    property string buttonColor: "white"
    property bool boldText: false
    signal clicked
    clip: true
    radius: 10
    color: "transparent"
    border.color: outline ? buttonColor : "transparent"
    border.width: 2
    width: parent.width * 0.8
    height: 32
    opacity: enabled ? 1 : 0.5
    Text {
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: centerText ? parent.horizontalCenter : undefined
        anchors.left: centerText ? undefined : parent.left
        anchors.leftMargin: centerText ? undefined : 50
        color: buttonColor
        text: parent.text
        font.bold: boldText
    }
    MouseArea {
        anchors.fill: parent
        onClicked: if(enabled) parent.clicked()
    }
}
