// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    tools: commonTools
    anchors.fill: parent

    Column {
        spacing: 30
        anchors.centerIn: parent
        Label {
            text: "Note: Some features such as synchronizing are not possible without an account."
            wrapMode: Text.Wrap
            width: parent.width
        }
        Button {
            text: "Continue"
            onClicked: {
                appWindow.registerUser('', '', '', false)
                appWindow.pageStack.pop(mainPage);
            }
        }
    }
}
