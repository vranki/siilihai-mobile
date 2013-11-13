import QtQuick 2.0

Rectangle {
    property bool topItem: false
    y: topItem ? 0 : -height
    visible: y > -height
    color: "black"
    width: parent.width
    height: parent.height
    opacity: 0.9
    Behavior on y { SmoothedAnimation { velocity: 1500; easing.type: Easing.InOutQuad  } }
    HideEffect {}

    MouseArea {
        anchors.fill: parent
    }
}
