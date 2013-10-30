import QtQuick 2.0

Rectangle {
    width: parent.width * 0.9
    height: statusText.height + 10
    anchors.horizontalCenter: parent.horizontalCenter
    color: "#f1f1f1"
    radius: 5
    opacity: siilihaimobile.statusMessage.length > 0 ? 1 : 0
    visible: opacity > 0
    clip: true
    Behavior on opacity { SmoothedAnimation { velocity: 1 } }
    Text {
        id: statusText
        text: siilihaimobile.statusMessage
        color: color2
        anchors.centerIn: parent
        font.pointSize: 16
    }
}
