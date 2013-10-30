import QtQuick 2.0
import ".."

SimpleButton {
    property string text: ""
    property bool checked: false
    height: 40
    anchors.horizontalCenter: parent.horizontalCenter
    Text {
        text: "✓"
        color: "white"
        anchors.left: parent.left
        anchors.leftMargin: 10
        font.pointSize: 30
        anchors.horizontalCenter: parent.horizontalCenter
        visible: checked
        z: 10
    }
    onClicked: checked = !checked
}
