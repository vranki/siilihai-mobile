import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    tools: commonTools

    ListView {
        anchors.fill: parent
        model: threads
        delegate: Row {
            ButtonWithUnreadCount {
                text: name
                unreads: unreadCount
                onClicked:  {
                    appWindow.threadSelected(id)
                    appWindow.pageStack.push(messageListPage)
                }
            }
        }
    }
}
