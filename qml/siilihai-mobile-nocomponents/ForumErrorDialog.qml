import QtQuick 2.0
import "widgets"

SimpleDialog {
    property bool shown: selectedforum && selectedforum.errors.length
    y: shown ? 0 : parent.height
    Behavior on y { SmoothedAnimation { velocity: 2500; easing.type: Easing.InOutQuad  } }
    ListView {
        width: parent.width*0.9
        height: parent.height
        anchors.centerIn: parent
        model: selectedforum.errors
        spacing: 20
        delegate: Column {
            width: parent.width
            Text {
                width: parent.width
                wrapMode: Text.Wrap
                text: title
                color: "white"
                font.pixelSize: headerPixelSize
            }
            Text {
                width: parent.width
                wrapMode: Text.Wrap
                text: description
                color: "white"
                font.pixelSize: largePixelSize
            }
            Text {
                width: parent.width
                wrapMode: Text.Wrap
                text: technicalData
                color: "white"
                font.pixelSize: smallPixelSize
            }
            Rectangle {
                color: "white"
                width: parent.width * 0.3
                height: 1
                //anchors.bottom: parent.bottom
                //anchors.horizontalCenter: parent.horizontalCenter
                visible: index < parent.count
            }
        }
        footer: Item {
            width: parent.width
            height: 200
            SimpleButton {
                anchors.centerIn: parent
                text: "Ok"
                onClicked: selectedforum.clearErrors()
                Component.onCompleted: mainItem.backPressed.connect(clicked)
            }
        }
    }

    onShownChanged: {
        Qt.inputMethod.hide();
    }
}
