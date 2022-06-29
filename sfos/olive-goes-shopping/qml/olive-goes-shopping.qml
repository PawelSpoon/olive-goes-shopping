import QtQuick 2.0
import Sailfish.Silica 1.0
import Nemo.KeepAlive 1.2
import oarg.pawelspoon.olivegoesshopping.ogssettings 1.0
import io.thp.pyotherside 1.4

import "pages"

ApplicationWindow {

    id: applicationWindow
    property ApplicationController controller: myController
    property OGSSettings settings: settings
    property Python python: python

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

    Python {

        id: python

        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl('.'));

            /*setHandler('progress', function(ratio) {
                dlprogress.value = ratio;
            });
            setHandler('finished', function(newvalue) {
                page.downloading = false;
                mainLabel.text = 'Color is ' + newvalue + '.';
            });

            importModule('datadownloader', function () {});*/
            importModule('initpythonenv', function () {
                console.log("init done");
                console.log('number of categories: ' + evaluate('len(initpythonenv.getController("category").getList())'))})

        }

        function init() {


        }

        function startDownload() {
            page.downloading = true;
            dlprogress.value = 0.0;
            call('datadownloader.downloader.download', function() {});
        }

        onError: {
            // when an exception is raised, this error handler will be called
            console.log('python error: ' + traceback);
        }

        onReceived: {
            // asychronous messages from Python arrive here
            // in Python, this can be accomplished via pyotherside.send()
            console.log('got message from python: ' + data);
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


