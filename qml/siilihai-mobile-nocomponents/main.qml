import QtQuick 2.0
import QtGraphicalEffects 1.0

Rectangle {
    width: 600
    height: 1024
    color: "white"

    ForumListView {
        id: forumListView
        property bool topItem: !threadListView.topItem && !messageListView.topItem
        width: parent.width
        height: parent.height - toolbar.height
    }
    RecursiveBlur {
        anchors.fill: forumListView
        source: forumListView
        radius: 7.5
        loops: 5
        opacity: forumListView.topItem ? 0 : 1
        visible: opacity > 0
        Behavior on opacity { SmoothedAnimation { velocity: 5 } }
    }
    ThreadListView {
        id: threadListView
        property bool topItem: siilihaimobile.selectedGroupId
        width: parent.width
        height: parent.height - toolbar.height
        x: topItem ? 0 : parent.width
        Behavior on x { SmoothedAnimation { velocity: 1500 } }
    }
    MessageListView {
        id: messageListView
        property bool topItem: siilihaimobile.selectedThreadId
        width: parent.width
        height: parent.height - toolbar.height
        x: topItem ? 0 : parent.width
        Behavior on x { SmoothedAnimation { velocity: 1500 } }
    }
    Toolbar {
        id: toolbar
        anchors.bottom: parent.bottom
    }
}
