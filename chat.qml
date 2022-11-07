import QtQuick 2.6
import QtQuick.Layouts 2.6
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Controls.Material 2.15
import QtQml 2.6
import ChatModel 1.0


// ApplicationWindow{
//     title: ("Messenger")
//     width: 640
//     height: 960
//     visible: true

//     Text{
//         text:"Hello world"
//     }

// }

ApplicationWindow {
    id: window
    title: ("Messenger")
    width: 640
    height: 960
    visible: true

    property string chat: "";

    SqlConversationModel {
        id: chat_model
    }
    ColumnLayout {
        anchors.fill: parent
        // anchors.right : parent.right
        // anchors.left : parent.left

        ListView {
            id: listView
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: pane.leftPadding + messageField.leftPadding
            displayMarginBeginning: 40
            displayMarginEnd: 40
            verticalLayoutDirection: ListView.BottomToTop
            spacing: 12
            model: chat_model
            delegate: Column {
                anchors.right: sentByMe ? listView.contentItem.right : undefined
                spacing: 6

                readonly property bool sentByMe: model.recipient !== "Me"
                Row {
                    id: messageRow
                    spacing: 6
                    anchors.right: sentByMe ? parent.right : undefined

                    Rectangle {
                        width: Math.min(messageText.implicitWidth + 24,
                            listView.width - (!sentByMe ? messageRow.spacing : 0))
                        height: messageText.implicitHeight + 24
                        radius: 15
                        color: sentByMe ? "lightgrey" : "steelblue"

                        Label {
                            id: messageText
                            text: model.message
                            color: sentByMe ? "black" : "white"
                            anchors.fill: parent
                            anchors.margins: 12
                            wrapMode: Label.Wrap
                        }
                    }
                }

                Label {
                    id: timestampText
                    text: Qt.formatDateTime(model.timestamp, "d MMM hh:mm")
                    color: "lightgrey"
                    anchors.right: sentByMe ? parent.right : undefined
                }
            }
            ScrollBar.vertical: ScrollBar {}
        }
        
        
// Pane is a rectangle whose color comes from application's style and has no stroke on border
        Pane {
            id: pane
            Layout.fillWidth: true

            RowLayout {
                width: parent.width

                TextArea {
                    id: messageField
                    Layout.fillWidth: true
                    placeholderText: ("Write a message")
                    wrapMode: TextArea.Wrap
                }

                Button {
                    id: sendButton
                    text: ("Send message")
                    enabled: messageField.length > 0
                    onClicked: {
                        console.log(messageField.text)
                        chat=messageField.text
                        console.log(chat)
                        listView.model.send_message("machine", messageField.text, "Me");
                        messageField.text = "";
                    }
                }
            }
        }
    }
}