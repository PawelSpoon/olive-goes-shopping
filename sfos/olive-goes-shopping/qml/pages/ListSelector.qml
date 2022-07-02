import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.5

Page {

    id: page

    ListModel {
        id: shoppingLists
    }

    Component.onCompleted: {
        applicationWindow.controller.signal_asset_updated.connect(onAssetChanged)

    }

    function onAssetChanged(itemType) {
        // throws unknown33 initPage of object is not a ...
        //page.initPage() did not work either
        load()
    }

    function load() {
        shoppingLists.clear()
        var lis = applicationWindow.cache.getShoppingLists()
        var lists = lis['Name']
        for (var i = 0; i < lists.length ; i++) {
            console.log(lists[i])
            shoppingLists.append({"Name": lists[i], "Id": 1})
        }
    }



    SilicaFlickable {
        id: shoppingList
        anchors.fill: parent
        contentHeight: buttonColumn.height * 2

        VerticalScrollDecorator {  }

        PageHeader {
            title: qsTr("My lists")
        }

        ViewPlaceholder {
            enabled: shoppingLists.length === 0
            text: qsTr("Create a shopping or task list from pull down menu")
        }

        PullDownMenu {

            MenuItem {
                text: qsTr("Add");
                onClicked: applicationWindow.controller.openCreateListDialog()
            }

        }        

        Column {
            id: buttonColumn
            width: parent.width
            spacing: Theme.horizontalPageMargin
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: Theme.paddingLarge * 3 * Theme.pixelRatio

            Repeater {
                id: itemTypeRepeater
                model: shoppingLists
                Button {
                    text: Name
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked:  applicationWindow.controller.openShoppingListPage(text)
                }
                }
            /*Label {
                enabled: true
                height: Theme.horizontalPageMargins
            }*/

        }


    PushUpMenu {

        MenuItem {
            text: qsTr("Manage");
            onClicked: {
                 onClicked: applicationWindow.controller.openManageMainPage();
           }
        }
    }

    }

}


