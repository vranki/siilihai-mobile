import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    tools: commonTools

    ListView {
        anchors.fill: parent
        model: messages
        delegate: messageDelegate
    }

    Component {
        id: messageDelegate
        Column {
            Text {
                width: messageListPage.width
                text: displayName + " (" + author + ")"
                font.pointSize: 12
                font.bold: true
                wrapMode: Text.Wrap
            }
            Text {
                width: messageListPage.width
                text: body
                font.pointSize: 8
                wrapMode: Text.Wrap
            }
        }
    }
}
