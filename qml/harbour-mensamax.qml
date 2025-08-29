import QtQuick 2.2
import Sailfish.Silica 1.0
import Nemo.Configuration 1.0

import "pages"

ApplicationWindow {
    id: app

    // Global Settings Storage
    ConfigurationGroup {
        id: mensamaxSettings
        path: "/apps/harbour-mensamax/settings"

        property string accountsString: "[]"
    }

    initialPage: Component {
        AccountsOverviewPage {}
    }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: defaultAllowedOrientations
}
