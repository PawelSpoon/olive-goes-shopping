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
    //property alias name_ : itemName.text // enum value
    
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

        AssetCommons {
            id: commons
        }

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
       if (item === null) {
           item = { Id: null, Category: null, Order: 0}
       }
       else {
           itemName.text = item.Name
           id = item.Id
       }
    }

    Component.onDestruction: {

    }

    function collectCurrentItem()
    {
        var current = {}
        current['Id'] = id
        current['Name']  = itemName.text
        return current;
    }

    onAccepted: {
        // itemType,mode,oldItem, currentItem
        commons.onAccept(itemType, mode, item, collectCurrentItem())
        commons.updateParentPage(itemType)
    }
    // user has rejected editing entry data, check if there are unsaved details
    onRejected: {
        // no need for saving if input fields are invalid
        if (canNavigateForward) {
            // ?!
        }
    }
}
