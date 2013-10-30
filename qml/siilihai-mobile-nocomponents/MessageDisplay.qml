import QtQuick 2.0
import QtWebKit 3.0
import "widgets"

Rectangle {
    property string htmlHeader: "<html><head><META HTTP-EQUIV=\"Content-Type\" CONTENT=\"text/html; charset=UTF-8\">" +
    "<style type=\"text/css\">" +
    "div.monospace { font-family: \"Fixed\",\"monospace\"; }" +
    "div.quotecontent { background: #EEEEEE; margin: 5px; }" +
    "div.quote { background: #EEEEEE; margin: 5px; }" +
    "blockquote { background: #EEEEEE; margin: 5px; }" +
    "td.quote { background: #EEEEEE; margin: 5px; }" +
    "</style>\n"

    color: isRead ? colorLessDark : colorDark
    width: parent.width
    height: bodyView.height + headers.height
    radius: 10

    Text {
        id: bodyView
        width: parent.width * 0.98
        color: "black"
        // Works not
        //text: htmlHeader + modelData.body + "</body>"
        text: modelData.body
        wrapMode: Text.Wrap
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
        anchors.horizontalCenter: parent.horizontalCenter
        textFormat: Text.RichText
        onLinkActivated: Qt.openUrlExternally(link)
        Rectangle {
            color: "white"
            anchors.fill: parent
            z: -10
            radius: 2
        }
    }
    Item {
        id: headers
        height: author.height + subject.height + 10
        anchors.left: buttonRow.right
        anchors.leftMargin: 5
        anchors.right: parent.right
        anchors.rightMargin: 5
        Text {
            id: subject
            color: color2
            anchors.left: parent.left
            text: modelData.displayName
            font.bold: !isRead
        }
        Text {
            anchors.right: parent.right
            color: color2
            text: modelData.lastchange
        }
        Text {
            id: author
            anchors.left: subject.left
            anchors.top: subject.bottom
            color: color2
            text: modelData.authorCleaned
        }
    }
    Row {
        id: buttonRow
        height: headers.height * 0.8
        anchors.top: parent.top
        anchors.topMargin: 2
        anchors.left: parent.left
        anchors.leftMargin: 5
        SimpleButton {
            width: height * 1.5
            height: parent.height
            text: isRead ? "Read" : "Unread"
            onClicked: isRead = !isRead
        }
        SimpleButton {
            width: height * 1.5
            height: parent.height
            text: "Open"
            onClicked: Qt.openUrlExternally(url)
        }
    }
}
