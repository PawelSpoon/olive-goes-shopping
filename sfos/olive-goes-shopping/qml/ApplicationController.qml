import QtQuick 2.0
import "pages"

// responsible to connect the various pages together do the updates etc
// not responsible for data reading / storing -> all in python via applicationWindow.python

Item {

    id: applicationController
    property string currentPage: 'any'

    // this gets fired when unit, phydim , pick lists get updated
    // it should also invalidate the cache
    signal signal_asset_updated(var itemType)

    // this gets fired, when a list was updated
    // everybody should reload
    signal signal_list_updated(var name)

    function updateCoverList(listName,model) {
        applicationWindow.cover.fillModel(listName,model)
    }


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

    // should be renamed to something better
    function updateParentPage(itemType)
    {
       console.log('sending?')
       cache.invalidate()
       // in case of rename of itemtype's i need to re-init assetmanager
       if (itemType === "itemtype") {
           // now that could take longer .. maybe async
           applicationWindow.python.reInit(itemType)
       }
       if (itemType === "shop") { // when added / removed a shopping list
            applicationWindow.python.reInit(itemType)       
       }
       signal_asset_updated(itemType)
    }

    function propagateCategoryChanged()
    {
       // update everyone with new category orders
    }

    function propagateUnitChanged()
    {

    }

    function getUniqueId() {
        console.log("getUniqueId() called.");
        var dateObject = new Date();
        var uniqueId = dateObject.getFullYear() + '' +
            dateObject.getMonth() + '' +
            dateObject.getDate() + '' +
            dateObject.getTime();
        return uniqueId;
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

    function openAddPicklistDialog(name)
    {
        console.log('opening add from picklist dialog for list: ' + name)
        pageStack.push(Qt.resolvedUrl("pages/AddItemType2ListPage.qml"), { listName: name, itemType: "food"})
    }

    function openAddDialog(name,mode)
    {
        console.log('opening add dialog for list: ' + name + ' in mode: ' + mode)
        pageStack.push(Qt.resolvedUrl("pages/AnyItemDialog.qml"), { listName: name, mode: mode})
    }

    function openEditDialog(name,mode,item)
    {
        console.log('opening add dialog for list: ' + name + ' in mode: ' + mode)
        console.log(item.Id+item.Name+item.Amount+item.Unit)
        pageStack.push(Qt.resolvedUrl("pages/AnyItemDialog.qml"), {
                           listName: name,
                           mode: mode,
                           uid_: item['Id'],
                           name_: item['Name'],
                           amount_: item['Amount'],
                           unit_ : item['Unit'],
                           category_ : item['Category'],
                           done_: item['Done']
                       })
    }

    function openTemplatePage(type, mode, name)
    {
        console.log("openTemplatePage for type: " + type)
        pageStack.push(Qt.resolvedUrl("pages/TemplateDialog.qml"), {itemType: type, mode: mode, item: {}});
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

    function openUnitsMngmtPage()
    {
         pageStack.push(Qt.resolvedUrl("pages/ManageEnumsPage.qml"), {enumType: "unit", readonly: true})
    }

    function openPhyDimMngmtPage()
    {
         pageStack.push(Qt.resolvedUrl("pages/ManageEnumsPage.qml"), {enumType: "phydim", readonly: true})
    }

    function openCategoryMngmtPage()
    {
         pageStack.push(Qt.resolvedUrl("pages/ManageEnumsPage.qml"), {enumType: "category", readonly: false, sortable: true, groupbyCategory: false})
    }

    function openItemTypeMngmtPage()
    {
        pageStack.push(Qt.resolvedUrl("pages/ManageEnumsPage.qml"), {enumType: "itemtype", readonly: false, sortable: true})
    }

    function openRecipesMngmtPage()
    {
        pageStack.push(Qt.resolvedUrl("pages/ManageEnumsPage.qml"), {enumType: "recipe", readonly: false, sortable: false})
    }


    function openItemsMngmtPage(itemtype)
    {
        pageStack.push(Qt.resolvedUrl("pages/ManageEnumsPage.qml"), {enumType: itemtype, readonly: false})
    }

    function openTemplateMngmtPage(type)
    {
        console.log(type)
        pageStack.push(Qt.resolvedUrl("pages/TemplateSelector.qml"), {itemType: type})
    }

    // this is the page for managing re-ocurring shoping lists
    function openShopListMngmtPage()
    {
        pageStack.push(Qt.resolvedUrl("pages/ManageEnumsPage.qml"), {enumType: "shop", readonly: false})
    }

    function openShoppingListPage(listName)
    {
        pageStack.push(Qt.resolvedUrl("pages/ShoppingListPage.qml"), {listName: listName})
    }

    function openTaskListPage(listName)
    {
        pageStack.push(Qt.resolvedUrl("pages/TaskListPage.qml"), {listName: listName})
    }

    function openShoppingListTemplatePage(listName)
    {
        pageStack.push(Qt.resolvedUrl("pages/ShoppingListPage.qml"), {listName: listName})
    }

    function openTaskTemplatePage(listName)
    {
        pageStack.push(Qt.resolvedUrl("pages/TaskListPage.qml"), {listName: listName})
    }

    function openCreateListDialog()
    {
        pageStack.push(Qt.resolvedUrl("pages/CreateListDialog.qml"), {mode: 2})
    }

    // type, page, 0: read-only, 1: edit, 2: add
    function openMgmtDetailPage(type, mode, item)
    {
        console.log("open editor for: " + type + " in mode: " + mode)

        switch(type) {
        case "unit":
            pageStack.push(Qt.resolvedUrl("pages/EnumDialog.qml"), {itemType: type, mode: 0})
            break
        case "phydim":
            pageStack.push(Qt.resolvedUrl("pages/EnumDialog.qml"), {itemType: type, mode: 0})
            break
        case "itemtype":
            pageStack.push(Qt.resolvedUrl("pages/EnumDialog.qml"), {itemType: type, mode: mode, item: item})
            break
        case "category":
            pageStack.push(Qt.resolvedUrl("pages/EnumDialog.qml"), {itemType: type, mode: mode, item: item})
            break
        case "food":
            pageStack.push(Qt.resolvedUrl("pages/ItemDialog.qml"), {itemType: type, mode: mode, item: item})
            break
        case "household":
            pageStack.push(Qt.resolvedUrl("pages/ItemDialog.qml"), {itemType: type, mode: mode, item: item})
            break
        case "recipe":
            pageStack.push(Qt.resolvedUrl("pages/RecipeDialog.qml"), {itemType: type, mode: mode, item: item})
            break
         case "task":
             pageStack.push(Qt.resolvedUrl("pages/ItemDialog.qml"), {itemType: type, mode: mode, item: item})
             break
         default:
             // check in itemtypes then open enumdialog
             if (isInList(type, applicationWindow.cache.getItemtypes())) {
                pageStack.push(Qt.resolvedUrl("pages/ItemDialog.qml"), {itemType: type, mode: mode, item: item})
             }
             break;

             console.error("could not find editor")

        }
    }

    function isInList(name, list)
    {
        if (name === '') { return false }
        for (var i = 0; i < list.length ; i++) {
            if( list[i].Name === name) {
                return true
            }
        }
        return false
    }

    function createList(type, name, template) {
        console.log(template)
        var items
        if (template != undefined) {
            items = applicationWindow.python.getTemplateItems(type,template)
            console.log("loaded following number of items: " + items.length)
        }
        applicationWindow.python.createList(name,type,items)
        updateParentPage(type)
    }

    function deleteList(name, type) {
        applicationWindow.python.deleteList(name,type)
        updateParentPage(type)
    }

    function createTemplate(items, name, type) {
        console.log('create template: ' + name + " " + type)
        applicationWindow.python.createTemplate(items, name,type)
        updateParentPage(type)
    }

    function deleteTemplate(name, type) {
        applicationWindow.python.deleteTemplate(name,type)
        updateParentPage(type)
    }

///////////////////////////////////////////////////////////////////

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


}
