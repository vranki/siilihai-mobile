import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    tools: commonTools

    ListView {
        anchors.fill: parent
        model: threads
        delegate: Row {
            ButtonWithUnreadCount {
                label: name
                unreads: unreadCount
                onClicked:  {
                    appWindow.threadSelected(id)
                    messageListPage.hasMoreMessages = hasMoreMessages
                    appWindow.pageStack.push(messageListPage)
                }
            }
        }
    }
}
