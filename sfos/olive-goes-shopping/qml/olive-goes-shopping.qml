import QtQuick 2.0
import Sailfish.Silica 1.0
import Nemo.KeepAlive 1.2
import oarg.pawelspoon.olivegoesshopping.ogssettings 1.0
import io.thp.pyotherside 1.5

import "pages"

ApplicationWindow {

    id: applicationWindow
    property ApplicationController controller: myController
    property OGSSettings settings: settings
    property Python pythonController: python

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


    PythonHandler {
      id: python
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


