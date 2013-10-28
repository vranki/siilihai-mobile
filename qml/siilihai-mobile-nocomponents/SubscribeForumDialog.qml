import QtQuick 2.0

ListView {
    id: subscribeForumDialog
    property int subscribeForumId: 0
    visible: false
    objectName: "subscribeForumDialog"
    anchors.fill: parent
    header: Text {
        text: count > 0 ? "Subscribe to a forum" : "Getting forum list.."
        color: "white"
    }
    model: forumList
    delegate: SubscribeForumButton { }
    onVisibleChanged: if(visible) siilihaimobile.listSubscriptions()

    Rectangle {
        color: "black"
        anchors.fill: parent
        z: -10
    }
}
