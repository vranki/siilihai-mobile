import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    tools: commonTools

    ListView {
        anchors.fill: parent
        model: messages
        delegate: Row {
            Label {
                text: id + ": " + name
                width: messageListPage.width
            }
        }
    }
}
