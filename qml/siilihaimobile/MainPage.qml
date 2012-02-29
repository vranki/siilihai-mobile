import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    tools: commonTools

    ListView {
        anchors.fill: parent
        model: subscriptions
        header: Text {
            text: "Forums";
        }
        delegate: Row {
            Button {
                text: alias + " (" + unreadCount + ")"
                width: mainPage.width
                onClicked:  {
                    appWindow.subscriptionSelected(parser)
                    appWindow.pageStack.push(groupListPage)
                    console.log("sub selected " + parser)
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
