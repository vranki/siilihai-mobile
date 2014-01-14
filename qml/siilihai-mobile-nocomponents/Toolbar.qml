import QtQuick 2.0

Item {
    width: parent.width
    height: 80
    Rectangle {
        color: "black"
        opacity: 0.5
        anchors.fill: parent
    }
    Row {
        anchors.fill: parent
        ToolbarButton {
            image: "gfx/Gnome-go-previous.svg"
            visible: !siilihaimobile.noBackButton && (siilihaimobile.selectedGroupId != "" || siilihaimobile.selectedThreadId != "" || subscribeForumDialog.topItem)
            onClicked: {
                if(subscribeForumDialog.topItem) {
                    subscribeForumDialog.topItem = false
                    return
                }
                if(siilihaimobile.selectedThreadId) {
                    siilihaimobile.selectedThreadId = ""
                } else {
                    siilihaimobile.selectedGroupId = ""
                }
            }
            Component.onCompleted: mainItem.backPressed.connect(clicked)
        }
        ToolbarButton {
            image: "gfx/Gnome-view-refresh.svg"
            onClicked: siilihaimobile.updateClicked()
            visible: !subscribeForumDialog.topItem && !threadListView.topItem && !messageListView.topItem
        }
        ToolbarButton {
            id: scrollDownButton
            visible: siilihaimobile.selectedGroupId != ""
            image: "gfx/Gnome-go-bottom.svg"
            onClicked: {
                var scrollView = threadListView
                if(siilihaimobile.selectedThreadId != "")
                    scrollView = messageListView
                scrollView.contentY = scrollView.contentHeight - scrollView.height
                scrollView.returnToBounds()
            }
        }
        ToolbarButton {
            visible: scrollDownButton.visible
            image: "gfx/Gnome-go-top.svg"
            onClicked: {
                var scrollView = threadListView
                if(siilihaimobile.selectedThreadId != "")
                    scrollView = messageListView
                scrollView.contentY = 0
                scrollView.returnToBounds()
            }
        }/*
        ToolbarButton {
            text: "R"
            onClicked: siilihaimobile.reloadUi()
        }*/
        ToolbarButton {
            image: "gfx/Gnome-preferences-system.svg"
            onClicked: settingsDialog.topItem = true
            visible: !subscribeForumDialog.topItem && !threadListView.topItem && !messageListView.topItem
        }
    }
}
