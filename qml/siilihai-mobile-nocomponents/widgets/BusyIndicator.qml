import QtQuick 2.7

Image {
    id: busyindicator
    property bool enabled: false
    source: "../gfx/spinning-circles.svg"
    width: height
    height: parent.height

    RotationAnimator {
        target: busyindicator
        from: 0
        to: 360
        duration: 1000
        running: visible
        loops: Animation.Infinite
    }
    opacity: enabled ? 1 : 0
    visible: opacity > 0
    Behavior on opacity { SmoothedAnimation { velocity: 1 } }
}
