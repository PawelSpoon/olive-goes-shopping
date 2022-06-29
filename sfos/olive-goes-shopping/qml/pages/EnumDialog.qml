//<license>

import QtQuick 2.2
import Sailfish.Silica 1.0

// alows the creation and edit of an Enum items
// everything that has just a name and maybe a category and may be ordered
// will be triggered from ManageEnumsPage
Dialog {
    id: settings

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All
    property string id : ""

    property string itemType // type == tablename where enum is stored
    property int mode
    property alias name_ : itemName.text // enum value
    
    property var item

    property bool showCategory

    SilicaFlickable{

        id: settingsFlickable
        onActiveFocusChanged: print(activeFocus)
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: col.height

        // Show a scollbar when the view is flicked, place this over all other content
        VerticalScrollDecorator {}

        Column {
            id: col
            width: parent.width
            spacing: Theme.paddingLarge

            DialogHeader {
                acceptText: qsTr("Save")
                cancelText: qsTr("Discard")
            }

            Label {
                text: { if (id === "") qsTr("New item")
                        else qsTr("Edit item") }
                font.pixelSize: Theme.fontSizeLarge
                anchors.left: parent.left
                anchors.leftMargin: Theme.paddingLarge
            }

            TextField {
                id: itemName
                width: parent.width
                inputMethodHints: Qt.ImhSensitiveData
                label: qsTr("Item name")
                text: ""
                placeholderText: qsTr("Set item name")
                errorHighlight: text.length === 0
                EnterKey.enabled: !errorHighlight
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                font.capitalization: Font.MixedCase
                //EnterKey.onClicked: defaultAmount.focus = true
            }

            TextField {
                id: category
                visible: showCategory
                width: parent.width
                inputMethodHints: Qt.ImhSensitiveData
                label: qsTr("Item name")
                text: ""
                placeholderText: qsTr("Set item name")
                errorHighlight: text.length === 0
                EnterKey.enabled: !errorHighlight
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                font.capitalization: Font.MixedCase
                EnterKey.onClicked: defaultAmount.focus = true
            }
        }
    }

    Component.onCompleted: {
       if (item == null) {
           item = { Id: null, Category: null, Order: 0}
       }
       else {
           name_ = item.Name
           id = item.Id
       }
    }

    Component.onDestruction: {

    }

    onAccepted: {
        // save to db and reload the prev page to make the new item visible
        var oldName = item['Name']
        if (oldName === undefined || oldName === null || oldName === '') oldName = name_
        if (id == "" ) id = applicationWindow.controller.getUniqueId()
        // var orderNr = DB.getDatabase().db.executeSelect("select max(ordernr) from category");
        // here i could check old and new name for rename :)
        item['Name'] = name_
        item['Id'] = id
        if (mode == 1) applicationWindow.pythonController.updateAsset(itemType, oldName, item)
        if (mode == 2) applicationWindow.pythonController.addAsset(itemType, item)
        //itemsPage.initPage()
    }
    // user has rejected editing entry data, check if there are unsaved details
    onRejected: {
        // no need for saving if input fields are invalid
        if (canNavigateForward) {
            // ?!
        }
    }
}
