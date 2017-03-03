import QtQuick 2.0
import "widgets"

SimpleDialog {
    topItem: true

    Column {
        y: 50
        spacing: 20
        width: parent.width
        UserPassForm {
            id: upf
            optional: true
            questionText: "Authenticate to " + (siilihaimobile.currentCredentialsRequest ? siilihaimobile.currentCredentialsRequest.forumName : "")
        }
        SimpleCheckBox {
            id: remember
            text: "Remember credentials"
            checked: true
            enabled: upf.checked
        }
        Item { width: 1; height: 20 }

        SimpleButton {
            id: closeButton
            text: "Ok"
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                siilihaimobile.currentCredentialsRequest.username = upf.username
                siilihaimobile.currentCredentialsRequest.password = upf.password
                siilihaimobile.currentCredentialsRequest.signalCredentialsEntered(remember.checked && upf.checked)
                upf.reset()
            }
        }
    }
}
