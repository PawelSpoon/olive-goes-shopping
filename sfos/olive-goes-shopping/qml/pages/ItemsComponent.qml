import QtQuick 2.0
import Sailfish.Silica 1.0
import oarg.pawelspoon.olivegoesshopping.ogssettings 1.0

//this page shows items to shop
//each click increases howMany by 1
//longpress shows context menu with reset to 0
//swipe to left or right (cancel / ok) will store items to db and update shoppingList
// works with assets so unit and cat are refs no string

SilicaListView {
// Dialog {
    id: page
    property string listName
    // current combo box switch for asset types
    property string itemType

    anchors.fill: parent

    // value of search..
    property string searchString
    onSearchStringChanged: filterPage(searchString)

    Component.onCompleted:
    {

    }

    // this callback belongs to parent
    // same as the accept
    // this component should just visualize
    function update(id,name,itemType,category,amount,unit,howMany) {
        // check all items where howmany > 0
        for (var i = 0; i < itemModel.count; i++)
        {
            var item = itemModel.get(i)
            console.log(item.Name)
            if (item.Name === name) {
                item.HowMany = howMany
                itemModel.setProperty(i,"HowMany",howMany)
                break
            }
        }
        console.log(name + " not found in list")
        for (var j = 0; j < rawModel.count; j++) {
            var item = rawModel.get(j)
            console.log(item.Name)
            if (item.Name === name) {
                item.HowMany = howMany
                rawModel.setProperty(i,"HowMany",howMany)
                return
            }
        }
    }

    function collectCurrentItem(item)
    {
        var current = {}
        current['Id'] = item.Id
        current['Name']  = item.Name
        console.log(item.Name + " howm:" +item.HowMany + " amount" + item.Amount)
        current['Amount']  = item.HowMany * item.Amount
        current['Unit']  = item.Unit
        //current['Done']  = false
        current['Category']  = item.Category
        current['ItemType'] = item.ItemType
        return current;
    }

    function doAccept() {
        // in future we will store at once
        // so collect items that were changed and pass once to ..
        // how will that work with filter ?

        var list2Add = []
        console.log(itemModel.count)
        // check all items where howmany > 0
        for (var i = 0; i < rawModel.count; i++)
        {
            var item = rawModel.get(i)
            if (item.HowMany > 0) {
                var tmp = collectCurrentItem(item)
                //var addAmount = item.HowMany * item.Amount
                console.log("add amount:" + tmp.Amount)
                // category not needed
                //console.log(item.Name +  " " + item.Amount + item.Unit)
                //var tmp = {Id: item.Id, Name: item.Name, Amount: addAmount, Unit: item.Unit }
                list2Add.push(tmp)
            }
        }
        console.log(listName)
        console.log(list2Add.length)
        applicationWindow.python.addItem2ShoppingList(listName,list2Add)
        applicationWindow.controller.signal_list_updated(listName)
    }

    // user has rejected editing entry data, check if there are unsaved details
    function doReject() {
        applicationWindow.page.initPage()
    }

    // unfiltered model
    ListModel {
        id: rawModel
    }

    function initPage()
    {
        console.log("itemscomponent.initpage(): " + itemType)
        var items = applicationWindow.python.getAssets(itemType);
        // fill and store itemModel
        // used filtered one for the list// This is available in all editors.
        itemModel.clear()
        rawModel.clear()
        fillrawModel(items)
        fillItemsModel(undefined)
    }

    function filterPage(nameFilter)
    {
        itemModel.clear()
        fillItemsModel(nameFilter)
    }

    // rawModel contains all items
    // itemModel only those that should be visualized
    function fillrawModel(items)
    {
        print('number of items: ' +  items.length)
        for (var i = 0; i < items.length; i++)
        {
            var item = items[i]
            var unit = ""
            if (item.Unit !== undefined) {
                unit = item.Unit.Name
            }
            var cat = ""
            if (item.Category!== undefined) {
                cat = item.Category.Name
            }
            var tempItem = {"Id": item.Id,
                "Name": item.Name,
                "Amount": parseInt(item.Amount),
                "Unit": unit,
                "HowMany": items[i].HowMany,
                "ItemType": items[i].ItemType,
                "Category": cat}
            rawModel.append(tempItem)
        }
    }

    function fillItemsModel(nameFilter)
    {
        console.log('nameFilter:' + nameFilter)
        print('number of items: ' +  rawModel.count)
        console.log('rawModel contains :' + rawModel.count)
        for (var i = 0; i < rawModel.count; i++)
        {
            var tempItem = rawModel.get(i)
            if (nameFilter === undefined) {
                itemModel.append(tempItem)
            }
            else if (tempItem.Name.toString().match(nameFilter)) {
                console.log('including item')
                 itemModel.append(tempItem)
            }
        }
        /*if (applicationWindow.settings.categorizeItems) {
            console.log('sorting items')
            sortModel();
        }*/
        console.log('itemModel contains: ' + itemModel.count)
    }

    function sortModel()
    {
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
                id: _Id
                name: Name
                amount: Amount
                unit: Unit
                itemType: ItemType
                howMany: HowMany
                category: Category
                receiver: page
            }
        }


        ListModel {
            id: itemModel
            ListElement {Id: "123"; Name: "dummy"; Amount: 0; Unit:""; HowMany:0; ItemType:"dummy"; Category:""}

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

