import QtQuick 2.0
import QtWebKit 3.0

Rectangle {
    color: "#e6e6e6"
    width: parent.width
    height: bodyView.height + 100
    radius: 10

    Text {
        id: bodyView
        width: parent.width * 0.98
        color: "black"
        text: modelData.body
        wrapMode: Text.Wrap
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
        anchors.horizontalCenter: parent.horizontalCenter
        textFormat: Text.RichText
        Rectangle {
            color: "white"
            anchors.fill: parent
            z: -10
        }
    }
    /*
//      Can't figure out height of this so it looks sane
    WebView {
        id: bodyView
        width: parent.width
        height: contentHeight
        anchors.bottom: parent.bottom
        Component.onCompleted: loadHtml(modelData.body)
    }
    */
    Text {
        color: "black"
        text: modelData.authorCleaned
    }
}
