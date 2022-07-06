import QtQuick 2.0
import Sailfish.Silica 1.0
import "../FishMongerDB.js" as FMB

Page {
    id: page

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All
    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent
        VerticalScrollDecorator {}

        PullDownMenu {
            MenuItem {
                text: qsTr("About")
                onClicked:
                {
                    pageStack.push(Qt.resolvedUrl("AboutDialog.qml"));
                }
            }
            MenuItem {
                text: qsTr("Settings")
                onClicked:
                {
                    pageStack.push(Qt.resolvedUrl("SettingPage.qml"));
                }
            }
            MenuItem {
                text: qsTr("Delete All Items")
                onClicked:
                {
                    pageStack.push(Qt.resolvedUrl("DeleteAllConfirmation.qml"));
                }
            }
            MenuItem {
                text: qsTr("Add Items")
                onClicked:
                {
                    pageStack.push(Qt.resolvedUrl("NewItemDialog.qml"))
                    console.log("Dialog exited")
                }
            }
        }


        // The effective value will be restricted by ApplicationWindow.allowedOrientations
        SilicaListView {
            id: listView
            model: listModel
            anchors.fill: parent
            header: PageHeader {
                title: qsTr("The Fish Monger's Shopping List")
            }
            delegate: ListItem {
                id: delegate

                Column
                {
                    id: checked_column
                    width: 80
                    IconButton
                    {
                        icon.source: (model.checked > 0 ?
                            "../images/icon-m-checked.png" :
                            "../images/icon-m-unchecked.png")
//                            "image://theme/icon-m-acknowledge" :
//                            "image://theme/icon-m-tabs")
                        onClicked:
                        {
                            console.log(id + ": Clicked " + model.checked);
                            FMB.ToggleCheckedItem(id);
                            FMB.ReadShoppingList(listModel, '');
                            FMB.ReadShoppingList(coverModel, 'checked = 0');
                        }
                    }
                }
                Column
                {
                    id: qty_column
                    width: 120
                    y: Theme.paddingLarge
                    anchors
                    {
                        left: checked_column.right
                        verticalCenter: checked_column.verticalCenter
                    }

                    Label {
                        x: Theme.horizontalPageMargin
                        // text: model.qty + " " + model.checked + " " + model.item + " :: " + model.order
                        text: model.qty
                        horizontalAlignment: Text.AlignLeft
//                        anchors.verticalCenter: parent.verticalCenter
                        color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                        width: parent.width
                        truncationMode: TruncationMode.Fade
                        font.strikeout: (model.checked > 0 && settings.strike_checked) ? true : false
                    }
                }
                Column
                {
                    id: spacing_column
                    width: 20
                    anchors
                    {
                        left: qty_column.right
                        verticalCenter: checked_column.verticalCenter
                    }

                    Label {
                        text: ""
                        color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                        font.strikeout: (model.checked > 0 && settings.strike_checked) ? true : false
                    }
                }
                Column
                {
                    id: item_column
                    width: 150
                    y: Theme.paddingLarge
                    anchors
                    {
                        left: spacing_column.right
                        verticalCenter: checked_column.verticalCenter
                    }

                    Label {
                        x: Theme.horizontalPageMargin
                        text: model.item
                        horizontalAlignment: Text.AlignLeft
//                        anchors.verticalCenter: parent.verticalCenter
                        color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                        truncationMode: TruncationMode.Fade
                        font.strikeout: (model.checked > 0 && settings.strike_checked) ? true : false
                    }
                }
//                onClicked: console.log(id + ": Clicked " + model.checked)
                onClicked:
                {
                    console.log(id + ": Clicked " + model.checked);
                    FMB.ToggleCheckedItem(id);
                    FMB.ReadShoppingList(listModel, '');
                    FMB.ReadShoppingList(coverModel, 'checked = 0');
                    coverView.refreshCover.onTriggered();
                }

                menu: ContextMenu {
                    MenuItem {
                        text: qsTr("Add Items")
                        onClicked:
                        {
                            pageStack.push(Qt.resolvedUrl("NewItemDialog.qml"))
                            console.log("Dialog exited")
                            FMB.ReadShoppingList(listModel, '');
                            FMB.ReadShoppingList(coverModel, 'checked = 0');
                        }
                    }
                    MenuItem {
                        text: qsTr("Delete Item")
                        onClicked:
                        {
                            FMB.DeleteItem(id);
                            FMB.ReadShoppingList(listModel, '');
                            FMB.ReadShoppingList(coverModel, 'checked = 0');
                        }
                    }
                    MenuItem {
                        text: qsTr("Edit Item")
                        onClicked:
                        {
                            FMB.ItemDesc = model.item
                            FMB.ItemQty = model.qty
                            FMB.ItemId = id
                            console.log("desc: " + model.item);
                            console.log("qty: " + model.qty);
                            console.log("id: " + id);
                            console.log("itemDesc: " + FMB.ItemDesc);
                            console.log("itemQty: " + FMB.ItemQty);
                            console.log("itemId: " + FMB.ItemId);
                            pageStack.push(Qt.resolvedUrl("EditItemDialog.qml"))
                            console.log("Dialog exited")
                            FMB.ReadShoppingList(listModel, '');
                            FMB.ReadShoppingList(coverModel, 'checked = 0');
                        }
                    }
                }
            }
            VerticalScrollDecorator {}
        }
    }
    Component.onCompleted: {
        console.log("first page started")
        console.log("1 strike_checked: " + settings.strike_checked)
        FMB.ReadShoppingList(listModel, '');
        FMB.ReadShoppingList(coverModel, 'checked = 0');
    }
}
