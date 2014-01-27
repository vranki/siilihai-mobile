import QtQuick 2.0
import ".."

SimpleDialog {
    property bool enterUrl: false
    property int subscribeForumId: 0
    objectName: "subscribeForumDialog"
    ListView {
        id: subscribeList
        anchors.fill: parent
        spacing: 15
        header: Column {
            width: parent.width
            height: childrenRect.height
            spacing: 10
            Text {
                text: subscribeList.count ? "Subscribe to a forum" : "Getting forum list.."
                color: "white"
                font.pointSize: headerPointSize
                width: parent.width
            }
            SubscribeCustomButton {}
            Item {width: 1;height: 50}
        }
        model: forumList
        delegate: SubscribeForumButton { }
        footer: Item {width: 1; height: mainItem.height } // Spacer
        onModelChanged: returnToBounds()
    }
}
