import QtQuick 2.2
import Sailfish.Silica 1.0

import "../components"
import "../components/thirdparty"
import "../js/functions.js" as Functions

// TODO problem: wenn mehrere essen bestellt werden, geht die information einer
// bestellung hier in der liste verloren - jeweils nur die letzt aktion wird korrekt
// in der liste angezeigt -> liste der änderungen speichern und immer wieder auf der
// geladenen liste ausfuehren (replay)

Page {
    id: menuSelectionPage

    backNavigation: false

    // property int weekOffset: 0
    property string token
    property var menues // array[weekOffset] -> data
    property var balanceData
    property var userData
    // property string dateLabel
    property bool showLoadingIndicator: false
    property var selectableMenusPerDay: [] // array with one entry per day - contains list of selectable menus

    function populateDayMenuModel(menus) {
        var menuSelected = false;
        // add orderd food
        for (var n = 0; n < menus.length; n++) {
            if (menus[n].ordered === true) {
                menuSelected = true;
                menus[n].hasSelectableMenu = true;
                globalMenuModel.append(menus[n])
            }
        }

        // no food ordered, add dummy entry
        if (menuSelected === false) {
            var menuItem = {};
            menuItem.id = -1
            // menuItem.price =
            menuItem.ordered = false
            menuItem.menuGroup = "-";
            menuItem.week = menus[0].week;

            menuItem.menuGroup = "";
            menuItem.starterNames = "";
            menuItem.desertNames = "";
            menuItem.dateString = menus[0].dateString;

            // holiday and vacations have special markers, we check them here
            if (menus[0].starterNames === "SCHULFERIEN"
                    || menus[0].starterNames === "FEIERTAG") {
                menuItem.mainCourseNames = menus[0].starterNames;
                menuItem.hasSelectableMenu = false;
            } else {
                menuItem.mainCourseNames = "No food ordered";
                menuItem.hasSelectableMenu = true;
            }

            globalMenuModel.append(menuItem)

            console.log("[MenuListPage] .populateDayMenuModel - menuitems: " + selectableMenusPerDay.length)
        }

        selectableMenusPerDay.push(menus);
    }

    function populateUserName(userData) {
        var registeredPerson = userData.data.meineDaten.angemeldetePerson
        menuListPageHeader.title = registeredPerson.vorname + " " + registeredPerson.nachname;
    }

    function populateBalanceData(balanceData) {
        if (balanceData && balanceData.data) {
            var kontostand = balanceData.data.meinKontostand;
            var balanceText = kontostand.gesamtKontostandAktuell + " € / " + kontostand.gesamtKontostandZukunft + " €";
            menuListPageHeader.description = qsTr("Balance %1 € / %2 €")
                .arg(Functions.formatPrice(kontostand.gesamtKontostandAktuell))
                .arg(Functions.formatPrice(kontostand.gesamtKontostandZukunft));
        } else {
            menuListPageHeader.description = "-";
        }
    }

    function populateWithMenus(menues, lunchId, ordered) {
        globalMenuModel.clear();
        selectableMenusPerDay = [];

        var weekStart = (0 - mensamaxSettings.periodStart)
        var weekEnd = weekStart + mensamaxSettings.numberOfWeeksToLoad

        // daysWithMenu list of day for which a menu can be selected
        for (var m = weekStart; m < weekEnd; m++) { // iterate over week
            var daysWithMenu = Functions.getDaysWithMenu(menues[m])
            console.log("[MenuListPage] days with menu : " + JSON.stringify(
                            daysWithMenu))

            if (daysWithMenu.length > 0) {
                for (var i = 0; i < daysWithMenu.length; i++) { // iterate over days with menu
                    var calendarWeekPrefix = qsTr("CW") + " ";
                    var menus = Functions.getMenusForDay(daysWithMenu[i].listIndex, menues[m], calendarWeekPrefix)
                    if (lunchId) {
                        for (var n = 0; n < menus.length; n++) {
                            if (menus[n].id === lunchId) {
                                console.log("[MenuListPage] .populateWithMenus: lunchId ordered state modification for " + lunchId);
                                menus[n].ordered = ordered;
                            }
                        }
                    }
                    populateDayMenuModel(menus)
                }
            }
        }
    }

    function updateMenuSubscription(lunchId, menuSubscribed) {
        console.log("[MenuListPage] .updateMenuUnsubscribed: lunch with id " + lunchId + " subscribed: " + menuSubscribed);
        populateWithMenus(menues, lunchId, menuSubscribed)
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

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                //: MenuListPage about menu item
                text: qsTr("About")
                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
            }
            MenuItem {
                text: qsTr("Logout")
                onClicked: pageStack.pop();
            }
        }

        Column {
            id: column
            width: parent.width
            spacing: Theme.paddingMedium

            PageHeader {
                id: menuListPageHeader
            }

            SilicaListView {
                id: menuListView
                visible: true

                anchors.left: parent.left
                anchors.right: parent.right

                height: menuSelectionPage.height - menuListPageHeader.height
                clip: true

                model: ListModel {
                    id: globalMenuModel
                }

                section {
                    property: "week"
                    criteria: ViewSection.FullString
                    delegate: SectionHeader {
                        text: section
                    }
                }

                delegate: MenuListItem {
                    id: menuListItemDelegate

                    onClicked: {
                        console.log("[MenuListPage] index: " + index + ", date: " + model.dateString)
                        var selectableMenus = selectableMenusPerDay[index];
                        var dateString = model.dateString;

                        if (model.hasSelectableMenu) {
                            var menuSelectionPage = pageStack.push(
                                        Qt.resolvedUrl(
                                            "MenuSelectionPage.qml"),
                                            {
                                                "selectableMenus": selectableMenus,
                                                "dateString": dateString,
                                                "token": token

                                            });
                            menuSelectionPage.menuSubscriptionChanged.connect(updateMenuSubscription);
                        }
                    }
                }

                VerticalScrollDecorator {}

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

        // TODO brauchen wir das hier ueberhaupt
        onGetMenusAvailable: {
            if (menuSelectionPage.status !== PageStatus.Active) {
                return;
            }
            console.log("[MenuListPage] - getMenusAvailable " + reply);
            //menues = JSON.parse(reply);
            //populateWithMenus(menues, dateLabel);
            showLoadingIndicator = false
        }

        onRequestError: {
            console.log("[MenuListPage] - requestError " + errorMessage)
            showLoadingIndicator = false
            menuProblemNotification.show(errorMessage)
        }
    }

    Component.onCompleted: {
        console.log("[MenuListPage] init");
        populateWithMenus(menues/*, dateLabel*/);
        populateUserName(userData);
        populateBalanceData(balanceData);
    }

}
