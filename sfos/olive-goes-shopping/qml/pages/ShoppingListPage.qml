
import QtQuick 2.1
import Sailfish.Silica 1.0
import oarg.pawelspoon.olivegoesshopping.ogssettings 1.0
import Nemo.Notifications 1.0
//import Sailfish.Share 1.0

Page {
    id: listPage
    property string selectedCategory
    property string listName
    property string itemType : "shop"

    // The effective value will be restricted by ApplicationWindow.allowedOrientationso
    allowedOrientations: Orientation.All

    Component.onCompleted:
    {
        console.log("onCompleted with " + itemType)
        applicationWindow.controller.signal_list_updated.connect(onListChanged)
        initPage();
    }

    function onListChanged(listName) {
        console.log(" i was told to update myself")
        listPage.updatePage()
    }

    function updatePage()
    {
        // shoppinglistitem does update the value in db but not in the model
        // as a workaround i need to initpage

        // print('updatePage')
        // i might need to update the item too
        // applicationWindow.updateCoverList(listModel)
        initPage()
    }


    function update(id,name,itemType,category,amount,unit,done) {
        // check all items where howmany > 0
        for (var i = 0; i < listModel.count; i++)
        {
            var item = listModel.get(i)
            console.log(item.Name)
            if (item.Name === name) {
                console.log(done)
                //listModel.setProperty(i,"HowMany",howMany)
                listModel.setProperty(i,"Done",done)
                applicationWindow.python.setDoneValue(itemType, listName, name, done)
                return
            }
        }
        console.log(name + " not found in list")
    }

    function editCurrent(name)
    {
        var current = DB.getDatabase().getShoppingListItemPerName(name)
        pageStack.push(Qt.resolvedUrl("AnyItemDialog.qml"),
                        {shoppingListPage: firstPage, uid_: current[0].uid , name_: current[0].name, amount_: current[0].howMany, unit_: current[0].unit, category_: current[0].category })
    }

    function markAsDoneInShoppingList(name)
    {
        for(var i=0; i< listModel.count; i++)
        {
          console.debug(listModel.get(i).Name)
          if(listModel.get(i).Name === name) {
            listModel.get(i).Done = true;
            break
          }
        }
    }

    // currently not used by should be from ShoppingListItem to inform
    function markAsDone(uid,name,amount,unit,category,done)
    {
        applicationWindow.python.setDoneValue(itemType, listName, name, done)
        initPage()
    }

    function initPage()
    {
        var items = applicationWindow.python.getList(itemType,listName)
        listModel.clear()
        fillShoppingListModel(items)
        applicationWindow.controller.updateCoverList(listName,listModel)
    }



    function fillShoppingListModel(items)
    {
        print('number of items: ' +  items.length)
        for (var i = 0; i < items.length; i++)
        {
            listModel.append({"Id": items[i].Id,
                                 "Name": items[i].Name,
                                 "Amount": items[i].Amount,
                                 "Unit": items[i].Unit,
                                 "Done": items[i].Done,
                                 "ItemType": items[i].ItemType,
                                 "Category": items[i].Category })
            console.log("Id" + items[i].Id +
                        "Name"+ items[i].Name+
                        "Amount"+ items[i].Amount+
                        "Unit"+ items[i].Unit+
                        "Done"+ items[i].Done+
                        "ItemType"+ items[i].ItemType+
                        "Category"+ items[i].Category )
        }

        sortModel();
    }

    function sortModel()
    {
        // not needed, done in db
        print("sorting")
        for(var i=0; i< listModel.count; i++)
        {
            for(var j=0; j<i; j++)
            {
                // console.debug(listModel.get(i).category)
                if(listModel.get(i).category === listModel.get(j).category)
                   listModel.move(i,j,1)
                // break
            }
        }
    }

    // converts shopping list to shareable string
    function convertListToShareAble()
    {
        var listToShare = "";
        for (var i=0; i< listModel.count; i++) {
            var oneItemAsString = listModel.get(i).Name + " " + listModel.get(i).Amount
            listToShare += "\n" + oneItemAsString // here newline instead
        }
        return listToShare;
    }

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaListView {
        id: shoppingList
        anchors.fill: parent
        model: listModel
        VerticalScrollDecorator { flickable: shoppingList }

        PullDownMenu {
            MenuItem {
                text: qsTr("Clear done")
                onClicked: {
                    remorse.execute(qsTr("Removing done entries"), clearDoneFromShoppingList);
                }
                RemorsePopup {id: remorse2 }
                function clearDoneFromShoppingList()
                {
                    applicationWindow.python.clearDone(itemType, listName)
                    initPage()
                }
            }
            MenuItem {
                text: qsTr("Add from picklist");
                onClicked: applicationWindow.controller.openAddPicklistDialog(listName);
            }
            MenuItem {
                text: qsTr("Add");
                onClicked: applicationWindow.controller.openAddDialog(listName,2);
            }
        }

        Notification {
            id: notification
            summary: qsTr("Copied to clipboard")
        }

        PushUpMenu {

            MenuItem {
                text: qsTr("Copy to clipboard");
                onClicked: {
                    if (listModel.count > 0) {
                      Clipboard.text = convertListToShareAble();
                      //notification.body = clip;
                      notification.publish()
                    }
                }
            }
            MenuItem {
                text: qsTr("Clear list")
                onClicked: {
                    remorse.execute(qsTr("Clearing all entries"), deleteShoppingList);
                }
                RemorsePopup {id: remorse }
                function deleteShoppingList()
                {
                    applicationWindow.python.clearAll(listPage.itemType, listName)
                    listModel.clear()
                }
            }
            MenuItem {
                text: qsTr("Delete this list")
                onClicked: {
                    remorse.execute(qsTr("Deleting shopping list"), deleteShoppingList);
                }
                RemorsePopup {id: remorse3 }
                function deleteShoppingList()
                {
                    applicationWindow.python.deleteList(listName,itemType)
                    applicationWindow.controller.signal_asset_updated(itemType) // this should reload list selector
                    pageStack.pop()
                }
            }
        }

        header: PageHeader {
            title: listName
        }


        ViewPlaceholder {
            enabled: listModel.count === 0
            text: qsTr("Oh dear, <br>nothing to shop ?!")
        }

        // have sections by category
        section {
            property: applicationWindow.settings.categorizeShoppingList ? "Category": ""
            criteria: ViewSection.FullString
            delegate: SectionHeader {
                id: secHead
                text: section
                font.pixelSize: Theme.fontSizeLarge
                height: li.menuOpen ? li.contextMenu.height + 100 : 100

                ListItem {
                  id: li
                  property Item contextMenu
                  property bool menuOpen: contextMenu != null// && contextMenu.parent === shoppingList

                  onPressAndHold: {
                    page.selectedCategory = secHead.text;
                    if (!contextMenu)
                        contextMenu = contextMenuComponent.createObject(shoppingList)
                    contextMenu.open(secHead) // not good but ..
                  }
                }
            }
        }

        Component {
            id: contextMenuComponent
            ContextMenu {
                id: menu
                MenuItem {
                    text: "Move up"
                    onClicked: {
                       DB.getDatabase().moveCategoryInShoppingList(page.selectedCategory, true);
                       page.selectedCategory = "";
                       page.updatePage();
                    }
                }
                MenuItem {
                    text: "Move down"
                    onClicked: {
                        DB.getDatabase().moveCategoryInShoppingList(page.selectedCategory, false);
                        page.selectedCategory = "";
                        page.updatePage();
                    }
                }
            }
        }


        delegate:
            ShoppingListItem {
                uid: Id
                name: Name
                amount: Amount
                unit: Unit
                checked: Done
                category: Category
                onToggled: {
                    console.log("item toggled received: "+ listPage.itemType + uid + name + checked )
                    applicationWindow.python.setDoneValue(listPage.itemType,listName,name,checked)
                    //applicationWindow.controller.updateCoverList(listName,listModel)
                }
                onPressed:
                {
                    console.log("item pressed received" + uid + name + mode )
                    // mode = 1 edit
                    if (mode === 1) {
                        var item = listModel.getElementByName(name)
                        applicationWindow.controller.openEditDialog(listName,mode,item)
                        return;
                    } //add
                    if (mode === 2) {
                        applicationWindow.controller.openAddDialog(listName,mode)
                        return
                    }
                    if (mode === 3) {
                        applicationWindow.python.deleteOne(listPage.itemType,listName,name)
                        var x = listModel.getElementIndexName(name)
                        if (x > -1) listModel.remove(x)
                    }
                }
        }


        ListModel {
            id: listModel
            ListElement {Id:""; Name: "dummy"; Amount: 1; Unit: "g"; Done: false; Category: ""; Order: "1" }

            function contains(uid) {
                for (var i=0; i< count; i++) {
                    if (get(i).uid === uid)  {
                        return [true, i];
                    }
                }
                return [false, i];
            }
            function getElementIndexName(name) {
                for (var i=0; i< count; i++) {
                    if (get(i).Name === name)  {
                        return i
                    }
                }
                return -1
            }
            function getElementByName(name) {
                var x = getElementIndexName(name)
                if (x == -1) return {}
                return get(x)
            }
        }

    }

}

