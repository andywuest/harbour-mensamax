import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: page

    property var token;

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All

    function connectSlots() {
        console.log("connect - slots");
        mensaMax.loginAvailable.connect(loginResultHandler);
        mensaMax.getBalanceAvailable.connect(getBalanceResultHandler);
        mensaMax.getUserDataAvailable.connect(getUserDataResultHandler);
        mensaMax.getMenusAvailable.connect(getMenusResultHandler);
        mensaMax.requestError.connect(errorResultHandler);
    }

    function disconnectSlots() {
        console.log("disconnect - slots");
        mensaMax.loginAvailable.disconnect(loginResultHandler);
        mensaMax.getBalanceAvailable.disconnect(getBalanceResultHandler);
        mensaMax.getUserDataAvailable.disconnect(getUserDataResultHandler);
        mensaMax.getMenusAvailable.disconnect(getMenusResultHandler);
        mensaMax.requestError.disconnect(errorResultHandler);
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

    function getMenusResultHandler(result) {
        console.log("get menus result handler : " + result);
    }

    function errorResultHandler(result) {
        console.log("error result handler");
    }

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: qsTr("Show Page 2")
                onClicked: pageStack.animatorPush(Qt.resolvedUrl("SecondPage.qml"))
            }
            MenuItem {
                text: qsTr("Show Page 3")
                onClicked: pageStack.animatorPush(Qt.resolvedUrl("MenuOrderingPage.qml"))
            }
        }

        // Tell SilicaFlickable the height of its content.
        contentHeight: column.height

        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            id: column

            width: page.width
            spacing: Theme.paddingLarge
            PageHeader {
                title: qsTr("UI Template")
            }
            Label {
                x: Theme.horizontalPageMargin
                text: qsTr("Hello Sailors")
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeExtraLarge
            }
            Button {
                width: parent.width
                text: qsTr("Login")
                onClicked: mensaMax.executeLogin("", "", "", "");
            }

            Button {
                width: parent.width
                text: qsTr("Get Balance")
                onClicked: mensaMax.executeGetBalance(token);
            }

            Button {
                width: parent.width
                text: qsTr("Get UserData")
                onClicked: mensaMax.executeGetUserData(token);
            }

            Button {
                width: parent.width
                text: qsTr("Get Menus")
                onClicked: mensaMax.executeGetMenus(token);
            }

        }
    }

    Component.onCompleted: {
        connectSlots();
//        reloadAllDividends();
//        loaded = true;
    }

}
