import QtQuick 2.0
import QtGraphicalEffects 1.0

RecursiveBlur {
    anchors.fill: parent
    source: parent
    radius: 7.5
    loops: 5
    opacity: parent.topItem ? 0 : 1
    visible: opacity > 0
    Behavior on opacity { SmoothedAnimation { velocity: 5 } }
}
