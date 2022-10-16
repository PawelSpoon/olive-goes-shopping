import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.5

Page {

    id: page
    property string itemType

    ListModel {
        id: shoppingLists
    }

    Component.onCompleted: {
        applicationWindow.controller.signal_asset_updated.connect(onAssetChanged)
        load()
    }

    function onAssetChanged(itemType) {
        // throws unknown33 initPage of object is not a ...
        //page.initPage() did not work either
       load()
    }

    function load() {
        shoppingLists.clear()
        console.log(itemType)
        var lists = applicationWindow.python.getTemplates(itemType)
        console.log(lists)
        // var lists = lis['Name']
        for (var i = 0; i < lists.length ; i++) {
            console.log(lists[i].Name)
            shoppingLists.append({"Name": lists[i].Name, "Id": 1})
        }
    }



    SilicaFlickable {
        id: shoppingList
        anchors.fill: parent
        //contentHeight: buttonColumn.height * 2

        VerticalScrollDecorator {  }

        PageHeader {
            title: qsTr("My templates")
        }

        ViewPlaceholder {
            enabled: shoppingLists.length === 0
            text: qsTr("Create a shopping or task list from pull down menu")
        }

        PullDownMenu {

            MenuItem {
                text: qsTr("Add");
                onClicked: applicationWindow.controller.openTemplatePage(itemType,2)
            }

        }        

        Column {
            id: buttonColumn
            width: parent.width
            spacing: Theme.horizontalPageMargin
            anchors.horizontalCenter: parent.horizontalCenter
            //anchors.topMargin: Theme.paddingLarge * 3 * Theme.pixelRatio
            anchors.verticalCenter: parent.verticalCenter

            Repeater {
                id: itemTypeRepeater
                model: shoppingLists
                Button {
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: Name
                    onClicked:  {
                        var listName = text
                        console.log(listName)
                        applicationWindow.controller.openTemplatePage(itemType,1, listName)
                    }
                }
            }
            /*Label {
                enabled: true
                height: Theme.horizontalPageMargins
            }*/

        }


    PushUpMenu {

        /*MenuItem {
            text: qsTr("Manage");
            onClicked: {
                 onClicked: applicationWindow.controller.openManageMainPage();
           }
        }*/
    }

    }

}


