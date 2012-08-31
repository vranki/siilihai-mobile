import QtQuick 1.0
import com.nokia.meego 1.0

Page {
    tools: commonTools
    anchors.fill: parent
    property string text
    Text {
        text: messagePage.text
        wrapMode: Text.Wrap
        anchors.fill: parent
        color: "white"
    }
}
