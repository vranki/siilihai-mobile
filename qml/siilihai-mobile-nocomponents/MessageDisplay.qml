import QtQuick 2.0
//import QtWebKit 3.0
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
    height: bodyView.height + headers.height + buttonRow.height
    radius: 10

    Rectangle {
        color: "white"
        width: parent.width * 0.98
        height: bodyView.height
        radius: 2
        anchors.horizontalCenter: parent.horizontalCenter
        y: bodyView.y
    }
    Text {
        id: bodyView
        width: parent.width * 0.95
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
        font.pixelSize: largePixelSize
    }
    Item {
        id: headers
        height: author.height + subject.height + 10
        anchors.left: parent.left
        anchors.leftMargin: 5
        anchors.right: parent.right
        anchors.rightMargin: 5
        Text {
            id: subject
            color: color2
            anchors.left: parent.left
            text: modelData.displayName
            font.bold: !isRead
            font.pixelSize: largePixelSize
        }
        Text {
            anchors.right: parent.right
            anchors.top: subject.bottom
            color: color2
            text: modelData.lastchange
            font.pixelSize: largePixelSize
        }
        Text {
            id: author
            anchors.left: subject.left
            anchors.top: subject.bottom
            color: color2
            text: modelData.authorCleaned
            font.pixelSize: largePixelSize
        }
    }
    Row {
        id: buttonRow
        height: smallButtonHeight + 10
        width: headers.width
        anchors.top: headers.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        SimpleButton {
            width: parent.width / 4
            height: smallButtonHeight
            text: isRead ? "Read" : "Unread"
            onClicked: isRead = !isRead
        }
        SimpleButton {
            width: parent.width / 4
            height: smallButtonHeight
            text: "Open"
            onClicked: Qt.openUrlExternally(url)
            visible: url
        }
        SimpleButton {
            width: parent.width / 4
            height: smallButtonHeight
            text: "Re:";
            visible: selectedforum.supportsPosting && selectedforum.isAuthenticated
            onClicked: {
                composeMessage.newMessage()
                composeMessage.setSubject(siilihaimobile.addReToSubject(selectedthread.name))
                composeMessage.appendBody(siilihaimobile.addQuotesToBody(modelData.body))
                composeMessage.appendBody(siilihai.settings.signature)
                composeMessage.groupId = selectedgroup.id
                composeMessage.threadId = selectedthread.id
            }
        }

    }
}
