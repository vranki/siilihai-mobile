import QtQuick 2.0

Item {
    width: parent.width
    height: parent.height / 10
    Rectangle {
        color: "black"
        opacity: 0.5
        anchors.fill: parent
    }
    Row {
        anchors.fill: parent
        ToolbarButton {
            image: "gfx/Gnome-go-previous.svg"
            visible: !siilihaimobile.noBackButton && threadListView.selectedGroup || messageListView.selectedThread || subscribeForumDialog.enabled
            onClicked: {
                if(subscribeForumDialog.topItem) {
                    subscribeForumDialog.topItem = false
                    return
                }
                if(messageListView.selectedThread) {
                    messageListView.active = false
                    messageListView.selectedThread = undefined
                } else {
                    threadListView.active = false
                    threadListView.selectedGroup = undefined
                }
            }
            Component.onCompleted: mainItem.backPressed.connect(clicked)
        }
        ToolbarButton {
            image: "gfx/Gnome-view-refresh.svg"
            onClicked: siilihaimobile.updateClicked()
            visible: !subscribeForumDialog.topItem && !threadListView.enabled && !messageListView.enabled
        }
        ToolbarButton {
            id: scrollDownButton
            visible: threadListView.selectedGroup || false
            image: "gfx/Gnome-go-bottom.svg"
            onClicked: {
                var scrollView = threadListView.item
                if(messageListView.selectedThread)
                    scrollView = messageListView.item
                scrollView.gotoIndex(scrollView.count-1)
            }
        }
        ToolbarButton {
            visible: scrollDownButton.visible
            image: "gfx/Gnome-go-top.svg"
            onClicked: {
                var scrollView = threadListView.item
                if(messageListView.selectedThread)
                    scrollView = messageListView.item
                scrollView.gotoIndex(0)
            }
        }
        ToolbarButton {
            image: "gfx/Gnome-preferences-system.svg"
            onClicked: settingsLoader.active = true
            visible: !subscribeForumDialog.topItem && !threadListView.selectedGroup
        }
        ToolbarButton {
            text: "(R)"
            onClicked: siilihaimobile.reloadUi()
            visible: siilihaimobile.developerMode
        }
    }
}
