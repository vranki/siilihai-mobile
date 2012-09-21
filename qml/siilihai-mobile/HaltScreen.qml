import QtQuick 1.0
import com.nokia.meego 1.0

Page {
    anchors.fill: parent
    property string text
    Column {
        Label {
            text: "Quitting, please wait"
            wrapMode: Text.Wrap
        }
        Label {
            text: mainPage.message
            wrapMode: Text.Wrap
            font.italic: true
        }
    }
}
