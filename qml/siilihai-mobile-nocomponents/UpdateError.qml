import QtQuick 2.0

Column {
    width: parent.width
    Text {
        width: parent.width
        text: modelData.title
        wrapMode: Text.Wrap
        font.pixelSize: largePixelSize
        color: color_b_text
    }
    Text {
        width: parent.width
        text: modelData.description
        wrapMode: Text.Wrap
        font.pixelSize: smallPixelSize
        color: color_b_text
    }
}
