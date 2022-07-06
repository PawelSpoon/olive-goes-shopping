import QtQuick 2.0
import Sailfish.Silica 1.0
import Nemo.KeepAlive 1.2
import oarg.pawelspoon.olivegoesshopping.ogssettings 1.0
import io.thp.pyotherside 1.5

import "pages"

ApplicationWindow {

    id: applicationWindow
    property ApplicationController controller: myController
    property DataCache cache : dataCache
    property OGSSettings settings: settings
    property Python python: pythonHandler
    property bool initialized: false
    property variant shopPage: listSelector

    ApplicationController {
        id: myController
    }

    DataCache {
        id: dataCache
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
      id: pythonHandler
    }

    // loads the many page only after python was succesfully intialized
    function signal_init(module_id, method_id, description) {
        console.log("python initialized")
        initialized = true
        shopPage.load()
    }

    function singal_error(module_id, method_id, description) {
        // show error window ?
        console.log("from applicationWindow: ")
        console.log("             module_id: " + module_id)
        console.log("             method_id: " + method_id)  
        console.log("           description: " + description)      
    }



    initialPage:  Component {
        ListSelector {
             id: listSelector
             Component.onCompleted: {
                 applicationWindow.shopPage = listSelector

             }

        }
    }

    Component.onCompleted: {
        
    }


    cover: Qt.resolvedUrl("cover/CoverPage.qml")
    allowedOrientations: defaultAllowedOrientations
}


