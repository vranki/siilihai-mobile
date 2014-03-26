import QtQuick 2.0

Column {
    property string text: "?"
    property int value: 0
    property int valueMin: 0
    property int valueMax: 10

    width: parent.width
    Text {
        text: parent.text
        font.pixelSize: largePixelSize
        color: color_b_text
    }
    Rectangle {
        width: parent.width
        height: defaultButtonHeight
        color: "green"
        Rectangle {
            width: parent.width / 10
            height: parent.height
            x: (value - valueMin) / valueMax - width/2
            color: "white"
        }
        Text {
            font.pixelSize: largePixelSize
            color: color_b_text
            text: Math.round(value)
        }
        MouseArea {
            anchors.fill: parent
            onMouseXChanged: {
                value = valueMin + mouseX / width * (valueMax - valueMin)
            }
        }
    }
}
