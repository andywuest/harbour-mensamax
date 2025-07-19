import QtQuick 2.0
import Sailfish.Silica 1.0

Item {
            id: foodMenuItem

            property bool isUnread: true;
            property string starter: ""
            property string mainCourse: ""
            property string dessert: ""

            width: precalculatedValues.textItemWidth
            height: messageBackground.height

            Rectangle {
                id: messageBackground


//                anchors {
//                    left: parent.left
//                    leftMargin: messageListItem.isOwnMessage ? precalculatedValues.pageMarginDouble : 0
//                    verticalCenter: parent.verticalCenter
//                }
                height: lunchTextColumn.height
                    //messageTextColumn.height + precalculatedValues.paddingMediumDouble
                width: parent.width
                // precalculatedValues.backgroundWidth
                // property bool isUnread: messageIndex > chatModel.getLastReadMessageIndex() && myMessage['@type'] !== "sponsoredMessage"
                color: Theme.colorScheme === Theme.LightOnDark ? (isUnread ? Theme.secondaryHighlightColor : Theme.secondaryColor) : (isUnread ? Theme.backgroundGlowColor : Theme.overlayBackgroundColor)
                radius: parent.width / 50
                opacity: isUnread ? 0.5 : 0.2
                visible: true



                    // appSettings.showStickersAsImages || (myMessage.content['@type'] !== "messageSticker" && myMessage.content['@type'] !== "messageAnimatedEmoji")
//                Behavior on color { ColorAnimation { duration: 200 } }
//                Behavior on opacity { FadeAnimation {} }
            }

            Column {
                            id: lunchTextColumn

                            spacing: Theme.paddingSmall

                            width: parent.width
                            anchors.centerIn: messageBackground

                            Label {
                                topPadding: Theme.paddingSmall
                                leftPadding: Theme.paddingSmall
                                rightPadding: Theme.paddingSmall
                                width: parent.width
                                text: qsTr("Vorspeise: ") + starter
                                textFormat: Text.StyledText
                                wrapMode: Text.Wrap
                                horizontalAlignment: Text.AlignLeft
                                color: Theme.primaryColor
                                font.pixelSize: Theme.fontSizeExtraSmall
                                font.bold: false
                            }

                            Label {
                                // topPadding: Theme.paddingSmall
                                leftPadding: Theme.paddingSmall
                                rightPadding: Theme.paddingSmall
                                width: parent.width
                                text: qsTr("Hauptspeise: ") + mainCourse
                                textFormat: Text.StyledText
                                wrapMode: Text.Wrap
                                horizontalAlignment: Text.AlignLeft
                                color: Theme.primaryColor
                                font.pixelSize: Theme.fontSizeExtraSmall
                                font.bold: true
                            }

                            Label {
                                // topPadding: Theme.paddingSmall
                                leftPadding: Theme.paddingSmall
                                rightPadding: Theme.paddingSmall
                                bottomPadding: Theme.paddingSmall
                                width: parent.width
                                text: qsTr("Nachtisch: ") + dessert
                                textFormat: Text.StyledText
                                wrapMode: Text.Wrap
                                horizontalAlignment: Text.AlignLeft
                                color: Theme.primaryColor
                                font.pixelSize: Theme.fontSizeExtraSmall
                                font.bold: false
                            }


            }

//                            Label {
//                                id: userText

//                                width: parent.width
//                                text: messageListItem.isOwnMessage
//                                      ? qsTr("You")
//                                      : Emoji.emojify( myMessage['@type'] === "sponsoredMessage"
//                                                      ? tdLibWrapper.getChat(myMessage.sponsor_chat_id).title
//                                                      : ( messageListItem.isAnonymous
//                                                            ? page.chatInformation.title
//                                                            : Functions.getUserName(messageListItem.userInformation) ), font.pixelSize)
//                                font.pixelSize: Theme.fontSizeExtraSmall
//                                font.weight: Font.ExtraBold
//                                color: messageListItem.textColor
//                                maximumLineCount: 1
//                                truncationMode: TruncationMode.Fade
//                                textFormat: Text.StyledText
//                                horizontalAlignment: messageListItem.textAlign
//                                visible: precalculatedValues.showUserInfo || myMessage['@type'] === "sponsoredMessage"
//                                MouseArea {
//                                    anchors.fill: parent
//                                    enabled: !(messageListItem.precalculatedValues.pageIsSelecting || messageListItem.isAnonymous)
//                                    onClicked: {
//                                        tdLibWrapper.createPrivateChat(messageListItem.userInformation.id, "openDirectly");
//                                    }
//                                }
//                            }
//                }



}
