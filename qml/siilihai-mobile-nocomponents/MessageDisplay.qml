import QtQuick 2.0
import QtWebKit 3.0

Rectangle {
    color: colorDark
    width: parent.width
    height: bodyView.height + headers.height
    radius: 10

    Text {
        id: bodyView
        width: parent.width * 0.98
        color: "black"
        text: modelData.body
        wrapMode: Text.Wrap
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
        anchors.horizontalCenter: parent.horizontalCenter
        textFormat: Text.RichText
        Rectangle {
            color: "white"
            anchors.fill: parent
            z: -10
            radius: 2
        }
    }
    /*
//      Can't figure out height of this so it looks sane
    WebView {
        id: bodyView
        width: parent.width
        height: contentHeight
        anchors.bottom: parent.bottom
        Component.onCompleted: loadHtml(modelData.body)
    }
    */
    Item {
        id: headers
        width: parent.width * 0.9
        height: author.height + subject.height + 10
        anchors.horizontalCenter: parent.horizontalCenter
        Text {
            id: author
            anchors.left: parent.left
            color: color2
            text: modelData.authorCleaned
        }
        Text {
            anchors.right: parent.right
            color: color2
            text: modelData.lastchange
        }
        Text {
            id: subject
            anchors.left: author.left
            anchors.top: author.bottom
            color: color2
            text: modelData.displayName
        }
    }
}
