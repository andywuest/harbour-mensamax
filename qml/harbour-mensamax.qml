import QtQuick 2.2
import Sailfish.Silica 1.0
import Nemo.Configuration 1.0

import "pages"

import "js/constants.js" as Constants

ApplicationWindow {
    id: app

    // Global Settings Storage
    ConfigurationGroup {
        id: mensamaxSettings
        path: "/apps/harbour-mensamax/settings"

        property string accountsString: "[]"
        property int periodStart: Constants.START_PERIOD_CURRENT_WEEK
        property int numberOfWeeksToLoad: 3
    }

    initialPage: Component {
        AccountsOverviewPage {}
    }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: defaultAllowedOrientations
}
