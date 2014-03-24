import QtQuick 2.0

Item {
    id: loadingScreen

    Rectangle {
        id: qmlSplashScreen
        anchors.fill: parent
        color: "black"
    }
    Image {
        source: "gfx/siilis3.png"
        anchors.centerIn: parent
        width: parent.width/2
        height: width
        fillMode: Image.PreserveAspectFit
        Text {
            text: "Loading.."
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.bottom
            anchors.topMargin: 10
            color: "white"
        }
    }
    /*
    Loader {
        id: myRealAppLoader
    }
*/
    // Component.onCompleted: myRealAppLoader.source = "main.qml"
}
