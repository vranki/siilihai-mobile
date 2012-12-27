import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    property bool hasMoreMessages: false
    property string threadname: "?"

    tools: ToolBarLayout {
        visible: true
        ToolIcon {
            id: backButton
            platformIconId: "toolbar-back"
            onClicked: pageStack.pop()
        }
        ToolIcon {
            id: upButton
            platformIconId: "toolbar-up"
            onClicked: {
                messagelistview.contentY = 0
                messagelistview.returnToBounds()
            }
            anchors.left: backButton.right
            visible: !messagelistview.atYBeginning
        }
        ToolIcon {
            platformIconId: "toolbar-down"
            onClicked: {
                messagelistview.contentY = messagelistview.contentHeight
                messagelistview.returnToBounds()
            }
            anchors.left: upButton.right
            visible: !messagelistview.atYEnd
        }
        ToolIcon {
            platformIconId: "toolbar-view-menu"
            anchors.right: (parent === undefined) ? undefined : parent.right
            onClicked: (myMenu.status == DialogStatus.Closed) ? myMenu.open() : myMenu.close()
        }
    }
    Rectangle {
        id: scrollbar
        anchors.right: messagelistview.right
        y: messagelistview.visibleArea.yPosition * messagelistview.height
        width: 10
        height: messagelistview.visibleArea.heightRatio * messagelistview.height
        color: "black"
        z: 100
        visible: messagelistview.moving
    }
    Rectangle {
        id: scrollbarbg
        anchors.right: messagelistview.right
        y: 0
        width: 10
        height: messagelistview.height
        color: "white"
        z: 99
        visible: scrollbar.visible
    }
    ListView {
        id: messagelistview
        anchors.fill: parent
        model: messages
        boundsBehavior: Flickable.StopAtBounds

        delegate: Row {
            MessageDisplay {
                subject: displayName
                author: authorCleaned
                messageBody: body
                messageRead: isRead
                messageId: id
            }
        }
        footer: Column {
            anchors.topMargin: 10
            spacing: 30
            Button {
                text: "Show more messages.."
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: appWindow.showMoreMessages()
                visible: hasMoreMessages
            }
            Button {
                text: "Mark thread read"
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: appWindow.markThreadRead(true)
            }
            Button {
                text: "Mark thread unread"
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: appWindow.markThreadRead(false)
            }
        }
    }
}
