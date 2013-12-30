import QtQuick 2.0
import "widgets"

SimpleDialog {
    objectName: "credentialsDialog"
    property string forumAlias: ""

    Column {
        y: 50
        spacing: 20
        width: parent.width
        UserPassForm {
            id: upf
            optional: true
            questionText: "Authenticate to " + forumAlias
        }
        SimpleCheckBox {
            id: remember
            text: "Remember credentials"
            checked: true
            enabled: upf.checked
        }
    }
    SimpleButton {
        id: closeButton
        text: "Ok"
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: {
            topItem = false
            forumAlias = ""
            siilihaimobile.credentialsEntered(upf.username, upf.password, remember.checked && upf.checked)
            upf.reset()
        }
        Component.onCompleted: mainItem.backPressed.connect(clicked)
    }
}
