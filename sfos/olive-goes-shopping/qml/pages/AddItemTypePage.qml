import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.5

/***********
  * add something to shoppinglist
  */

Dialog {

    id: page

    property string listType  // shop or task
    property bool sortable
    property bool groupbyCategory
    property bool neverCapitalize

    allowedOrientations: defaultAllowedOrientations

    Component.onCompleted: {
        commons.fillItemtypesModel(itemtypeModel)
        initPage()
    }

    onAccepted: {
        // add / remove items to / from
    }

    // user has rejected ing entry data, check if there are unsaved details
    onRejected: {
        // itemsPage.initPage()
    }

    ListModel {
        id: itemtypeModel
    }

    function initPage()
    {
        var items = applicationWindow.python.getAssets(enumType)
        itemModel.clear()
        fillItemsModel(items)
    }

    function fillItemsModel(items)
    {
        print('number of items: ' +  items.length)
        for (var i = 0; i < items.length; i++)
        {
            print(items[i].Name)
            itemModel.append({"Id": items[i].Id, "Name": items[i].Name, "Order" : items[i].Order, "Category": items[i].Category, "Item": items[i] })
        }
    }

    ListModel {
        id: itemModel
        //ListElement {Id: "123"; Name: "dummy"; Order: 0; Category: null; Item: null}

        function contains(uid) {
            for (var i=0; i<count; i++) {
                if (get(i).Id === uid)  {
                    return [true, i];
                }
            }
            return [false, i];
        }
        function containsTitle(name) {
            for (var i=0; i<count; i++) {
                if (get(i).Name === name)  {
                    return true;
                }
            }
            return false;
        }
    }



    // Place our content in a Column.  The PageHeader is always placed at the top
    // of the page, followed by our content.
    SilicaListView {
        id: itemList
        width: page.width
        height: page.height
        anchors.top: parent.top
        model: itemModel
        header: PageHeader { title: qsTr("Manage ") + qsTr(enumType) }
        ViewPlaceholder {
            enabled: itemList.count == 0
            text: qsTr("Add or import items")
        }
        Column {

            ComboBox {
                id: itemType
                label: qsTr("Item type")
                menu: ContextMenu {
                    Repeater {
                        id: itemTypeRepeater
                        model: itemModel
                        MenuItem {
                            text: Name
                        }
                    }

                }
                onCurrentIndexChanged: {
                    items.itemType = itemType.value
                }
            }

        // here searchfield

        // list result with
        ItemsComponent {
            id: items
            //itemType:
        }
    }

    }
}

