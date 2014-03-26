import QtQuick 2.0

Rectangle {
    id: simpleButton
    property string text: ""
    property string icon: ""
    property bool enabled: true
    property bool outline: true
    property bool centerText: true
    property string buttonColor: "white"
    property string bgColor: "transparent"
    property bool boldText: false
    property int fontSize: defaultButtonHeight / 2.5
    property int leftMargin: 50
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
        anchors.leftMargin: centerText ? undefined : parent.leftMargin
        color: buttonColor
        text: parent.text
        font.bold: boldText
        font.pixelSize: fontSize
    }
    MouseArea {
        anchors.fill: parent
        onClicked: if(enabled) parent.clicked()
        onPressed: if(enabled) { clickAnimation.restart(); clickOpacityAnimation.restart() }
    }
    // Bg fill
    Rectangle {
        anchors.fill: parent
        radius: parent.radius
        gradient: Gradient {
            GradientStop {
                position: 0;
                color: "transparent"
                SequentialAnimation on color {
                    id: clickAnimation
                    running: false
                    ColorAnimation { from: simpleButton.border.color; to: "transparent" }
                }
            }
            GradientStop {
                position: 1;
                color: simpleButton.border.color;
            }
        }
        opacity: 0.3
        SequentialAnimation on opacity {
            id: clickOpacityAnimation
            running: false
            NumberAnimation { from: 1; to: 0.3 }
        }
        z: -100
    }
    Image {
        anchors.left: parent.left
        anchors.leftMargin: parent.width * 0.005
        anchors.top: parent.top
        anchors.topMargin: 4
        height: defaultButtonHeight * 0.8
        width: height
        source: icon
    }
}
