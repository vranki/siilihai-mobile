import QtQuick 2.0
import "widgets"

SimpleDialog {
    property string errorMessage
    property string threadId
    property string groupId

    Component.onCompleted: {
        siilihaimobile.messagePosted.connect(messagePosted)
    }

    Flickable {
        id: composeFlickable
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
            }
            Text {
                height: defaultButtonHeight
                font.pixelSize: headerPixelSize
                text: "Message:"
                color: color_b_text
            }
            SimpleTextArea {
                id: bodyEdit
            }
            Text {
                width: parent.width
                height: defaultButtonHeight
                font.pixelSize: headerPixelSize
                text: errorMessage
                color: "red"
            }
            //            Item { width: 1; height: defaultButtonHeight }
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
        bodyEdit.reset()
        threadId = groupId = ""
        errorMessage = ""
        sendButton.enabled = true
        composeMessage.topItem = true
        subjectEdit.focus = true
        composeFlickable.contentY = 0
    }

    function messagePosted(msg) {
        errorMessage = msg
        sendButton.enabled = true
        if(!msg) topItem = false
    }

    function setSubject(ns) {
        subjectEdit.text = ns
    }

    function appendBody(nb) {
        bodyEdit.text = bodyEdit.text + "\n" + nb
    }
}
