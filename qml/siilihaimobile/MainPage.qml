import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    tools: commonTools
    QueryDialog {
        id: dialog
        message: "kekeke"
        visible: true
    }

    ListView {
        anchors.fill: parent
        model: subscriptions
        delegate: Row {
            Button {
                text: parser + ": " + alias + " (" + unreadCount + ")"
                width: mainPage.width
                onClicked:  {
                    appWindow.subscriptionSelected(parser)
                    appWindow.pageStack.push(groupListPage)
                    console.log("sub selected " + parser)
                }
            }
        }
    }
}
