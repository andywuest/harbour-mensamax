import QtQuick 2.0
import Sailfish.Silica 1.0

import "../components"
import "../components/thirdparty"
import "../js/functions.js" as Functions

Page {
    id: menuSelectionPage

    property string token
    property bool showLoadingIndicator: false
    property var selectableMenus;
    property string dateString;
    signal menuSubscriptionChanged(int lunchId, bool menuSubscribed)

    function populateDayMenuModel(menus) {
        menuModel.clear()
        for (var n = 0; n < menus.length; n++) {
            menuModel.append(menus[n])
        }
    }

    function updateMenuSubscriptionState(menus, lunchId, ordered) {
        for (var n = 0; n < menus.length; n++) {
            if (menus[n].id === lunchId) {
                console.log("[MenuSelectionPage] .updateMenuSubscriptionState : updating ordered state for lunchId " + lunchId +
                            " to ordered = " + ordered);
                menus[n].ordered = ordered;
                menuModel.append(menus[n])
            }
        }
    }

    function errorResultHandler(result) {
        console.log("error result handler")
    }

    AppNotification {
        id: menuProblemNotification
    }

    SilicaFlickable {
        id: pageFlickable
        width: parent.width
        // height: parent.height
        contentHeight: column.height
        anchors.fill: parent

        Column {
            id: column
            width: parent.width

            PageHeader {
                id: menuSelectionPageHeader
                title: qsTr("Food order");
                description: dateString
            }

            SilicaListView {
                id: foodListView

                anchors.left: parent.left
                anchors.right: parent.right

                height: menuSelectionPage.height - menuSelectionPageHeader.height
                clip: true

                model: ListModel {
                    id: menuModel
                }

                delegate: ListItem {
                    id: menuDelegate

                    contentHeight: menuItem.height + (2 * Theme.paddingSmall)
                    contentWidth: parent.width

                    menu: ContextMenu {
                        MenuItem {
                            //: MenuSelectionPage remove lunch subscription item
                            text: (menuModel.get(index) && menuModel.get(index).ordered) ? qsTr("Unsubscribe Meal") : qsTr("Subscribe Meal")
                            onClicked: {
                                var tmpModel = menuModel.get(index);
                                if (tmpModel.ordered) {
                                    console.log("[MenuSelectionPage] removing subscription for meal with id : " + tmpModel.id);
                                    mensaMax.executeUnsubscribeMeal(token, model.id);
                                } else {
                                    console.log("[MenuSelectionPage] subscribe to meal with id : " + tmpModel.id);
                                    mensaMax.executeSubscribeMeal(token, model.id);
                                }
                            }
                        }
                    }

                    Item {
                        id: menuItem
                        height: foodMenuItem.height
                        width: parent.width - (2 * Theme.paddingMedium)
                        x: Theme.paddingMedium
                        y: Theme.paddingSmall

                        FoodMenuItem {
                            id: foodMenuItem
                            width: parent.width
                            starter: starterNames
                            mainCourse: mainCourseNames
                            desert: desertNames
                        }
                    }
                }
            }
        }
    }

    LoadingIndicator {
        visible: showLoadingIndicator
        Behavior on opacity {
            NumberAnimation {}
        }
        opacity: showLoadingIndicator ? 1 : 0
        height: parent.height
        width: parent.width
    }

    Connections {
        target: mensaMax

        onUnsubscribeMealAvailable: {
            console.log("[MenuSelectionPage] - unsubscribeMealAvailable " + reply);
            var result = JSON.parse(reply);
            if (result.success) {
                updateMenuSubscriptionState(selectableMenus, result.lunchId, false)
                menuSubscriptionChanged(result.lunchId, false);
                populateDayMenuModel(selectableMenus)
            } else {
                menuProblemNotification.show(result.message);
            }
            showLoadingIndicator = false
        }

        onSubscribeMealAvailable: {
            console.log("[MenuSelectionPage] - subscribeMealAvailable " + reply);
            var result = JSON.parse(reply);
            if (result.success) {
                updateMenuSubscriptionState(selectableMenus, result.lunchId, true)
                menuSubscriptionChanged(result.lunchId, true);
                populateDayMenuModel(selectableMenus)
            } else {
                menuProblemNotification.show(result.message);
            }
            showLoadingIndicator = false
        }

        onRequestError: {
            console.log("[MenuSelectionPage] - requestError " + errorMessage)
            showLoadingIndicator = false
            menuProblemNotification.show(errorMessage)
        }
    }

    Component.onCompleted: {
        console.log("[MenuSelectionPage] init");
        console.log("[MenuSelectionPage] selectable menus : " + selectableMenus);
        populateDayMenuModel(selectableMenus)
    }

}
