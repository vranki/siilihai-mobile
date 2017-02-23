import QtQuick 2.0

Rectangle {
    id: busyindicator
    property bool enabled: false
    color: "gray"
    radius: height
    clip: true
    Rectangle {
        id: busyRect
        color: color2
        height: parent.height
        width: height*2
        radius: height
        SequentialAnimation on x {
             running: enabled && Qt.application.active
             loops: Animation.Infinite
             NumberAnimation { from: 0; to: busyindicator.width-busyRect.width; duration: 1500; easing.type: Easing.InOutQuad }
             NumberAnimation { from: busyindicator.width-busyRect.width; to: 0; duration: 1500; easing.type: Easing.InOutQuad }
        }
    }
    opacity: enabled ? 1 : 0
    visible: opacity > 0
    Behavior on opacity { SmoothedAnimation { velocity: 1 } }
}
