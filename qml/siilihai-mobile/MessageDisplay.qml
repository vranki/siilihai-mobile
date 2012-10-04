import QtQuick 1.0
import com.nokia.meego 1.0
import QtWebKit 1.0

Rectangle {
    id: message
    property string subject: "?"
    property string author: "?"
    property string messageBody: "xxx"
    property bool messageRead: false
    property string messageId: ""
    width: mainPage.width
    height: subjectLine.height + body.height + 40
    radius: 15
    smooth: true
    anchors.bottomMargin: 4

    Label {
        id: subjectLine
        text: message.subject + " (" + message.author + ")"
        width: message.width - openButton.width
        wrapMode: Text.WordWrap
        font.pointSize: 20
        color: "white"
    }

    Button {
        id: openButton
        iconSource: "emblem-web.png"
        anchors.left: subjectLine.right
        width: height
        onClicked: {
            openInBrowser(messageId)
        }
    }

    Label {
        id: toolLine
        text: (messageRead?"Read":"Unread") + " by " + message.author
        width: message.width
        font.pointSize: 12
        anchors.top: subjectLine.bottom
    }
    WebView {
        id: body
        html: message.messageBody
        width: message.width
        anchors.top: toolLine.bottom
        z: 10
    }
/*
    Label {
        id: body
        text: message.messageBody
        font.pointSize: 12
        color: "black"
        width: message.width
        anchors.top: toolLine.bottom
        wrapMode: Text.WordWrap
        z: 10
    }
*/
    Rectangle {
        radius: 5
        smooth: true
        color: "white"
        width: message.width
        height: body.height
        anchors.top: body.top
    }

    gradient: Gradient {
        GradientStop {
            position: 0.0
            color: "#888888"
        }
        GradientStop {
            position: 0.1
            color: "#AAAAAA"
        }
        GradientStop {
            position: 0.8
            color: "#CCCCCC"
        }
        GradientStop {
            position: 1.0
            color: "#CCCCFF"
        }
    }
}
