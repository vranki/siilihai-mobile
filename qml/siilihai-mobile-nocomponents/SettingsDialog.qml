import QtQuick 2.0
import "widgets"

SimpleDialog {
    onTopItemChanged: {
        if(!topItem) return
        signature.text = siilihaisettings.signature
    }

    Flickable {
        id: composeFlickable
        anchors.fill: parent
        contentWidth: width
        contentHeight: contentColumn.height

        Column {
            id: contentColumn
            width: parent.width
            spacing: 10
            Text {
                text: "Download limits"
                color: color_b_text
                font.pixelSize: headerPixelSize
            }
            ValueAdjustmet {
                id: tpg
                text: "Threads per group"
                value: siilihaisettings.threadsPerGroup
                valueMin: 5
                valueMax: siilihaisettings.maxThreadsPerGroup()
            }
            ValueAdjustmet {
                id: mpt
                text: "Messages per thread"
                value: siilihaisettings.messagesPerThread
                valueMin: 5
                valueMax: siilihaisettings.maxMessagesPerThread()
            }
            ValueAdjustmet {
                id: smc
                text: "Show more count"
                value: siilihaisettings.showMoreCount
                valueMin: 5
                valueMax: siilihaisettings.maxMessagesPerThread()
            }
            Text {
                text: "Account"
                color: color_b_text
                font.pixelSize: headerPixelSize
            }
            Text {
                text: siilihaisettings.noAccount ? "No account used" : "Username: " + siilihaisettings.username
                anchors.horizontalCenter: parent.horizontalCenter
                color: color_b_text
                font.pixelSize: largePixelSize
            }
            SimpleCheckBox {
                id: sync
                text: "Synchronize messages"
                checked: siilihaisettings.syncEnabled
                enabled: !siilihaisettings.noAccount
            }
            ConfirmationButton {
                text: "Unregister this copy of Siilihai"
                onClicked: siilihaimobile.unregisterSiilihai()
                anchors.horizontalCenter: parent.horizontalCenter
            }
            SimpleCheckBox {
                text: "Developer mode"
                checked: siilihaimobile.developerMode
                onCheckedChanged: siilihaimobile.developerMode = checked
            }
            Text {
                text: "Signature"
                color: color_b_text
                font.pixelSize: headerPixelSize
            }
            SimpleTextArea {
                id: signature
            }
            Item {
                width: 1
                height: mainItem.height/8
            }
            SimpleButton {
                text: "Close"
                anchors.horizontalCenter: parent.horizontalCenter
                Component.onCompleted: mainItem.backPressed.connect(clicked)
                onClicked: {
                    topItem = false
                    siilihaisettings.threadsPerGroup = tpg.value
                    siilihaisettings.messagesPerThread = mpt.value
                    siilihaisettings.showMoreCount = smc.value
                    siilihaisettings.syncEnabled = sync.checked
                    siilihaisettings.signature = signature.text
                    siilihaimobile.settingsChanged(true)
                }
            }
            Item {
                width: 1
                height: mainItem.height/2
            }
        }
    }
}
