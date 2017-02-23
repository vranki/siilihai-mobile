import QtQuick 2.0
import "widgets"

Rectangle {
    id: uibutton
    property string text: ""
    property string rightText: ""
    property string smallText: ""
    property string icon: ""
    property string iconEmblems: ""
    property string buttonColor: drawBorder ? color_a_buttons : "transparent"
    property bool enableClickAnimation: true
    property bool drawBorder: true
    property bool busy: false
    signal clicked

    width: parent.width
    height: defaultButtonHeight
    color: buttonColor
    radius: 5
    border.color: drawBorder ? color_a_text : "transparent"

    SequentialAnimation on color {
        id: clickAnimation
        running: false
        ColorAnimation { from: color_a_buttons_pressed; to: buttonColor }
    }

    // The top header of a forum
    Item {
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width * 0.98
        height: defaultButtonHeight * 0.85
        y: defaultButtonHeight * 0.05

        Image {
            id: iconImage
            anchors.verticalCenter: parent.verticalCenter
            height: defaultButtonHeight * 0.8
            width: height
            source: icon
            asynchronous: true
            Rectangle {
                color: "black"
                visible: iconImage.status !== Image.Ready
                opacity: 0.2
                anchors.fill: parent
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: iconEmblems
                style: Text.Outline
                color: "white"
                styleColor: "black"
            }
        }
        Item {
            anchors.left: iconImage.right
            anchors.right: rightText.left
            width: parent.width * 0.8
            height: defaultButtonHeight

            Text {
                id: mainLabel
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: smallLabel.visible ? - parent.height * 0.2 : 0
                x: parent.width / 30
                text: uibutton.text
                color: "black"
                font.pixelSize: defaultButtonHeight * 0.3
                width: parent.width * 0.8
                wrapMode: Text.Wrap
            }
            Text {
                id: smallLabel
                text: uibutton.smallText
                font.pixelSize: defaultButtonHeight * 0.25
                color: "gray"
                anchors.top: mainLabel.bottom
                anchors.left: mainLabel.left
                visible: text
            }
        }
        BusyIndicator {
            enabled: busy
            anchors.right: rightText.left
            width: parent.width * 0.2
            anchors.verticalCenter: parent.verticalCenter
            height: parent.height / 2
        }
        Text {
            id: rightText
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: parent.width * 0.001
            text: uibutton.rightText
            color: text !== "0" ? color1 : "#bdbdee"
            font.pixelSize: defaultButtonHeight * 0.7
        }

        MouseArea {
            anchors.fill: parent
            onClicked: uibutton.clicked()
            onPressed: if(enableClickAnimation) clickAnimation.restart()
        }
    }
}
