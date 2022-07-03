
import QtQuick 2.0
import Sailfish.Silica 1.0
import oarg.pawelspoon.olivegoesshopping.ogssettings 1.0
import Nemo.Notifications 1.0
//import Sailfish.Share 1.0


Page {
    id: shoppingListPage
    property string selectedCategory
    property string listName

    // The effective value will be restricted by ApplicationWindow.allowedOrientationso
    allowedOrientations: Orientation.All

    Component.onCompleted:
    {
        initPage();
    }

    function updatePage()
    {
        // shoppinglistitem does update the value in db but not in the model
        // as a workaround i need to initpage

        // print('updatePage')
        // i might need to update the item too
        // applicationWindow.updateCoverList(shoppingModel)
        initPage()
    }


    function update(id,name,itemType,category,amount,unit,done) {
        // check all items where howmany > 0
        for (var i = 0; i < shoppingModel.count; i++)
        {
            var item = shoppingModel.get(i)
            console.log(item.Name)
            if (item.Name === name) {
                console.log(done)
                //shoppingModel.setProperty(i,"HowMany",howMany)
                shoppingModel.setProperty(i,"Done",done)
                applicationWindow.python.setDoneValue(listName,name,done)
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
        for(var i=0; i< shoppingModel.count; i++)
        {
          console.debug(shoppingModel.get(i).Name)
          if(shoppingModel.get(i).Name === name) {
            shoppingModel.get(i).Done = true;
            break
          }
        }
    }

    // currently not used by should be from ShoppingListItem to inform
    function markAsDone(uid,name,amount,unit,category,done)
    {
        applicationWindow.python.setDoneValue(listName,done)
        initPage()
    }

    function initPage()
    {
        var items = applicationWindow.python.getShoppingList(listName)
        shoppingModel.clear()
        fillShoppingListModel(items)
        //applicationWindow.updateCoverList(shoppingModel)
    }



    function fillShoppingListModel(items)
    {
        print('number of items: ' +  items.length)
        for (var i = 0; i < items.length; i++)
        {
            shoppingModel.append({"Id": items[i].Id,
                                 "Name": items[i].Name,
                                 "Amount": items[i].Amount,
                                 "Unit": items[i].Unit,
                                 "Done": items[i].Done,
                                 "ItemType": items[i].ItemType,
                                 "Category": items[i].Category })
        }

        sortModel();
    }

    function sortModel()
    {
        // not needed, done in db
        print("sorting")
        for(var i=0; i< shoppingModel.count; i++)
        {
            for(var j=0; j<i; j++)
            {
                // console.debug(shoppingModel.get(i).category)
                if(shoppingModel.get(i).category === shoppingModel.get(j).category)
                   shoppingModel.move(i,j,1)
                // break
            }
        }
    }

    // converts shopping list to shareable string
    function convertListToShareAble()
    {
        var listToShare = "";
        for (var i=0; i< shoppingModel.count; i++) {
            var oneItemAsString = shoppingModel.get(i).Name + " " + shoppingModel.get(i).Amount
            listToShare += "\n" + oneItemAsString // here newline instead
        }
        return listToShare;
    }

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaListView {
        id: shoppingList
        anchors.fill: parent
        model: shoppingModel
        VerticalScrollDecorator { flickable: shoppingList }

        PullDownMenu {
            MenuItem {
                text: qsTr("Clear")
                onClicked: {
                    remorse.execute(qsTr("Deleting shopping list"), deleteShoppingList);
                }
                RemorsePopup {id: remorse }
                function deleteShoppingList()
                {
                    applicationWindow.python.clearAll(listName)
                    shoppingModel.clear()
                }
            }
            MenuItem {
                text: qsTr("Clear done")
                onClicked: {
                    remorse.execute(qsTr("Removing done entries"), clearDoneFromShoppingList);
                }
                RemorsePopup {id: remorse2 }
                function clearDoneFromShoppingList()
                {
                    applicationWindow.python.clearDone(listName)
                }
            }
            MenuItem {
                text: qsTr("Add from picklist");
                onClicked: applicationWindow.controller.openAddPicklistDialog(listName);
            }
            MenuItem {
                text: qsTr("Add");
                onClicked: applicationWindow.controller.openAddDialog(listName);
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
                    if (shoppingModel.count > 0) {
                      Clipboard.text = convertListToShareAble();
                      //notification.body = clip;
                      notification.publish()
                    }
                }
            }
            /*MenuItem {
                text: qsTr("Share")
                ShareAction {
                    id: share
                    title: qsTr("Share shopping list")
                    mimeType: "text/x-"
                }
                onClicked: {
                    if (shoppingModel.count > 0)
                    {
                        var listToShare = convertListToShareAble();
                        var mimeType = "text/x-url";
                        var he = {}
                        he.data = listToShare
                        he.name = "Buy this"
                        he.type = mimeType
                        he["linkTitle"] = listToShare// works in email body
                        share.mimeType = "text/x-url";
                        share.resources = [he]
                        share.trigger()

                        share.resources = ["listToShare"]
                        share.trigger()
                    }
                }
                //todo: else log do nothing
            }*/
            MenuItem {
                text: qsTr("Manage")
                onClicked: {
                    controller.openManagePage();
                }
            }
            /*MenuItem {
                text: qsTr("Help")
                onClicked: {
                    controller.openHelpPage();
                }
            }
            MenuItem {
                text: qsTr("About")
                onClicked: {
                    controller.openAboutPage();
                }
            }*/
        }

        header: PageHeader {
            title: qsTr("Shopping List - " + listName)
        }


        ViewPlaceholder {
            enabled: shoppingModel.count === 0
            text: qsTr("Oh dear, <br>nothing to shop ?!")
        }

        // have sections by category
        section {
            property: applicationWindow.settings.categorizeShoppingList ? "category": ""
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
            receiver: shoppingListPage
            // order_: order
        }


        ListModel {
            id: shoppingModel
            ListElement {Id:""; Name: "dummy"; Amount: 1; Unit: "g"; Done: false; Category: ""; Order: "1" }

            function contains(uid) {
                for (var i=0; i<count; i++) {
                    if (get(i).uid === uid)  {
                        return [true, i];
                    }
                }
                return [false, i];
            }
        }

    }

}

