import QtQuick 2.0
import "widgets"

SimpleDialog {
    property string errorMessage: ""
    property string threadId
    property string groupId

    Component.onCompleted: {
        siilihaimobile.messagePosted.connect(messagePosted)
    }

    Flickable {
        id: forumSettingsFlickable
        anchors.fill: parent
        contentWidth: width
        contentHeight: contentColumn.height

        Column {
            id: contentColumn
            width: parent.width
            Text {
                height: defaultButtonHeight
                font.pixelSize: headerPixelSize
                text: "Subject:"
                color: color_b_text
            }
            SimpleTextEdit {
                id: subjectEdit
                font.pixelSize: largePixelSize
                text: subject
            }
            Text {
                height: defaultButtonHeight
                font.pixelSize: headerPixelSize
                text: "Message:"
                color: color_b_text
            }
            TextEdit {
                id: bodyEdit
                width: parent.width*0.98
                height: mainItem.height * 0.6
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: "Monospace"
                font.pixelSize: 0
                color: color_input
                textFormat: TextEdit.PlainText
                Rectangle {
                    anchors.fill: parent
                    color: color_input
                    z: -10
                    opacity: 0.5
                }
            }
            Text {
                height: defaultButtonHeight
                font.pixelSize: headerPixelSize
                text: errorMessage
                color: "red"
            }
            Item {
                width: parent.width
                height: defaultButtonHeight
                ConfirmationButton {
                    id: sendButton
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    width: parent.width/3
                    text: "Send"
                    onClicked: {
                        siilihaimobile.postMessage(groupId, threadId, subjectEdit.text, bodyEdit.text)
                        enabled = false
                    }
                }
                SimpleButton {
                    width: parent.width/3
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    text: "Cancel"
                    onClicked: composeMessage.topItem = false
                }
            }
            Item { width: 1; height: mainItem.height/2 }
        }
    }
    function newMessage() {
        subjectEdit.text = ""
        bodyEdit.text = ""
        threadId = groupId = ""
        errorMessage = ""
        sendButton.enabled = true
        composeMessage.topItem = true
    }

    function messagePosted(msg) {
        errorMessage = msg
        sendButton.enabled = true
        if(!msg) topItem = false
    }
}
