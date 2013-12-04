import QtQuick 2.0

Rectangle {
    property bool topItem: false
    y: topItem ? 0 : -height
    visible: y > -height
    //source: "gfx/backbround-dark.png"
    //fillMode: Image.Tile
    color: "black"
    opacity: 0.9
    width: parent.width
    height: parent.height
    Behavior on y { SmoothedAnimation { velocity: 1500; easing.type: Easing.InOutQuad  } }
    HideEffect {}

    MouseArea {
        anchors.fill: parent
    }
}
