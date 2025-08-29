.pragma library

Qt.include('constants.js')

function getDaysWithMenu(menues) {
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
            // console.log("===> menuDayItem.datum " + menuDayItem.datum)
        }
    }
    return result
}
