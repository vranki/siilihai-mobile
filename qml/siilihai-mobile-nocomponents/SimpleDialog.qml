import QtQuick 2.0

Rectangle {
    property bool topItem: false
    y: topItem ? 0 : -height
    visible: y > -height
    color: color_b_bg
    opacity: 0.95
    width: parent.width
    height: parent.height
    Behavior on y { SmoothedAnimation { velocity: 1500; easing.type: Easing.InOutQuad  } }
    HideEffect {}

    MouseArea {
        anchors.fill: parent
        onClicked: hideVkb()
    }
    onTopItemChanged: hideVkb()
}
