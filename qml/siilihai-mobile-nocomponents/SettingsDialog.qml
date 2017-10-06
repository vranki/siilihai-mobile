import QtQuick 2.0
import "widgets"

SimpleDialog {
    id: settingsDialog
    topItem: true
    Component.onCompleted: signature.text = siilihai.settings.signature

    onTopItemChanged: {
        if(!topItem) {
            siilihai.settings.threadsPerGroup = tpg.value
            siilihai.settings.messagesPerThread = mpt.value
            siilihai.settings.showMoreCount = smc.value
            siilihai.settings.syncEnabled = sync.checked
            siilihai.settings.signature = signature.text
            siilihai.settingsChanged(true)
        }
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
                value: siilihai.settings.threadsPerGroup
                valueMin: 5
                valueMax: siilihai.settings.maxThreadsPerGroup()
            }
            ValueAdjustmet {
                id: mpt
                text: "Messages per thread"
                value: siilihai.settings.messagesPerThread
                valueMin: 5
                valueMax: siilihai.settings.maxMessagesPerThread()
            }
            ValueAdjustmet {
                id: smc
                text: "Show more count"
                value: siilihai.settings.showMoreCount
                valueMin: 5
                valueMax: siilihai.settings.maxMessagesPerThread()
            }
            Text {
                text: "Account"
                color: color_b_text
                font.pixelSize: headerPixelSize
            }
            Text {
                text: siilihai.settings.noAccount ? "No account used" : "Username: " + siilihai.settings.username
                anchors.horizontalCenter: parent.horizontalCenter
                color: color_b_text
                font.pixelSize: largePixelSize
            }
            SimpleCheckBox {
                id: sync
                text: "Synchronize messages"
                checked: siilihai.settings.syncEnabled
                enabled: !siilihai.settings.noAccount
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
                height: mainItem.height * 0.2
            }
            Item {
                width: 1
                height: mainItem.height/2
            }
        }
    }
}
