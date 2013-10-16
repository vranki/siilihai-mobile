import QtQuick 2.0

Rectangle {
    width: 600
    height: 1024
    color: "white"

    ForumListView {
        width: parent.width
        height: parent.height - toolbar.height
    }

    Toolbar {
        id: toolbar
        anchors.bottom: parent.bottom
    }
}
