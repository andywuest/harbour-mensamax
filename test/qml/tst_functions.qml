import QtQuick 2.2
import QtTest 1.2

import "../../qml/js/functions.js" as Functions
import "../../qml/js/constants.js" as Constants

TestCase {
    name: "Function Tests"

    function test_getMenusForDay() {
        runWithTestData("menu1.json", function(testData) {
            // given
            var jsonTestData = JSON.parse(testData);

            console.log("data : " + jsonTestData);

            // when
            var result = Functions.getMenusForDay(1, jsonTestData); // index 0 has no menu

            // then
            compare(result.length, 2)

            compare(result[0].id, 4691)
            compare(result[0].desertNames, "Nuss-Schnecke")
            compare(result[0].mainCourseNames, "veg. Gyros + Reis + Tsatsiki")
            compare(result[0].menuGroup, "Vegetarisch")
            compare(result[0].ordered, false)
            compare(result[0].price, 4.7)
            compare(result[0].starterNames, "Salat")

            compare(result[1].id, 4690)
            compare(result[1].desertNames, "Nuss-Schnecke")
            compare(result[1].mainCourseNames, "Gyros + Reis + Tsatziki")
            compare(result[1].menuGroup, "Vollwert")
            compare(result[1].ordered, true)
            compare(result[1].price, 4.7)
            compare(result[1].starterNames, "Salat")
        })
    }

    function test_getDaysWithMenu() {
        runWithTestData("week1.json", function(testData) {
            // given
            var jsonTestData = JSON.parse(testData);

            console.log("data : " + jsonTestData);

            // when
            var result = Functions.getDaysWithMenu(jsonTestData);

            // then
            compare(result.length, 5)

            console.log("result : " + result);

            for (var i = 0; i < result.length; i++) {
            console.log("result : " + JSON.stringify(result[i]));
            }

            compare(result[0].listIndex, 0);
            compare(result[0].selected, false);
            compare(result[0].weekdayIndex, 1);
            compare(result[0].weekdayName, "Mo");

            compare(result[4].listIndex, 4);
            compare(result[4].selected, false);
            compare(result[4].weekdayIndex, 5);
            compare(result[4].weekdayName, "Fr");
        })
    }

    function test_populateMainCourseName_starterNames_notSelectable() {
        // given
        var menuItem = {};
        var loadedMenu = {}
        loadedMenu.starterNames = "SchulFerien";
        loadedMenu.mainCourseNames = "";

        // when
        Functions.populateMainCourseName(menuItem, loadedMenu);

        // then
        compare(menuItem.hasSelectableMenu, false);
        compare(menuItem.mainCourseNames, "SchulFerien");
    }

    function test_populateMainCourseName_mainCourseNames_notSelectable() {
        // given
        var menuItem = {};
        var loadedMenu = {}
        loadedMenu.starterNames = "";
        loadedMenu.mainCourseNames = "Ferien";

        // when
        Functions.populateMainCourseName(menuItem, loadedMenu);

        // then
        compare(menuItem.hasSelectableMenu, false);
        compare(menuItem.mainCourseNames, "Ferien");
    }

    function test_populateMainCourseName_selectable() {
        // given
        var menuItem = {};
        var loadedMenu = {}
        loadedMenu.starterNames = "Pizza";
        loadedMenu.mainCourseNames = "";

        // when
        Functions.populateMainCourseName(menuItem, loadedMenu);

        // then
        compare(menuItem.hasSelectableMenu, true);
        compare(menuItem.mainCourseNames, "No food ordered");
    }

    function runWithTestData(fileName, testFunction) {
        var xhr = new XMLHttpRequest()
        var fullfileName = "testdata/" + fileName;
        console.log("testfile: " + fullfileName);
        xhr.onreadystatechange = function () {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                console.log("DONE")
                testFunction(xhr.responseText);
            }
        }
        xhr.open("GET", fullfileName, false)
        xhr.send()
    }

}
