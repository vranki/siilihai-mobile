import QtQuick 2.0

ListView {
    property bool topItem: false
    property int subscribeForumId: 0
    x: topItem ? 0 : parent.width
    objectName: "subscribeForumDialog"
    spacing: 15
    header: Text {
        text: count > 0 ? "Subscribe to a forum" : "Getting forum list.."
        color: "white"
        font.pointSize: 25
    }
    model: forumList
    delegate: SubscribeForumButton { }

    Rectangle {
        color: "black"
        anchors.fill: parent
        z: -10
    }
}
