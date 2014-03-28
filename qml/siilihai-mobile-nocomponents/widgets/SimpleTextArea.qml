import QtQuick 2.0

Rectangle {
    property alias text: bodyEdit.text
    width: mainItem.width*0.98
    height: mainItem.height * 0.4
    anchors.horizontalCenter: parent.horizontalCenter
    color: color_input
    z: -10
    opacity: 0.5

    function reset() {
        text = ""
        flick.contentY = 0
    }

    Flickable {
        id: flick
        clip: true
        anchors.fill: parent
        contentWidth: bodyEdit.width
        contentHeight: bodyEdit.height
        flickableDirection: Flickable.VerticalFlick

        function ensureVisible(r) {
            if (contentX >= r.x)
                contentX = r.x;
            else if (contentX+width <= r.x+r.width)
                contentX = r.x+r.width-width;
            if (contentY >= r.y)
                contentY = r.y;
            else if (contentY+height <= r.y+r.height)
                contentY = r.y+r.height-height;
        }

        TextEdit {
            id: bodyEdit
            width: flick.width
            wrapMode: TextEdit.Wrap
            onCursorRectangleChanged: flick.ensureVisible(cursorRectangle)
            font.family: "Monospace"
            font.pixelSize: largePixelSize
            color: color_input
            textFormat: TextEdit.PlainText
        }
    }
}
