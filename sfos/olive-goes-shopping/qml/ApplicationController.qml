import QtQuick 2.0
import "pages"
import io.thp.pyotherside 1.4

Item {

    id: applicationController
    property string currentPage: 'any'

    // array of pages
    property variant pages: []
    function addPage(name1, page1) {
        if (getCurrentPageView(name1) === null) {
            console.log('addPage: ' + name1);
            pages.push( { name: name1, page: page1});
            return;
        }
        console.log('no need to push, already there, lets replace')
        pages[getCurrentPageIndex(name1)].page = page1
    }

    function getListManager()
    {

    }

    function getAssetManager()
    {

    }

    function propageteCategoryChanged()
    {
       // update everyone with new category orders
    }

    function propageteUnitChanged()
    {

    }

    function refreshAll()
    {
        var count = pages.length
        for (var i = 0; i < count; i++) {
          var currentItem = pages[i].page;
          currentItem.refresh();
        }
    }

    function doAccept()
    {
        // find currentpage and call accept
        console.log('doAccept for page: ' + currentPage)
        getCurrentPageView(currentPage).doAccept();
        updateShoppingListPage();
    }

    function updateShoppingListPage()
    {
        applicationWindow.page.initPage()
    }


    function openAddDialog()
    {
         pageStack.push(Qt.resolvedUrl("pages/TabedAddDialogX.qml"), {shoppingListPage: applicationWindow.page, itemType: "-"})
    }

    function openManageMainPage()
    {
        pageStack.push(Qt.resolvedUrl("pages/ManageMainPage.qml"))
    }

    function openAboutPage()
    {
        pageStack.push(Qt.resolvedUrl("pages/About.qml"), { })
    }

    function openHelpPage()
    {
        pageStack.push(Qt.resolvedUrl("pages/HelpMainPage.qml"), { })
    }

    function openShareDialog()
    {
        pageStack.push(Qt.resolvedUrl("pages/ShareWithPage.qml"), { })
    }

    function openSettingsPage()
    {
        pageStack.push(Qt.resolvedUrl("pages/Settings.qml"), { })
    }

    function openUnitsPage()
    {
         pageStack.push(Qt.resolvedUrl("pages/ManageEnumsPage.qml"), {enumType: "unit"})
    }

    function openPhyDimsPage()
    {
         pageStack.push(Qt.resolvedUrl("pages/ManageEnumsPage.qml"), {enumType: "phydim"})
    }

    function setCurrentPage(pageName) {
        console.log("setCurrentPage: " + pageName)
        currentPage = pageName
        // applicationWindow.cover.title = qsTr(pageName)
        showMyMenues(pageName)
        // updateCoverList(pageName, getCurrentPageView(pageName).getCoverPageModel())
    }

    function getCurrentPageIndex(currentPage)
    {
        console.log("getCurrentPageView: " + currentPage)
        var count = pages.length
        console.log("number of pages: " + count)
        for (var i = 0; i < count; i++) {
            console.log(pages[i].name)
            if (currentPage === pages[i].name) {
                console.log('found at index: ' + i )
                return i;
            }
        }
        console.log("page not found: " + currentPage)
        return -1;
    }

    function getCurrentPageView(currentPage)
    {
        var index = getCurrentPageIndex(currentPage);
        if (index === -1) {
            console.log("page not found: " + currentPage)
            return null;
        }
        return pages[index].page
    }

    function updateCoverList(pageName, model) {
        //todo:
        /*
        if (currentPage !== pageName) return
        if (model === null) {
            console.log('try to reload model')
            model = getCurrentPageView(pageName).getCoverPageModel()
        }
        applicationWindow.cover.fillModel(model)*/
    }

    function getCapitalization()
    {
        if (applicationWindow.settings.useCapitalization)
            return Font.MixedCase
        else
            return Font.AllLowercase
    }

    function showMyMenues(page)
    {
        // not needed in this app
        /*if (page==='location')
        {
            applicationWindow.mainPage.menuManageVisible(true);
        }
        else if (page === 'artist')
        {
            applicationWindow.mainPage.menuManageVisible(true);
        }
        else {
            applicationWindow.mainPage.menuManageVisible(false);
        }*/
    }

    // the next function of cover of the caroussell
    function moveToNextPage()
    {
        // something with currentIndex would be cooler
       console.log('Controller::moveNextPage');
       if (currentPage === "any") {
           applicationWindow.mainPage.moveToTab(1);
           setCurrentPage('household')
       }
       else if (currentPage === "household") {
           applicationWindow.mainPage.moveToTab(2);
           setCurrentPage('food')
       }
       else if (currentPage === "food") {
           applicationWindow.mainPage.moveToTab(3);
           setCurrentPage('recipe')
       }
       else if (currentPage === "recipe") {
           applicationWindow.mainPage.moveToTab(0);
           setCurrentPage('any')
       }
       else {
           console.log("dont know where to naviage from here: " + currentPage);
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

}
