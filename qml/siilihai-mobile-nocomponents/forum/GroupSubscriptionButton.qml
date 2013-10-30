import QtQuick 2.0
import ".."
import "../widgets"

SimpleCheckBox {
    text: displayName
    checked: isSubscribed
    clip: true
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
