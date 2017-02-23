import QtQuick 2.0
import ".."
import "../widgets"

SimpleDialog {
    id: subscribeForumDialog
    property int subscribeForumId: -1 // ID of currently selected forum
    property bool enterUrl: false

    signal terminate
    onTerminate: terminateTimer.start()

    topItem: true

    ListView {
        id: subscribeList
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
                onTextChanged: siilihai.subscriptionManagement.forumFilter = text.toLocaleLowerCase()
                onFocusChanged: console.trace()
            }
            Item {width: 1;height: 50}
        }
        model: siilihai.subscriptionManagement.forumList
        delegate: SubscribeForumButton { loadImage: (!subscribeList.moving && topItem)}
        footer: Item {width: 1; height: mainItem.height } // Spacer
        onModelChanged: {
            returnToBounds()
            // siilihai.subscriptionManagement.forumFilter = ""
        }
    }

    Component.onCompleted: siilihai.subscriptionManagement.listForums()
}
