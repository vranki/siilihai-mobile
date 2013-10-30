import QtQuick 2.0

ListView {
    property bool topItem: false
    property bool enterUrl: false
    property int subscribeForumId: 0
    x: topItem ? 0 : parent.width
    objectName: "subscribeForumDialog"
    spacing: 15
    header: Column {
        width: parent.width
        spacing: 10

        Text {
            text: count > 0 ? "Subscribe to a forum" : "Getting forum list.."
            color: "white"
            font.pointSize: 25
            width: parent.width
        }
        SubscribeCustomButton {}
    }
    model: forumList
    delegate: SubscribeForumButton { }

    Rectangle {
        color: "black"
        anchors.fill: parent
        z: -10
    }
}
