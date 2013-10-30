import QtQuick 2.0
import ".."


SimpleButton {
    text: displayName
    height: 40
    anchors.horizontalCenter: parent.horizontalCenter
    Text {
        text: "✓"
        color: "white"
        anchors.left: parent.left
        anchors.leftMargin: 10
        font.pointSize: 30
        anchors.horizontalCenter: parent.horizontalCenter
        visible: isSubscribed
        z: 10
    }
    Text {
        text: hierarchy
        color: color1
        font.pointSize: 8
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 3
    }
    onClicked: isSubscribed = !isSubscribed
}
