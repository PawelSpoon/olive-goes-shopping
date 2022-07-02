import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.5

/***********
  * generic list mgmt dialog for everything
  * application controller will open the proper detail windows based on provided enumType
  * 'everything' is currently limited by the calls to delete an item, clear all..
  * it must be within assetmanagers context
  * could be replaced by introduction of an interface and injecting object later ?
  * can work with something like that: { Id: "123"; Name: "dummy"; Order: 0; Category: null; Item: null}
  */

Dialog {

    id: page

    property string enumType
    property bool readonly
    property bool sortable
    property bool groupbyCategory
    property bool neverCapitalize

    allowedOrientations: defaultAllowedOrientations

    Component.onCompleted: {
        initPage()
        applicationWindow.controller.signal_asset_updated.connect(onAssetChanged)
    }

    // callback from e.g dialog pages
    function onAssetChanged(itemType) {
        // throws unknown33 initPage of object is not a ...
        //page.initPage() did not work either
        initPage()
    }

    onAccepted: {
        // itemsPage.initPage()
    }

    // user has rejected ing entry data, check if there are unsaved details
    onRejected: {
        // itemsPage.initPage()
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

        PushUpMenu {

            MenuItem {
                text: qsTr("Clear all")
                visible: ! readonly
                onClicked: {
                    remorse.execute(qsTr("Deleting all"), cleanEnumsTable);
                }
                RemorsePopup {id: remorse }
                function cleanEnumsTable()
                {
                    applicationWindow.python.clearAssets(enumType)
                    initPage()
                }
            }

            MenuItem {
                text: qsTr("Import example items")
                visible: !readonly
                onClicked: {
                    //todo:
                    console.log('not implemented')
                    initPage()
                }
            }
        }

        PullDownMenu {

            MenuItem {
                text: qsTr("Add");
                visible: !readonly
                onClicked: applicationWindow.controller.openMgmtDetailPage(enumType, 2, {})
            }

        }
        VerticalScrollDecorator {}

        delegate: Item {
            id: myListItem
            property bool menuOpen: contextMenu != null && contextMenu.parent === myListItem
            property int myIndex: index
            property Item contextMenu

            width: ListView.view.width
            height: menuOpen ? contextMenu.height + contentItem.height : contentItem.height

            function remove() {
                var removal = removalComponent.createObject(myListItem)
                ListView.remove.connect(removal.deleteAnimation.start)
                removal.execute(contentItem, qsTr("Deleting"), function() {
                    // is that a limitation  ?
                    applicationWindow.python.deleteAsset(enumType,Name)
                    itemModel.remove(index); 
                    // should be moved to python handler or ..
                    applicationWindow.controller.updateParentPage(enumType)
                    }
                )
            }

            BackgroundItem {
                id: contentItem

                width: parent.width
                onPressAndHold: {
                    if (!contextMenu)
                        contextMenu = contextMenuComponent.createObject(itemList)
                    contextMenu.open(myListItem)
                }
                onClicked: {
                    //console.log("Clicked " + title)
                    //todo:  could expand here to show more details
                 }
                Image {
                    id: typeIcon
                    anchors.left: parent.left
                    anchors.leftMargin: Theme.paddingSmall
                    source: {
                        if (true) "image://theme/icon-l-copy"
                        else "image://theme/icon-m-levels"
                    }
                    height: parent.height
                    width: height
                }
                Label {
                    id: nameLabel
                    text: Name
                    anchors.left: typeIcon.right
                    anchors.leftMargin: Theme.paddingMedium
                    anchors.verticalCenter: parent.verticalCenter
                    font.capitalization: Font.Normal
                    truncationMode: TruncationMode.Elide
                    elide: Text.ElideRight
                    color: contentItem.down || menuOpen ? Theme.highlightColor : Theme.primaryColor
                }
                /*Label {
                    id: orderLabel
                    text: order
                    anchors.left: nameLabel.right
                    anchors.leftMargin: Theme.paddingMedium
                    //anchors.verticalCenter: parent.verticalCenter
                    fontSizeMode: Theme.fontSizeTiny
                    truncationMode: TruncationMode.Elide
                    elide: Text.ElideRight
                    color: contentItem.down || menuOpen ? Theme.highlightColor : Theme.primaryColor
                }*/
            }

            Component {
                id: removalComponent
                RemorseItem {
                    property QtObject deleteAnimation: SequentialAnimation {
                        PropertyAction { target: myListItem; property: "ListView.delayRemove"; value: true }
                        NumberAnimation {
                            target: myListItem
                            properties: "height,opacity"; to: 0; duration: 300
                            easing.type: Easing.InOutQuad
                        }
                        PropertyAction { target: myListItem; property: "ListView.delayRemove"; value: false }
                    }
                    onCanceled: destroy()
                }
            }
            Component {
                id: contextMenuComponent
                ContextMenu {
                    id: menu
                    MenuItem {
                        text: qsTr("Edit");
                        visible: !readonly
                        onClicked: {
                            var temp = itemModel.get(index).Item
                            applicationWindow.controller.openMgmtDetailPage(enumType, 1, temp)
                        }
                    }
                    MenuItem {
                        text: qsTr("Delete");
                        visible: !readonly
                        onClicked: {
                            menu.parent.remove();
                        }
                    }
                    MenuItem {
                        text: qsTr("Move up");
                        visible: sortable
                        onClicked: {
                            DB.getDatabase().moveCategory(name, true);
                            page.initPage();
                        }
                    }
                    MenuItem {
                        text: qsTr("Move down");
                        visible: sortable
                        onClicked: {
                            DB.getDatabase().moveCategory(name, false);
                            page.initPage();
                        }
                    }
                }
            }
        }
    }
}




