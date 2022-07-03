import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.5

/***********
  * add something to shoppinglist
  */

Dialog {

    id: page

    property string listType  // shop or task
    property string itemType  // the filter
    property string listName
    property bool sortable
    property bool groupbyCategory
    property bool neverCapitalize

    PageHeader {
        id: pageHeader
        title: 'add xxx'
    }

    AssetCommons {
        id:commons
    }

    allowedOrientations: defaultAllowedOrientations

    Component.onCompleted: {

        initPage()
    }

    onAccepted: {
        // add / remove items to / from
        items.doAccept()
    }

    // user has rejected ing entry data, check if there are unsaved details
    onRejected: {
        // itemsPage.initPage()
    }


    function initPage()
    {
        console.log("listName: " + listName)

        // fill combo list
        itemTypeModel.clear()
        commons.fillItemtypesModel(itemTypeModel)
        console.log(itemTypeModel.length)
        // check that provided (or not provided) itemtype exist
        var index = commons.getIndexForName(itemType,itemTypeModel)
        console.log(index,itemType)
        if (index == -1) {index = 0}
        // set combo to an existing value and use that to populate the list
        itemTypeCombo.currentIndex = index
        // will be synced in combo
        //itemType = commons.getUnit(..
        console.log(index, itemType)
        //var items = applicationWindow.cache.getItemsOfType(itemType)
        items.itemType = itemType
        items.listName = listName
        items.initPage()
    }




    // Place our content in a Column.  The PageHeader is always placed at the top
    // of the page, followed by our content.
    SilicaFlickable {
        id: itemList
        width: page.width
        height: page.height
        anchors.top: parent.top

        ViewPlaceholder {
            enabled: itemList.count == 0
            text: qsTr("Add or import items")
        }

        ListModel {
            id: itemTypeModel
        }

        Column {
            anchors.fill: parent
            ComboBox {
                id: itemTypeCombo
                label: qsTr("Item type")
                anchors.topMargin: itemTypeCombo.height
                menu: ContextMenu {
                    Repeater {
                        id: itemTypeRepeater
                        model: itemTypeModel
                        MenuItem {
                            text: Name
                        }
                    }

                }
                onCurrentIndexChanged: {
                    items.itemType = itemTypeCombo.value
                    items.initPage()
                }
            }

            // list result with
            ItemsComponent {
                id: items
                listName: listName
                anchors.fill: parent
                anchors.topMargin: itemTypeCombo.height
                width: parent.width
            }
         }

    }
}

