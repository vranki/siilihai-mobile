import QtQuick 2.0
import ".."


SimpleCheckBox {
    text: displayName
    checked: isSubscribed
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
