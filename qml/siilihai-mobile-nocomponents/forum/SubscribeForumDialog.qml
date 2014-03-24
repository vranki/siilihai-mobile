import QtQuick 2.0
import ".."
import "../widgets"

SimpleDialog {
    property bool enterUrl: false
    property int subscribeForumId: 0
    objectName: "subscribeForumDialog"
    ListView {
        id: subscribeList
        property string forumFilterString: ""
        anchors.fill: parent
        header: Column {
            width: parent.width
            height: childrenRect.height
            spacing: 10
            Text {
                text: subscribeList.count ? "Subscribe to a forum" : "Getting forum list.."
                color: "white"
                font.pixelSize: headerPixelSize
                width: parent.width
            }
            SubscribeCustomButton {}
            Text {
                font.pixelSize: smallPixelSize
                color: color_b_text
                text: "Search:"
            }
            SimpleTextEdit {
                clearButton: true
                onTextChanged: subscribeList.forumFilterString = text.toLocaleLowerCase()
            }
            Item {width: 1;height: 50}
        }
        model: forumList
        delegate: SubscribeForumButton { loadImage: (!subscribeList.moving && topItem)}
        footer: Item {width: 1; height: mainItem.height } // Spacer
        onModelChanged: {
            returnToBounds()
            subscribeList.forumFilterString = ""
        }
    }
}
