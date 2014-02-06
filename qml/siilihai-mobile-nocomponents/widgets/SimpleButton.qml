import QtQuick 2.0

Rectangle {
    id: simpleButton
    property string text: ""
    property bool enabled: true
    property bool outline: true
    property bool centerText: true
    property string buttonColor: "white"
    property string bgColor: "transparent"
    property bool boldText: false
    signal clicked
    clip: true
    radius: 6
    color: bgColor
    border.color: outline ? buttonColor : "transparent"
    border.width: 2
    width: parent.width * 0.8
    height: defaultButtonHeight
    opacity: enabled ? 1 : 0.5
    Text {
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: centerText ? parent.horizontalCenter : undefined
        anchors.left: centerText ? undefined : parent.left
        anchors.leftMargin: centerText ? undefined : 50
        color: buttonColor
        text: parent.text
        font.bold: boldText
        font.pixelSize: 12
    }
    MouseArea {
        anchors.fill: parent
        onClicked: if(enabled) parent.clicked()
    }
    // Bg fill
    Rectangle {
        anchors.fill: parent
        radius: parent.radius
        gradient: Gradient {
            GradientStop {
                position: 0;
                color: "transparent"
            }
            GradientStop {
                position: 1;
                color: simpleButton.border.color;
            }
        }
        opacity: 0.3
        z: -100
    }
}
