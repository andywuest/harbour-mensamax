import QtQuick 2.0
import Sailfish.Silica 1.0

import "../components"

Page {
    id: twoColumnPage

    property int weekOffset: 0
    property string token: ""

    function connectSlots() {
        console.log("connect - slots");
        mensaMax.loginAvailable.connect(loginResultHandler);
        mensaMax.getBalanceAvailable.connect(getBalanceResultHandler);
        mensaMax.getUserDataAvailable.connect(getUserDataResultHandler);
        mensaMax.getMenusAvailable.connect(getMenusResultHandler);
        mensaMax.requestError.connect(errorResultHandler);
        dateSelectionRow.nextWeekClicked.connect(getMenuWithOffset)
        dateSelectionRow.previousWeekClicked.connect(getMenuWithOffset)
    }

    function disconnectSlots() {
        console.log("disconnect - slots");
        mensaMax.loginAvailable.disconnect(loginResultHandler);
        mensaMax.getBalanceAvailable.disconnect(getBalanceResultHandler);
        mensaMax.getUserDataAvailable.disconnect(getUserDataResultHandler);
        mensaMax.getMenusAvailable.disconnect(getMenusResultHandler);
        mensaMax.requestError.disconnect(errorResultHandler);
        dateSelectionRow.nextWeekClicked.disconnect(getMenuWithOffset)
        dateSelectionRow.previousWeekClicked.disconnect(getMenuWithOffset)
    }

    function loginResultHandler(result) {
        console.log("login result handler : " + result);
        var parsedResult = JSON.parse(result);
        token = parsedResult.text;
    }

    function getBalanceResultHandler(result) {
        console.log("get balance result handler : " + result);
    }

    function getUserDataResultHandler(result) {
        console.log("get user data result handler : " + result);
    }

    function getDaysWithMenu(menuResponse) {
        var result = [];
        const weekday = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"];
        var menues = JSON.parse(menuResponse);
        var days = menues.data.meinSpeiseplan.length;
        for (var i = 0; i < days; i++) {
            var menuDayItem = menues.data.meinSpeiseplan[i];
            if (menuDayItem.menues && menuDayItem.menues.length > 0) {
                var dayWithMenu = {};
                dayWithMenu.index = i;
                dayWithMenu.weekdayIndex = new Date(menuDayItem.datum).getDay();
                dayWithMenu.weekdayName = weekday[dayWithMenu.weekdayIndex];
                result.push(dayWithMenu);
            }
        }
        return result;
    }


    function getMenusResultHandler(result, dateLabel) {
        console.log("get menus result handler : " + result);
        dateSelectionRow.dateLabel = dateLabel;

        var menues = JSON.parse(result);

        console.log("[MenuOrderingPage] days with menu : " + JSON.stringify(getDaysWithMenu(result)));


        var days = menues.data.meinSpeiseplan.length;
        console.log("[MenuOrderingPage] : " + days + " days");

        const weekday = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"];

        for (var i = 0; i < days; i++) {
            var menuDayItem = menues.data.meinSpeiseplan[i];
            if (menuDayItem.menues) {
                var numberOfMenus = (menuDayItem.menues.length);
                console.log("[MenuOrderingPage] date : " + menuDayItem.datum + ", menus : " + numberOfMenus);

                console.log(weekday[new Date(menuDayItem.datum).getDay()]);

                for (var j = 0; j < numberOfMenus; j++) {
                    var menuOfDay = menuDayItem.menues[j];
                    var menuItem = {};
                    menuItem.id = menuOfDay.id;
                    menuItem.price = menuOfDay.meinPreis;
                    menuItem.mainCourse = menuOfDay.hauptspeisen[0].bezeichnung;
                    menuItem.desert = menuOfDay.nachspeisen[0].bezeichnung;

                    console.log("[MenuOrderingPage] - menu " + JSON.stringify(menuItem));
                }
            }


        }





    }

    function errorResultHandler(result) {
        console.log("error result handler");
    }

    function getMenuWithOffset(offsetChange) {
        weekOffset += offsetChange;
        mensaMax.executeGetMenus(token, weekOffset);
    }


    SilicaFlickable {
        id: pageFlickable
        width: parent.width
        height: parent.height
        anchors.fill: parent


        Column {
            id: column
            width: parent.width
            spacing: Theme.paddingMedium

            PageHeader {
                id: incidentsHeader
                //: OverviewPage page header
                title: qsTr("Adrian")
                description: "Balance: 233.00 €";
            }

            DateSelectionRow {
                id: dateSelectionRow
                width: parent.width
                height: pageFlickable.height - incidentsHeader.height - noIncidentsColumn.height +
                        2 * Theme.paddingMedium
                dateLabel: ""
            }

            SilicaListView {
                id: noIncidentsColumn

                height: pageFlickable.height //- dateSelectionRow.height
                        - incidentsHeader.height - Theme.paddingMedium
                                width: parent.width
                                anchors.left: parent.left
                                anchors.right: parent.right
                             clip: true

//                model: ListModel {
//                   id: menuModel
//                }




                Row {
                    anchors.fill : parent
                    //anchors.top: dateSelectionRow.bottom
                    anchors.margins: Theme.paddingLarge
                    spacing: Theme.paddingLarge

                    // Left Column: occupies remaining space
                    Column {
                        id: leftColumn
                        width: parent.width - rightColumn.width - Theme.paddingLarge
                        spacing: Theme.paddingMedium

                        FoodMenuItem {
                            id: lunch1
                            width: parent.width
                            starter: ""
                            mainCourse: "MSC Fischfilet unter der Kruste mit Kräutersauce und Stampfkartoffeln"
                            dessert: "Bio Tagesdessert"
                        }

                        FoodMenuItem {
                            id: lunch2
                            width: parent.width
                            starter: ""
                            mainCourse: "Bio Gemüsefrikadelle mit Bratenso0e, Bluemnkohl und Kartoffelpüree"
                            dessert: "Bio Tagesdessert"
                        }

                    }

                    // Right Column: fixed width
                    Column {
                        id: rightColumn
                        width: 100
                        spacing: Theme.paddingSmall

                        Component.onCompleted: {
                            console.log("selecting first element");
                            listModel.get(0).selected = true;
                        }

                        Repeater {
                            model: ListModel {
                                id: listModel
                                ListElement { name: "Mo"; selected: false }
                                ListElement { name: "Di"; selected: false }
                                ListElement { name: "Mi"; selected: false }
                                ListElement { name: "Do"; selected: false }
                                ListElement { name: "Fr"; selected: false }
                                ListElement { name: "Sa"; selected: false }
                                ListElement { name: "So"; selected: false }
                            }

                                // ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]

                            delegate: Button {
                                id: delegate
                                text: name
                                width: parent.width
                                backgroundColor: selected ? Theme.highlightBackgroundColor : Theme.backgroundGlowColor
                                onClicked: {
                                    console.log(name + " clicked " + index + " - ")
                                    // delegate.text = delegate.text + "."
                                    //if (modelData)

                                    for (var i = 0; i < listModel.count; i++) {
                                        listModel.get(i).selected = false;
                                    }
                                    listModel.get(index).selected = true;

                                    //selected = !selected
                                    //delegate.backgroundColor = Theme.highlightBackgroundColor
                                    //for (var i = 0; i < )
                                    //
                                }
                            }
                        }



                    }
                }



            }


        }


    }

    Component.onCompleted: {
        connectSlots();
        mensaMax.executeGetMenus(token, weekOffset);

//        reloadAllDividends();
//        loaded = true;
    }

//    Component.onDestroyed: {
//        disconnectSlots();
//    }



}
