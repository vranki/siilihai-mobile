import QtQuick 1.0
import com.nokia.meego 1.0

Page {
    tools: commonTools
    anchors.fill: parent

    ListView {
        model: subscribeGroupList
        anchors.fill: parent

        header: Text {
            id: text
            text: "Subscribe to groups"
            wrapMode: Text.Wrap
            color: "white"
        }

        delegate: Row {
            CheckBox {
                text: displayName
                width: mainPage.width
                checked: isSubscribed
                onCheckedChanged: {
                    appWindow.setGroupSubscribed(id, checked)
                }
            }
        }

        footer: Button {
            text: "Apply"
            onClicked: {
                appWindow.applyGroupSubscriptions()
                appWindow.pageStack.pop()
            }
        }
    }
}
