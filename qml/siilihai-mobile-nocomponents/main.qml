import QtQuick 2.0
import "forum"
import "account"

Item {
    id: mainItem
    property string color1: "#7d7dc0"
    property string color2: "#ffd884"
    property string colorDark: "#003e5e"
    property string colorLessDark: "#407e9e"

    property string color_a_bg: "white"
    property string color_a_text: "black"
    property string color_a_buttons: "#f7f7f7"
    property string color_a_buttons_pressed: "#888888"
    property string color_b_bg: "black"
    property string color_b_text: "white"

    property string color_input: "yellow"

    property int largerDimension: Math.max(width, height)
    property int headerPixelSize: largerDimension / 25
    property int largePixelSize: largerDimension / 50
    property int smallPixelSize: largerDimension / 66

    property int smallButtonHeight: largerDimension / 25
    property int defaultButtonHeight: largerDimension / 16
    property int tallButtonHeight: largerDimension / 13

    property int buttonAnimationDuration: 500

    signal backPressed

    Image {
        source: "gfx/backbround-dark.png"
        fillMode: Image.Tile
        width: parent.width
        height: parent.height*2 + forumListView.height
        y: -parent.height - forumListView.contentY
    }
    ForumListView {
        id: forumListView
        // property bool topItem: !threadListView.topItem && !messageListView.topItem
        width: parent.width * 0.98
        height: parent.height// - toolbar.height
        anchors.horizontalCenter: parent.horizontalCenter
        HideEffect {}
    }
    Loader {
        id: threadListView
        property var selectedGroup
        property var model: selectedGroup ? selectedGroup.threads : undefined
        source: "ThreadListView.qml"
        width: parent.width
        height: parent.height
        active: false
    }
    Loader {
        id: messageListView
        property var selectedThread
        property var model: selectedThread ? selectedThread.messages : undefined
        source: "MessageListView.qml"
        width: parent.width
        height: parent.height
        active: false
    }

    Loader {
        id: subscribeForumDialog
        source: "forum/SubscribeForumDialog.qml"
        width: parent.width
        height: parent.height
        active: forumList
    }

    /*
    LoginWizard {
        id: loginWizard
        width: parent.width
        height: parent.height
    }

    ForumSettingsDialog {
        id: forumSettingsDialog
    }
    */


    Toolbar {
        id: toolbar
        anchors.bottom: parent.bottom
    }

    Loader { // Load on demand
        id: settingsLoader
        source: "SettingsDialog.qml"
        active: false
        width: parent.width
        height: parent.height
    }
    /*
    ComposeMessage {
        id: composeMessage
    }

    CredentialsDialog { id: credentialsDialog }
    ForumErrorDialog { id: forumErrorDialog }
    MessageDialog { id: messageDialog }
    */
    InactiveScreen {}

    // Hide the virtual keyboard if it is open
    function hideVkb() {
        console.log("Hide the damn VKB")
        Qt.inputMethod.hide();
    }

    // Android back button handling
    focus: true // important - otherwise we'll get no key events

    Keys.onReleased: {
        // Handle android back button. Quit if in main view, otherwise press back
        if (event.key === Qt.Key_Back && !mainViewVisible && !loginWizard.topItem) {
            event.accepted = true
            backPressed()
        }
    }
}
