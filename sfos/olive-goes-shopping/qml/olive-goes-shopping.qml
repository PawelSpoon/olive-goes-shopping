import QtQuick 2.0
import Sailfish.Silica 1.0
import Nemo.KeepAlive 1.2
import oarg.pawelspoon.olivegoesshopping.ogssettings 1.0

import "pages"

ApplicationWindow {

    id: applicationWindow
    property ApplicationController controller: myController
    property OGSSettings settings: settings

    ApplicationController {
        id: myController
    }

    OGSSettings {
        id: settings
        onModuleChanged: {
            console.log('module settings did change -> need to update visibility')
        }
        onCategoryChanged: {
            console.log('category settings did change -> need to update visibility')
        }
        onCapitalizationChanged: {
            console.log('capitalization changed')
        }
    }

    initialPage:Component {
        FirstPage {
             id: firstPage
             Component.onCompleted: {
             }
        }
    }
    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: defaultAllowedOrientations
}


