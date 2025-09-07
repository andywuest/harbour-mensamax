.pragma library

Qt.include('constants.js')

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

function getMenusForDay(dayIndex, menues) {
    var result = []
    if (dayIndex >= menues.data.meinSpeiseplan.length) {
        console.log("[.getMenusForDay] - menu not available for index " + dayIndex)
        return result
    }
    var menuDayItem = menues.data.meinSpeiseplan[dayIndex]
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
            menuItem.ordered = (menuOfDay.meineBestellung !== null)
            menuItem.menuGroup = "-";

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
    return result
}

function formatPrice(price) {
    console.log("[.formatPrice] price to render : " + price)
    return Number(price).toLocaleString(Qt.locale(), 'f', 2);
}
