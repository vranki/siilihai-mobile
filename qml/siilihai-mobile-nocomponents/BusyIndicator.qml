import QtQuick 2.0

Rectangle {
    id: busyindicator
    property bool enabled: false
    color: "gray"
    radius: height
    clip: true
    Rectangle {
        color: color2
        height: parent.height
        width: height*2
        SequentialAnimation on x {
             running: enabled
             loops: Animation.Infinite
             NumberAnimation { from: 0; to: busyindicator.width; duration: 500; easing.type: Easing.InOutQuad }
             NumberAnimation { from: busyindicator.width; to: 0; duration: 500; easing.type: Easing.InOutQuad }
        }
    }
    opacity: enabled ? 1 : 0
    visible: opacity > 0
    Behavior on opacity { SmoothedAnimation { velocity: 1 } }
}
