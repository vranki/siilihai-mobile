import QtQuick 2.0
import ".."
import "../widgets"

SimpleCheckBox {
    text: displayName
    checked: isSubscribed
    clip: true
    boldText: checked
    height: tallButtonHeight
    Text {
        text: hierarchy
        color: color1
        font.pointSize: smallPointSize
        anchors.left: parent.left
        anchors.leftMargin: 50
        anchors.bottom: parent.bottom
    }
    onClicked: isSubscribed = !isSubscribed
}
