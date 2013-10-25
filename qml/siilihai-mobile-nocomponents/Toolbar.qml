import QtQuick 2.0

Rectangle {
    width: parent.width
    height: 80
    color: "black"
    Row {
        anchors.fill: parent
        ToolbarButton {
            text: "⇐"
            visible: siilihaimobile.selectedGroupId != "" || siilihaimobile.selectedThreadId != ""
            onClicked: {
                if(siilihaimobile.selectedThreadId) {
                    siilihaimobile.selectedThreadId = ""
                } else {
                    siilihaimobile.selectedGroupId = ""
                }
            }
        }
        ToolbarButton {
            text: "⟲"
            onClicked: siilihaimobile.updateClicked()
        }
        ToolbarButton {
            id: scrollDownButton
            visible: siilihaimobile.selectedGroupId != ""
            text: "⤓"
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
            text: "⤒"
            onClicked: {
                var scrollView = threadListView
                if(siilihaimobile.selectedThreadId != "")
                    scrollView = messageListView
                scrollView.contentY = 0
                scrollView.returnToBounds()
            }
        }
        ToolbarButton {
            text: "R"
            onClicked: siilihaimobile.reloadUi()
        }
    }
}
