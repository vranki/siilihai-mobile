import QtQuick 2.0

TextEdit {
    color: "yellow"
    font.pointSize: 15
    width: parent.width * 0.9
    anchors.horizontalCenter: parent.horizontalCenter
    focus: false
    Rectangle {
        anchors.fill: parent
        color: "yellow"
        z: -10
        opacity: 0.5
    }
}
