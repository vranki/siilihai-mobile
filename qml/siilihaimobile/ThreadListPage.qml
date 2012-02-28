import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    tools: commonTools

    ListView {
        anchors.fill: parent
        model: threads
        delegate: Row {
            Button {
                text: name + " (" + unreadCount + ")"
                width: threadListPage.width
                onClicked:  {
                    appWindow.threadSelected(id)
                    appWindow.pageStack.push(messageListPage)
                    console.log("thread selected " + id)
                }
            }
        }
    }
}
