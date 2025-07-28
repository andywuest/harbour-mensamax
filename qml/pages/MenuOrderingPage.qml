import QtQuick 2.0
import Sailfish.Silica 1.0

import "../components"

Page {
    id: menuSelectionPage

    backNavigation: false

    property int weekOffset: 0
    property string token
    property var menues
    property string dateLabel

//    function connectSlots() {
//        console.log("connect - slots")
//        mensaMax.loginAvailable.connect(loginResultHandler)
//        mensaMax.getBalanceAvailable.connect(getBalanceResultHandler)
//        mensaMax.getUserDataAvailable.connect(getUserDataResultHandler)
//        mensaMax.getMenusAvailable.connect(getMenusResultHandler)
//        mensaMax.requestError.connect(errorResultHandler)
//        dateSelectionRow.nextWeekClicked.connect(getMenuWithOffset)
//        dateSelectionRow.previousWeekClicked.connect(getMenuWithOffset)
//    }

//    function disconnectSlots() {
//        console.log("disconnect - slots")
//        mensaMax.loginAvailable.disconnect(loginResultHandler)
//        mensaMax.getBalanceAvailable.disconnect(getBalanceResultHandler)
//        mensaMax.getUserDataAvailable.disconnect(getUserDataResultHandler)
//        mensaMax.getMenusAvailable.disconnect(getMenusResultHandler)
//        mensaMax.requestError.disconnect(errorResultHandler)
//        dateSelectionRow.nextWeekClicked.disconnect(getMenuWithOffset)
//        dateSelectionRow.previousWeekClicked.disconnect(getMenuWithOffset)
//    }

    function loginResultHandler(result) {
        console.log("login result handler : " + result)
        var parsedResult = JSON.parse(result)
        token = parsedResult.text
    }

    function getBalanceResultHandler(result) {
        console.log("get balance result handler : " + result)
    }

    function getUserDataResultHandler(result) {
        console.log("get user data result handler : " + result)
    }

    function getDaysWithMenu(menues) {
        //var menues = JSON.parse(menuResponse)
        var result = []
        const weekday = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
        var days = menues.data.meinSpeiseplan.length
        for (var i = 0; i < days; i++) {
            var menuDayItem = menues.data.meinSpeiseplan[i]
            if (menuDayItem.menues && menuDayItem.menues.length > 0) {
                var dayWithMenu = {}
                dayWithMenu.selected = false
                dayWithMenu.listIndex = i
                dayWithMenu.weekdayIndex = new Date(menuDayItem.datum).getDay()
                dayWithMenu.weekdayName = weekday[dayWithMenu.weekdayIndex]
                result.push(dayWithMenu)
                console.log("===> menuDayItem.datum " + menuDayItem.datum)
            }
        }
        return result
    }

    function populateDaysModel(daysWithMenu) {
        daysModel.clear()
        for (var k = 0; k < daysWithMenu.length; k++) {
            if (k == 0) {
                daysWithMenu[k].selected = true
            }
            daysModel.append(daysWithMenu[k])
        }
    }

    function getMenusForDay(dayIndex, menues) {
        var result = []
        if (dayIndex >= menues.data.meinSpeiseplan.length) {
            console.log("[MenuOrderingPage] - menu not available for index " + dayIndex)
            return result
        }
        var menuDayItem = menues.data.meinSpeiseplan[dayIndex]
        if (menuDayItem.menues) {
            var numberOfMenus = (menuDayItem.menues.length)

            for (var j = 0; j < numberOfMenus; j++) {
                var menuOfDay = menuDayItem.menues[j]
                var menuItem = {}
                menuItem.id = menuOfDay.id
                menuItem.price = menuOfDay.meinPreis

                // menuItem.starter = menuOfDay.vorspeisen[0].bezeichnung;
                menuItem.starterNames = ""
                if (menuOfDay.hauptspeisen.length > 0) {
                    menuItem.mainCourseNames = menuOfDay.hauptspeisen[0].bezeichnung
                }
                if (menuOfDay.nachspeisen.length > 0) {
                    menuItem.desertNames = menuOfDay.nachspeisen[0].bezeichnung
                } else {
                    menuItem.desertNames = "-";
                }

                console.log("[MenuOrderingPage] - menu " + JSON.stringify(
                                menuItem))
                result.push(menuItem)
            }
        }
        return result
    }

    function populateDayMenuModel(menus) {
        menuModel.clear()
        for (var n = 0; n < menus.length; n++) {
            menuModel.append(menus[n])
        }
    }

    function populateWithMenus(menues, dateLabel) {
        //console.log("get menus result handler : " + result);
        dateSelectionRow.dateLabel = "" + dateLabel

        //menues = JSON.parse(result)

        var daysWithMenu = getDaysWithMenu(menues)
        console.log("[MenuOrderingPage] days with menu : " + JSON.stringify(
                        daysWithMenu))

        populateDaysModel(daysWithMenu)

        var days = menues.data.meinSpeiseplan.length
        console.log("[MenuOrderingPage] : " + days + " days")

        const weekday = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]

        for (var i = 0; i < days; i++) {
            var menuDayItem = menues.data.meinSpeiseplan[i]
            if (menuDayItem.menues) {
                var numberOfMenus = (menuDayItem.menues.length)
                console.log("[MenuOrderingPage] date : " + menuDayItem.datum
                            + ", menus : " + numberOfMenus)

                console.log(weekday[new Date(menuDayItem.datum).getDay()])

                for (var j = 0; j < numberOfMenus; j++) {
                    var menuOfDay = menuDayItem.menues[j]
                    var menuItem = {}
                    menuItem.id = menuOfDay.id
                    menuItem.price = menuOfDay.meinPreis

                    // menuItem.starter = menuOfDay.vorspeisen[0].bezeichnung;
                    if (menuOfDay.hauptspeisen.length > 0) {
                        menuItem.mainCourse = menuOfDay.hauptspeisen[0].bezeichnung
                    }
                    if (menuOfDay.nachspeisen.length > 0) {
                        menuItem.desert = menuOfDay.nachspeisen[0].bezeichnung
                    } else {
                        menuItem.desert = "-";
                    }

                    console.log("[MenuOrderingPage] - menu " + JSON.stringify(
                                    menuItem))
                }
            }
        }

        var menus = getMenusForDay(0, menues)
        populateDayMenuModel(menus)

        console.log("Menus : " + JSON.stringify(menus))
        //        menuModel.clear();
        //        for (var n = 0; n < menus.length; n++) {
        //            menuModel.append(menus[n]);
        //        }
    }

    function errorResultHandler(result) {
        console.log("error result handler")
    }

    function getMenuWithOffset(offsetChange) {
        weekOffset += offsetChange
        mensaMax.executeGetMenus(token, weekOffset)
    }

    SilicaFlickable {
        id: pageFlickable
        width: parent.width
        // height: parent.height
        contentHeight: column.height
        anchors.fill: parent

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
//            MenuItem {
//                text: qsTr("Show Page 2")
//                onClicked: pageStack.animatorPush(Qt.resolvedUrl("SecondPage.qml"))
//            }
            MenuItem {
                text: qsTr("Logout")
                onClicked: pageStack.pop();
            }
        }

        Column {
            id: column
            width: parent.width
            spacing: Theme.paddingMedium
            y: Theme.paddingLarge

            PageHeader {
                id: incidentsHeader
                //: OverviewPage page header
                title: qsTr("Adrian")
                description: "Balance: 233.00 €"
            }

            DateSelectionRow {
                id: dateSelectionRow
                width: parent.width
                dateLabel: ""
            }

            Row {
                id: daySelectionRow
                width: parent.width - (2 * Theme.paddingMedium)
                spacing: Theme.paddingMedium
                x: Theme.paddingMedium

                Repeater {
                    id: dayRepeater

                    model: ListModel {
                        id: daysModel
                    }

                    delegate: Button {
                        id: buttonDelegate
                        text: weekdayName
                        width: (parent.width + 2 * Theme.paddingSmall
                                - (2 * Theme.paddingSmall) * daysModel.count) / daysModel.count
                        //height: 40
                        backgroundColor: selected ? Theme.highlightBackgroundColor : Theme.backgroundGlowColor
                        onClicked: {
                            console.log(weekdayName + " clicked " + index + " - ")

                            for (var i = 0; i < daysModel.count; i++) {
                                daysModel.get(i).selected = false
                            }

                            daysModel.get(index).selected = true

                            var menus = getMenusForDay(index, menues)
                            console.log("Menus : " + JSON.stringify(menus))
                            populateDayMenuModel(menus)
                        }
                    }
                }

                Component.onCompleted: {
                    console.log("selecting first element")
                    // daysModel.get(0).selected = true
                }
            }

            SilicaListView {
                id: noIncidentsColumn
                visible: true

                anchors.left: parent.left
                anchors.right: parent.right

                height: menuSelectionPage.height - incidentsHeader.height
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
                        //                        width: parent.width
                        height: foodMenuItem.height
                        width: parent.width - (2 * Theme.paddingMedium)
                        x: Theme.paddingMedium

                        FoodMenuItem {
                            id: foodMenuItem
                            width: parent.width
                            starter: starterNames
                            mainCourse: mainCourseNames
                            dessert: desertNames
                        }
                    }
                }
            }
        }
    }

    Connections {
        target: mensaMax

        onGetMenusAvailable: {
            if (menuSelectionPage.status !== PageStatus.Active) {
                return;
            }
            console.log("[MenuOrderingPage] - previous week");
            menues = JSON.parse(reply);
            populateWithMenus(menues, dateLabel);
        }
    }

    Connections {
        target: dateSelectionRow

        onNextWeekClicked: {
            console.log("[MenuOrderingPage] - next week");
            getMenuWithOffset(offsetChange);
        }

        onPreviousWeekClicked: {
            console.log("[MenuOrderingPage] - previous week");
            getMenuWithOffset(offsetChange);
        }
    }

    Component.onCompleted: {
      //  connectSlots()
    //    mensaMax.executeGetMenus(token, weekOffset)

        console.log("[MenuOrderingPage] init");
        populateWithMenus(menues, dateLabel);

        //        reloadAllDividends();
        //        loaded = true;
    }

    //    Component.onDestroyed: {
    //        disconnectSlots();
    //    }
}
