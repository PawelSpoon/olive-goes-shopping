import QtQuick 2.0
import Sailfish.Silica 1.0
import "../pages"

CoverBackground {

    id: coverPage
    property string listName

    function fillModel(currentListName,items)
    {
        // filter out strike-through items, show only open ones
        header.text = currentListName
        listName = currentListName
        print(items.count)
        shoppingListModel.clear()
        var maxcount = 7
        if (items.count < maxcount) maxcount = items.count
        if (maxcount === 0) { label.visible = true; return } // show Olive goes shoppin again
        label.visible = false; // hide Olive goes shoppin
        for (var i = 0; i < items.count; i++)
        {            
            var uid = items.get(i).Id
            var name = items.get(i).Name
            var amount = items.get(i).Amount
            var unit = items.get(i).Unit
            var done = items.get(i).Done
            var category = items.get(i).category
            if (!done) shoppingListModel.append({"uid": uid, "name": name, "amount": amount, "unit": unit, "done":done, "category":category });
            console.debug(uid + " " + name + " " + amount + " " + unit + " " + done + " " + category)
            if (shoppingListModel.count === maxcount) break
        }
        if (shoppingListModel.count > maxcount) {
            shoppingListModel.append({"name": ".."});
        }
        else if (shoppingListModel.count == 0) {
            label.visible = true;
        }
    }

    function markFirstAsDone()
    {
        if (shoppingListModel.count == 0) return;
        var item = shoppingListModel.get(0);
        var uid = shoppingListModel.get(0).uid
        var name = shoppingListModel.get(0).name
        var amount = shoppingListModel.get(0).amount
        var unit = shoppingListModel.get(0).unit
        var done = shoppingListModel.get(0).done
        var category = shoppingListModel.get(0).category
        if (controller == null)
            controller = applicationWindow.page
        controller.markAsDone(uid,name,amount,unit,category,true)
    }

    Image {
        id: imgcover
        source: "./olive-goes-shopping-cover-image.jpeg"
        asynchronous: true
        opacity: 0.1
        width: parent.width
        height: parent.height
        anchors.horizontalCenter: parent.horizontalCenter
    }
    Label {
        id: label
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 2 * Theme.paddingLarge
        /*text: qsTr("Olive
goes
 shoppin'")*/
        text: qsTr("Olive <br>\
goes <br>\
 shoppin'")
    }

    ListModel {
        id: shoppingListModel
    }
    Label {
        id: header
        text: ''
        anchors.top: coverPage.top
        anchors.topMargin: Theme.paddingLarge
        anchors.right: coverPage.right
        anchors.rightMargin: Theme.paddingMedium
        color: Theme.highlightColor
    }


    SilicaListView  {
        id: events
        model: shoppingListModel
        width: parent.width
        anchors.fill: parent
        anchors.topMargin: 100
        anchors.leftMargin: Theme.paddingMedium

        delegate: Item {
            id: myListItem
            width: ListView.view.width
            height: 65

            BackgroundItem {
                id: contentItem
                width: parent.width

                Label {
                    id: titleText
                    text: name
                    anchors.leftMargin: Theme.paddingLarge * 2
                    anchors.verticalCenter : parent.verticalCenter
                    //anchors.topMargin:  Theme.paddingSmall
                    //font.capitalization: Font.Capitalize
                    font.pixelSize: Theme.fontSizeSmall
                    font.bold: false
                    font.strikeout: done === true
                    truncationMode: TruncationMode.Fade
                    elide: Text.ElideRight
                    color: Theme.primaryColor
                }
            }
        }

    }

    CoverActionList {
        id: coverAction

        // keep alive
       /* CoverAction {
            iconSource: applicationWindow.on ? "image://theme/icon-cover-pause" : "image://theme/icon-cover-play"
            onTriggered: {
                applicationWindow.on = !applicationWindow.on
                console.log("keep alive: " + applicationWindow.on)
            }
        }

        // strike through the first item
        // https://sailfishos.org/develop/docs/jolla-ambient/
        CoverAction {
            iconSource: "image://theme/icon-m-acknowledge"
            onTriggered: markFirstAsDone()
        }

        CoverAction {
            iconSource: "image://theme/icon-cover-new"
            onTriggered: {
                if (controller == null)
                    controller = applicationWindow.page
                applicationWindow.activate()
                applicationWindow.controller.openAddDialog(listName,1) // openInEditMode
            }
        }*/
    }
}
