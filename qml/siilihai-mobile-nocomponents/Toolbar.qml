import QtQuick 2.0

Item {
    height: parent.height / 10
    width: buttonRow.width

    Rectangle {
        color: "black"
        opacity: 0.5
        anchors.fill: parent
    }
    Row {
        id: buttonRow
        height: parent.height

        ToolbarButton {
            image: "gfx/Gnome-go-previous.svg"
            visible: !siilihaimobile.noBackButton
                     && (threadListView.selectedGroup
                         || messageListView.selectedThread
                         || subscribeForumDialog.active
                         || forumSettingsDialog.active
                         || settingsLoader.active)
            onClicked: mainItem.backPressed()
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
                scrollView.positionViewAtEnd()
            }
        }
        ToolbarButton {
            visible: scrollDownButton.visible
            image: "gfx/Gnome-go-top.svg"
            onClicked: {
                var scrollView = threadListView.item
                if(messageListView.selectedThread)
                    scrollView = messageListView.item
                scrollView.positionViewAtBeginning()
            }
        }
        ToolbarButton {
            text: "(R)"
            onClicked: siilihaimobile.reloadUi()
            visible: siilihaimobile.developerMode
        }
    }
}
