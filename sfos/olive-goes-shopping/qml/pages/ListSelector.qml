import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.5

Page {

    id: page

    ListModel {
        id: shoppingLists
    }

    Component.onCompleted: {
        // hack for now
        /*shoppingLists.clear()
        var lists = applicationWindow.cache.getShoppingLists()
        console.log(lists.length)
        for (var i = 0; i < lists.length; i++) {
          shoppingLists.append({"Name": lists[i].Name})
        }*/
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

    SilicaListView {
        id: shoppingList
        anchors.fill: parent
        height: page.height
        width: page.width
        anchors.topMargin: Theme.paddingLarge * 2 * Theme.pixelRatio


        VerticalScrollDecorator {  }

        header: PageHeader {
            title: qsTr("Shopping List")
        }
        ViewPlaceholder {
            enabled: shoppingLists.length === 0
            text: qsTr("Create a shopping list in 'Manage' page")
        }

        Column {
            width: parent.width
            spacing: Theme.horizontalPageMargin
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter

            Repeater {
                id: itemTypeRepeater
                model: shoppingLists
                Button {
                    text: Name
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked:  applicationWindow.controller.openShoppingListPage(text)
                }               
            }
            Label {
                enabled: true
                height: Theme.horizontalPageMargins
            }

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


