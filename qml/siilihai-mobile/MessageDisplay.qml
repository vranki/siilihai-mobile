import QtQuick 1.0
import com.nokia.meego 1.0
import QtWebKit 1.0

Rectangle {
    id: message
    property string subject: "?"
    property string author: "?"
    property string messageBody: ""
    property bool messageRead: false
    property string messageId: ""

    property string styleHtml: "<style type=\"text/css\">#siilihai-header {
    color: white;
    margin: 3px;
    padding: 3px 3%;
    }
    div.monospace { font-family: \"Fixed\",\"monospace\"; }
    div.quotecontent { background: #EEEEEE; margin: 5px; }
    div.quote { background: #EEEEEE; margin: 5px; }
    blockquote { background: #EEEEEE; margin: 5px; }
    td.quote { background: #EEEEEE; margin: 5px; }
    </style>"
    property string contentHtml: "<html><head><META HTTP-EQUIV=\"Content-Type\" CONTENT=\"text/html; charset=UTF-8\">" +
                                 styleHtml + "</head><body>" + messageBody + "</body>"
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

    WebView { // Causes some trouble, won't wrap text as expected
        id: body
        html: message.contentHtml
        width: mainPage.width
        preferredWidth: width
        anchors.top: toolLine.bottom
        z: 10
        settings.pluginsEnabled: true
        settings.javascriptEnabled: true
        settings.javascriptCanOpenWindows: false
    }
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
