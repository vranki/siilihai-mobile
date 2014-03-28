import QtQuick 2.0

Column {
    property string text: "?"
    property int value: 0
    property int valueMin: 0
    property int valueMax: 10

    width: parent.width*0.95
    anchors.horizontalCenter: parent.horizontalCenter
    Item {
        width: parent.width
        height: defaultButtonHeight
        Text {
            text: parent.parent.text
            font.pixelSize: largePixelSize
            color: color_b_text
            anchors.bottom: parent.bottom
        }
        Text {
            text: Math.round(value)
            font.pixelSize: headerPixelSize
            color: color_b_text
            anchors.right: parent.right
            anchors.bottom: parent.bottom
        }
    }
    Item {
        width: parent.width
        height: defaultButtonHeight
        anchors.horizontalCenter: parent.horizontalCenter

        Rectangle {
            anchors.fill: parent
            color: color_input
            opacity: 0.3
            radius: 5
        }
        Rectangle {
            id: slider
            width: parent.width / 10
            height: parent.height * 0.7
            x: (parent.width - width) * ((value - valueMin) / valueMax)
            anchors.verticalCenter: parent.verticalCenter
            color: color_input
            radius: 5
            Behavior on x { SmoothedAnimation { velocity: 1500; easing.type: Easing.InOutQuad  } }
        }
        MouseArea {
            anchors.fill: parent
            onMouseXChanged: {
                var newValue = valueMin + ((mouseX) / (width - slider.width) * (valueMax - valueMin))
                if(newValue > valueMax) newValue = valueMax;
                if(newValue < valueMin) newValue = valueMin;
                value = newValue
            }
        }

    }
}
