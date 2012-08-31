import QtQuick 1.0
import com.nokia.meego 1.0

Page {
    tools: commonTools
    anchors.fill: parent

    ListView {
        model: parserList
        anchors.fill: parent

        header: Text {
            id: text
            text: "Subscribe to forum"
            wrapMode: Text.Wrap
            color: "white"
        }

        delegate: Row {
            Button {
                text: id + ": " + name
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
