import QtQuick 2.0
import ".."

SimpleDialog {
    property bool enterUrl: false
    property int subscribeForumId: 0
    objectName: "subscribeForumDialog"
    ListView {
        anchors.fill: parent
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
    }
}
