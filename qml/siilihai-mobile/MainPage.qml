import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    tools: commonTools
    property bool busy: true
    property string message: ""
    ListView {
        anchors.fill: parent
        model: subscriptions
        header: Column {
            width: parent.width
            Text {
                text: "Forums";
                color: "white"
            }
            ProgressBar {
                indeterminate: true
                width: parent.width
                visible: mainPage.busy
            }
            Text {
                id: statusmessage
                text: mainPage.message
                font.italic: true
                color: "white"
            }
        }
        delegate: Row {
            ButtonWithUnreadCount {
                label: alias
                unreads: unreadCount
                onClicked:  {
                    appWindow.subscriptionSelected(parser)
                    appWindow.pageStack.push(groupListPage)
                }
            }
        }
        footer: Button {
            anchors.topMargin: 20
            text: "Subscribe new.."
            onClicked: appWindow.showSubscribeWizard()
        }
    }
}
