import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    tools: commonTools
    property string groupname: "?"

    ListView {
        anchors.fill: parent
        model: threads

        header: Label {
            text: "Threads in group " + groupname;
            color: "white"
            wrapMode: Text.Wrap
        }

        delegate: Row {
            ButtonWithUnreadCount {
                label: name
                unreads: unreadCount
                onClicked:  {
                    appWindow.threadSelected(id)
                    messageListPage.hasMoreMessages = hasMoreMessages
                    messageListPage.threadname = displayName
                    appWindow.pageStack.push(messageListPage)
                }
            }
        }
    }
}
