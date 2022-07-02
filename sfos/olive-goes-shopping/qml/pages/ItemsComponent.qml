import QtQuick 2.0
import Sailfish.Silica 1.0
import oarg.pawelspoon.olivegoesshopping.ogssettings 1.0

//this page shows items to shop
//each click increases howMany by 1
//longpress shows context menu with reset to 0
//swipe to left or right (cancel / ok) will store items to db and update shoppingList

SilicaListView {
// Dialog {
    id: page
    property string itemType

    anchors.fill: parent

    // value of search..
    property string searchString
    onSearchStringChanged: filterPage(searchString) //listModel.update()
    //Component.onCompleted: listModel.update()

    Component.onCompleted:
    {
        initPage()
    }

    function doAccept() {
        applicationWindow.page.initPage()
    }

    // user has rejected editing entry data, check if there are unsaved details
    function doReject() {
        applicationWindow.page.initPage()
    }

    function initPage()
    {
        var items = applicationWindow.python.getAssets(itemType);
        itemModel.clear()
        fillItemsModel(items)
    }

    function filterPage(nameFilter)
    {
        itemModel.clear()
        fillItemsModel(items)
    }

    function filterItemsModel(texti)
    {
        if (texti.length > 0) {
            filterPage(texti)
        } else {
            initPage()
        }
    }

    function fillItemsModel(items)
    {
        print('number of items: ' +  items.length)
        for (var i = 0; i < items.length; i++)
        {
            // print(items[i].uid + " " + items[i].name + " " + items[i].type + " " + " " + items[i].howMany + " " + items[i].category)
            itemModel.append({"uid": items[i].Id, "name": items[i].Name, "amount": items[i].Amount, "unit": items[i].Unit, "howMany": items[i].howMany, "type": items[i].type, "category": items[i].Category })
        }
        if (applicationWindow.settings.categorizeItems) {
            console.log('soring items')
            sortModel();
        }
    }

    function sortModel()
    {
        // not needed, done in db
        print("sorting")
        for(var i=0; i< itemModel.count; i++)
        {
            for(var j=0; j<i; j++)
            {
                // console.debug(shoppingModel.get(i).category)
                if(itemModel.get(i).category === itemModel.get(j).category)
                   itemModel.move(i,j,1)
                // break
            }
        }
    }

    Column {
        id: headerContainer
        width: parent.width

        SearchField {
            id: searchField
            width: parent.width
            opacity: 1

            Binding {
                target: page
                property: "searchString"
                value: searchField.text.toLowerCase().trim()
            }
        }
    }

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaListView {
        id: itemList
        model: itemModel
        anchors.fill: parent
        anchors.topMargin: searchField.height
        contentWidth: parent.width


        ViewPlaceholder {
            enabled: itemModel.count === 0 // show placeholder text when no locations/artists are tracked
            text: qsTr("No items")
        }

        // have sections by category
        // ExpandingSectionGroup and ExpandingSection might be better
        section {
            property: applicationWindow.settings.categorizeItems ? "category": ""
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


        delegate: ListItem {
            id: listItem

            StoreListItem {
                uid_: uid
                text: name
                amount_: amount
                unit_: unit
                type_: type
                howMany_: howMany
                category_: category
            }
        }


        ListModel {
            id: itemModel
            ListElement {uid: "123"; name: "dummy"; amount: 0; unit:""; howMany:0; type:"dummy"; category:""}

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

