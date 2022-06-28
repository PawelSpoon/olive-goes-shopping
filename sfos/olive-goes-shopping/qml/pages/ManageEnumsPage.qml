import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.4

Dialog {

    id: page
    // property ItemsPage itemsPage
    // property FirstPage mainPage
    property string enumType

    allowedOrientations: defaultAllowedOrientations


    Component.onCompleted: {
        initPage()
    }

    onAccepted: {
        // itemsPage.initPage()
    }

    // user has rejected editing entry data, check if there are unsaved details
    onRejected: {
        // itemsPage.initPage()
    }

    function initPage()
    {
        var items = python.getItems()
        itemModel.clear()
        fillItemsModel(items)
    }

    function fillItemsModel(items)
    {
        print('number of items: ' +  items.length)
        for (var i = 0; i < items.length; i++)
        {
            print(items[i])
            itemModel.append({"uid": i, "name": items[i], "ordernr" : 0 })
        }
    }

    function updateCategoriesInShoppingList()
    {
        for (var i=0; i < itemModel.count; i++)
        {
            var current = itemModel.get(i);
            if (current.ordernr === 0) continue;
            DB.getDatabase().updateCategoryOrder(current.name, current.ordernr)
        }
    }

    ListModel {
        id: itemModel
        ListElement {uid: "123"; name: "dummy"; ordernr: 0}

        function contains(uid) {
            for (var i=0; i<count; i++) {
                if (get(i).uid === uid)  {
                    return [true, i];
                }
            }
            return [false, i];
        }
        function containsTitle(name) {
            for (var i=0; i<count; i++) {
                if (get(i).name === name)  {
                    return true;
                }
            }
            return false;
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
            console.log("eval:" + evaluate('len(initpythonenv.getController("category").getList())'))

        }


        function getItems()
        {
            return evaluate('initpythonenv.getController("category").getList()')
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

    // Place our content in a Column.  The PageHeader is always placed at the top
    // of the page, followed by our content.
    SilicaListView {
        id: itemList
        width: page.width
        height: page.height
        anchors.top: parent.top
        model: itemModel
        header: PageHeader { title: "Manage Store" }
        ViewPlaceholder {
            enabled: itemList.count == 0
            text: qsTr("Please fill store with items")
        }

        PushUpMenu {

            MenuItem {
                text: qsTr("Clear Categories Db")
                onClicked: {
                    remorse.execute("Deleting Categories db", cleanEnumsTable);
                }
                RemorsePopup {id: remorse }
                function cleanEnumsTable()
                {
                    DB.getDatabase().db.cleanTable("category")
                    initPage()
                }
            }

            MenuItem {
                text: qsTr("Import Categories Db")
                onClicked: {
                    DB.getDatabase().importCategoriesFromJson()
                    initPage()
                }
            }
        }

        PullDownMenu {

            MenuItem {
                text: qsTr("Update shopping list");
                onClicked: { updateCategoriesInShoppingList();}
            }

            MenuItem {
                text: qsTr("Add");
                onClicked: pageStack.push(Qt.resolvedUrl("EnumDialog.qml"), {itemType:enumType, itemsPage: page})
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
                removal.execute(contentItem, "Deleting", function() {
                    print("u:" + uid + ",n:"+name)
                    DB.getDatabase().removeEnum(enumType, uid);
                    itemModel.remove(index); }
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
                    //todo: edit already existing item
                    //pageStack.push(Qt.resolvedUrl("ItemDialog.qml"),
                    //               {uid_: uid, name_: name, itemType: type, itemsPage: page} )
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
                    text: name
                    anchors.left: typeIcon.right
                    anchors.leftMargin: Theme.paddingMedium
                    anchors.verticalCenter: parent.verticalCenter
                    font.capitalization: Font.Capitalize
                    truncationMode: TruncationMode.Elide
                    elide: Text.ElideRight
                    color: contentItem.down || menuOpen ? Theme.highlightColor : Theme.primaryColor
                }
                /*Label {
                    id: orderLabel
                    text: ordernr
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
                        text: qsTr("Delete");
                        onClicked: {
                            menu.parent.remove();
                        }
                    }
                    MenuItem {
                        text: qsTr("Move up");
                        onClicked: {
                            DB.getDatabase().moveCategory(name, true);
                            page.initPage();
                        }
                    }
                    MenuItem {
                        text: qsTr("Move down");
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




