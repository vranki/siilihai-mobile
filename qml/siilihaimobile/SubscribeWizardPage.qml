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
        }

        delegate: Row {
            Button {
                text: id + ": " + name
                width: mainPage.width
                    onClicked:  {
                        appWindow.subscribeForum(id, name)
                        appWindow.pageStack.pop()
                        console.log("sub selected " + id)
                    }
            }
        }
    }
}
