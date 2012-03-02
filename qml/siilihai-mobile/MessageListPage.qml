import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    tools: commonTools

    ListView {
        anchors.fill: parent
        model: messages
        delegate: Row {
            MessageDisplay {
                subject: displayName
                author: authorCleaned
                messageBody: body
                messageRead: isRead
            }
        }
        footer: Button {
            text: "Mark thread read"
            onClicked: appWindow.markThreadRead()
        }
    }
}
