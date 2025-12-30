import QtQuick 2.0
import Sailfish.Silica 1.0

import "../components"
import "../components/thirdparty"
import "../js/functions.js" as Functions

Page {
    id: menuSelectionPage

//    property int weekOffset: 0
    property string token
    property var menues
//    property var balanceData
//    property var userData
    property string dateLabel
    property bool showLoadingIndicator: false
    property var selectableMenus;
    property string dateString;

//    function populateDaysModel(daysWithMenu) {
//        daysModel.clear()
//        for (var k = 0; k < daysWithMenu.length; k++) {
//            if (k == 0) {
//                daysWithMenu[k].selected = true
//            }
//            daysModel.append(daysWithMenu[k])
//        }
//    }

//    function getMenusForDay(dayIndex, menues) {
//        var result = []
//        if (dayIndex >= menues.data.meinSpeiseplan.length) {
//            console.log("[MenuOrderingPage] - menu not available for index " + dayIndex)
//            return result
//        }
//        var menuDayItem = menues.data.meinSpeiseplan[dayIndex]
//        if (menuDayItem.menues) {
//            var numberOfMenus = (menuDayItem.menues.length)

//            for (var j = 0; j < numberOfMenus; j++) {
//                var menuOfDay = menuDayItem.menues[j]
//                var menuItem = {}
//                menuItem.id = menuOfDay.id
//                menuItem.price = menuOfDay.meinPreis
//                menuItem.ordered = (menuOfDay.meineBestellung !== null)
//                menuItem.menuGroup = "-";

//                if (menuOfDay.menuegruppe) {
//                    menuItem.menuGroup = menuOfDay.menuegruppe.bezeichnung;
//                }

//                menuItem.starterNames = "-";
//                if (menuOfDay.vorspeisen.length > 0) {
//                    menuItem.starterNames = menuOfDay.vorspeisen[0].bezeichnung
//                }

//                menuItem.mainCourseNames = "-";
//                if (menuOfDay.hauptspeisen.length > 0) {
//                    menuItem.mainCourseNames = menuOfDay.hauptspeisen[0].bezeichnung
//                }

//                menuItem.desertNames = "-";
//                if (menuOfDay.nachspeisen.length > 0) {
//                    menuItem.desertNames = menuOfDay.nachspeisen[0].bezeichnung
//                }

//                console.log("[MenuOrderingPage] - menu " + JSON.stringify(
//                                menuItem))
//                result.push(menuItem)
//            }
//        }
//        return result
//    }

    function populateDayMenuModel(menus) {
        menuModel.clear()
        for (var n = 0; n < menus.length; n++) {
            menuModel.append(menus[n])
        }
    }

//    function populateUserName(userData) {
//        var registeredPerson = userData.data.meineDaten.angemeldetePerson
//        menuOrderingPageHeader.title = registeredPerson.vorname + " " + registeredPerson.nachname;
//    }

//    function populateBalanceData(balanceData) {
//        if (balanceData && balanceData.data) {
//            var kontostand = balanceData.data.meinKontostand;
//            var balanceText = kontostand.gesamtKontostandAktuell + " € / " + kontostand.gesamtKontostandZukunft + " €";
//            menuOrderingPageHeader.description = qsTr("Balance %1 € / %2 €")
//                .arg(Functions.formatPrice(kontostand.gesamtKontostandAktuell))
//                .arg(Functions.formatPrice(kontostand.gesamtKontostandZukunft));
//        } else {
//            menuOrderingPageHeader.description = "-";
//        }
//    }

//    function populateWithMenus(menues, dateLabel) {
//        //console.log("get menus result handler : " + result);
//        dateSelectionRow.dateLabel = "" + dateLabel

//        //menues = JSON.parse(result)

//        var daysWithMenu = Functions.getDaysWithMenu(menues)
//        console.log("[MenuOrderingPage] days with menu : " + JSON.stringify(
//                        daysWithMenu))

//        populateDaysModel(daysWithMenu)

////        var days = menues.data.meinSpeiseplan.length
////        console.log("[MenuOrderingPage] : " + days + " days")

// //       const weekday = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]

////        for (var i = 0; i < days; i++) {
////            var menuDayItem = menues.data.meinSpeiseplan[i]
////            if (menuDayItem.menues) {
////                var numberOfMenus = (menuDayItem.menues.length)
////                console.log("[MenuOrderingPage] date : " + menuDayItem.datum
////                            + ", menus : " + numberOfMenus)

////                console.log(weekday[new Date(menuDayItem.datum).getDay()])

////                for (var j = 0; j < numberOfMenus; j++) {
////                    var menuOfDay = menuDayItem.menues[j]
////                    var menuItem = {}
////                    menuItem.id = menuOfDay.id
////                    menuItem.price = menuOfDay.meinPreis
////                    menuItem.menuGroup = "-";

////                    if (menuOfDay.menugruppe) {
////                        menuItem.menuGroup = menuOfDay.menugruppe.bezeichnung;
////                    }

////                    menuItem.starter = "-";
////                    if (menuOfDay.vorspeisen.length > 0) {
////                        menuItem.starter = menuOfDay.vorspeisen[0].bezeichnung
////                    }

////                    if (menuOfDay.hauptspeisen.length > 0) {
////                        menuItem.mainCourse = menuOfDay.hauptspeisen[0].bezeichnung
////                    }
////                    menuItem.desert = "-";
////                    if (menuOfDay.nachspeisen.length > 0) {
////                        menuItem.desert = menuOfDay.nachspeisen[0].bezeichnung
////                    }

////                    console.log("[MenuOrderingPage] - menu " + JSON.stringify(
////                                    menuItem))
////                }
////            }
////        }

//        if (daysWithMenu.length > 0) {
//            var menus = Functions.getMenusForDay(daysWithMenu[0].listIndex, menues)
//            populateDayMenuModel(menus)
//        } else {
//            var emptyMenus = [];
//            populateDayMenuModel(emptyMenus)
//        }


//        // console.log("Menus : " + JSON.stringify(menus))
//        //        menuModel.clear();
//        //        for (var n = 0; n < menus.length; n++) {
//        //            menuModel.append(menus[n]);
//        //        }
//    }

    function errorResultHandler(result) {
        console.log("error result handler")
    }

//    function getMenuWithOffset(offsetChange) {
//        weekOffset += offsetChange
//        mensaMax.executeGetMenus(token, weekOffset)
//    }

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
//        PullDownMenu {
//            MenuItem {
//                //: MenuOrderingPage about menu item
//                text: qsTr("About")
//                onClicked: pageStack.push(Qt.resolvedUrl("AboutPage.qml"))
//            }
//            MenuItem {
//                text: qsTr("Logout")
//                onClicked: pageStack.pop();
//            }
//        }

        Column {
            id: column
            width: parent.width
            // spacing: Theme.paddingMedium
            // y: Theme.paddingLarge

            PageHeader {
                id: menuOrderingPageHeader
                title: qsTr("Food order");
                description: dateString
            }

//            DateSelectionRow {
//                id: dateSelectionRow
//                width: parent.width - (2 * Theme.paddingMedium)
//                x: Theme.paddingMedium
//                dateLabel: ""
//                visible: false
//            }

//            ViewPlaceholder {
//                enabled: menuModel.count === 0;
//                text: qsTr("No lunch available for selection.")
//            }

//            Row {
//                id: daySelectionRow
//                width: parent.width - (2 * Theme.paddingMedium)
//                spacing: Theme.paddingMedium
//                x: Theme.paddingMedium

//                Repeater {
//                    id: dayRepeater

//                    model: ListModel {
//                        id: daysModel
//                    }

//                    delegate: Button {
//                        id: buttonDelegate
//                        text: weekdayName
//                        width: (parent.width + 2 * Theme.paddingSmall
//                                - (2 * Theme.paddingSmall) * daysModel.count) / daysModel.count
//                        //height: 40
//                        backgroundColor: selected ? Theme.highlightBackgroundColor : Theme.backgroundGlowColor
//                        onClicked: {
//                            console.log(weekdayName + " clicked " + index + " - ")

//                            for (var i = 0; i < daysModel.count; i++) {
//                                daysModel.get(i).selected = false
//                            }

//                            daysModel.get(index).selected = true

//                            var menus = Functions.getMenusForDay(model.listIndex, menues)
//                            console.log("Menus : " + JSON.stringify(menus))
//                            populateDayMenuModel(menus)
//                        }
//                    }
//                }

//                Component.onCompleted: {
//                    console.log("selecting first element")
//                    // daysModel.get(0).selected = true
//                }
//            }

            SilicaListView {
                id: foodListView

                anchors.left: parent.left
                anchors.right: parent.right

                height: menuSelectionPage.height - menuOrderingPageHeader.height
                //                        - incidentsHeader.height
                //                        - Theme.paddingMedium
                //                                width: parent.width
                //                                anchors.left: parent.left
                //                                anchors.right: parent.right
                clip: true

                model: ListModel {
                    id: menuModel
                }

                delegate: ListItem {
                    id: menuDelegate

                    contentHeight: menuItem.height + (2 * Theme.paddingSmall)
                    contentWidth: parent.width

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

                    onClicked: {
                        console.log("[MenuOrderingPage] index: " + index + ", menu id : " + model.id)
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

//    Connections {
//        target: mensaMax

//        onGetMenusAvailable: {
//            if (menuSelectionPage.status !== PageStatus.Active) {
//                return;
//            }
//            console.log("[MenuOrderingPage] - getMenusAvailable " + reply);
//            menues = JSON.parse(reply);
//            populateWithMenus(menues, dateLabel);
//            showLoadingIndicator = false
//        }

//        onRequestError: {
//            console.log("[MenuOrderingPage] - requestError " + errorMessage)
//            showLoadingIndicator = false
//            menuProblemNotification.show(errorMessage)
//        }
//    }

//    Connections {
//        target: dateSelectionRow

//        onNextWeekClicked: {
//            console.log("[MenuOrderingPage] - next week");
//            showLoadingIndicator = true
//            getMenuWithOffset(offsetChange);
//        }

//        onPreviousWeekClicked: {
//            console.log("[MenuOrderingPage] - previous week");
//            showLoadingIndicator = true
//            getMenuWithOffset(offsetChange);
//        }
//    }

    Component.onCompleted: {
        console.log("[MenuSelectionPage] init");
        console.log("[MenuSelectionPage] selectable menus : " + selectableMenus);
        populateDayMenuModel(selectableMenus)
//        populateWithMenus(menues, dateLabel);
//        populateUserName(userData);
//        populateBalanceData(balanceData);
    }

}
