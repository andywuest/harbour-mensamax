.pragma library

Qt.include('constants.js')

function concatStrings(s1, s2, separator) {
    var result = "";
    if (s1 !== "-") {
        result += s1;
        if (s2 === "-") {
            return result;
        }
    }
    if (s2 === "-") {
        return "";
    }
    result = result + (s1 !== "-" ? separator : "") + s2;
    return result;
}

function getDaysWithMenu(menues) {
    var result = []
    var weekday = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
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

function getMenusForDay(dayIndex, weekMenu, groupingLabel) {
    var result = []
    var weekday = [qsTr("Sunday"), qsTr("Monday"), qsTr("Tuesday"), qsTr("Wednesday"), qsTr("Thursday"), qsTr("Friday"), qsTr("Saturday")]
    if (dayIndex >= weekMenu.data.meinSpeiseplan.length) {
        console.log("[.getMenusForDay] - menu not available for index " + dayIndex)
        return result
    }
    var menuDayItem = weekMenu.data.meinSpeiseplan[dayIndex]
    if (menuDayItem.menues) {
        var numberOfMenus = (menuDayItem.menues.length)

        if (numberOfMenus === 0) {
            console.log("[.getMenusForDay] - no menus available for given index " + dayIndex)
            return result;
        }

        for (var j = 0; j < numberOfMenus; j++) {
            var menuOfDay = menuDayItem.menues[j]
            var menuItem = {}
            menuItem.id = menuOfDay.id
            menuItem.price = menuOfDay.meinPreis
            menuItem.date = new Date(menuDayItem.datum);
            menuItem.weekdayIndex = new Date(menuDayItem.datum).getDay()
            menuItem.dateFormatted = new Date(menuDayItem.datum).toLocaleDateString(Qt.locale("de_DE"), "dd.MM")
            menuItem.weekdayName = weekday[menuItem.weekdayIndex]
            menuItem.dateString = menuItem.weekdayName + " " + menuItem.dateFormatted;
            menuItem.ordered = (menuOfDay.meineBestellung !== null)
            menuItem.menuGroup = "-";
            menuItem.week = groupingLabel + getWeekForDate(menuItem.date);

            if (menuOfDay.menuegruppe) {
                menuItem.menuGroup = menuOfDay.menuegruppe.bezeichnung;
            }

            menuItem.starterNames = "-";
            if (menuOfDay.vorspeisen.length > 0) {
                menuItem.starterNames = menuOfDay.vorspeisen[0].bezeichnung
            }

            menuItem.mainCourseNames = "-";
            if (menuOfDay.hauptspeisen.length > 0) {
                menuItem.mainCourseNames = menuOfDay.hauptspeisen[0].bezeichnung
            }

            menuItem.desertNames = "-";
            if (menuOfDay.nachspeisen.length > 0) {
                menuItem.desertNames = menuOfDay.nachspeisen[0].bezeichnung
            }

            console.log("[.getMenusForDay] - menu " + JSON.stringify(
                            menuItem))
            result.push(menuItem)
        }
    }
    console.log("[.getMenusForDay] - menu count : " + result.length);
    return result
}

function formatPrice(price) {
    // console.log("[.formatPrice] price to render : " + price)
    return Number(price).toLocaleString(Qt.locale(), 'f', 2);
}

// source: https://weeknumber.com/how-to/javascript
function getWeekForDate(date) {
  date.setHours(0, 0, 0, 0);
  // Thursday in current week decides the year.
  date.setDate(date.getDate() + 3 - (date.getDay() + 6) % 7);
  // January 4 is always in week 1.
  var week1 = new Date(date.getFullYear(), 0, 4);
  // Adjust to Thursday in week 1 and count number of weeks from date to week1.
  return 1 + Math.round(((date.getTime() - week1.getTime()) / 86400000
                        - 3 + (week1.getDay() + 6) % 7) / 7);
}
