import QtQuick 2.0
import ".."
import "../widgets"

SimpleCheckBox {
    text: modelData.displayName
    checked: modelData.isSubscribed
    clip: true
    boldText: checked
    height: filterMatches ? tallButtonHeight : 0
    property bool filterMatches: (groupList.groupFilterString.length == 0) || (text.toLocaleLowerCase().indexOf(groupList.groupFilterString) > -1)
    Behavior on height { SmoothedAnimation { velocity: 800 } }
    Text {
        text: modelData.hierarchy
        color: color1
        font.pixelSize: smallPixelSize
        anchors.left: parent.left
        anchors.leftMargin: 50
        anchors.bottom: parent.bottom
    }
    onClicked: modelData.isSubscribed = !modelData.isSubscribed
}
