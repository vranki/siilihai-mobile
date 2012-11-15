import QtQuick 1.0
import com.nokia.meego 1.0

Page {
    tools: commonTools
    anchors.fill: parent
    property int selectionMode: 0 // 0=nothing 1=url 2=list

    ListView {
        model: forumList
        anchors.fill: parent
        id: forumListView
        header: Column {
            Label {
                text: "Subscribe to a forum"
                wrapMode: Text.Wrap
                width: subscribeWizardPage.width
            }
            Button {
                text: "Enter URL"
                visible: selectionMode == 0
                onClicked: selectionMode = 1
            }
            Button {
                text: "Select from list"
                visible: selectionMode == 0
                onClicked: selectionMode = 2
            }
            TextEdit {
                id: urlInput
                visible: selectionMode == 1
                width: parent.width
                wrapMode: TextEdit.WrapAnywhere
                text: "http://"
//                inputMask: "\http://XXX"
            }
            Button {
                text: "Continue"
                visible: selectionMode == 1
                onClicked: {
                    forumCredentialsPage.forumname = "Getting forum.."
                    forumCredentialsPage.forumid = 0
                    appWindow.pageStack.push(forumCredentialsPage)
                    appWindow.getForumUrlDetails(urlInput.text);
                }
            }
        }
        delegate: Column {
            visible: selectionMode == 2
            Button {
                text: alias
                width: subscribeWizardPage.width
                onClicked:  {
                    forumCredentialsPage.forumname = alias
                    forumCredentialsPage.forumid = forumId
                    appWindow.pageStack.push(forumCredentialsPage)
                    appWindow.getForumDetails(forumId)
                }
            }
        }
    }
}
