import QtQuick 1.0
import com.nokia.meego 1.0

Page {
    tools: commonTools
    anchors.fill: parent

    ListView {
        model: parserList
        anchors.fill: parent

        header: Label {
            text: "Subscribe to a forum"
            wrapMode: Text.Wrap
            width: parent.width
        }
        delegate: Row {
            Button {
                text: name
                width: mainPage.width
                onClicked:  {
                    console.log("sub selected " + id)
                    forumCredentialsPage.forumname = name
                    forumCredentialsPage.forumid = id
                    appWindow.pageStack.push(forumCredentialsPage)
                    appWindow.getParserDetails(id)
                }
            }
        }
    }
}
