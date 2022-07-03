//<license>

import QtQuick 2.2
import Sailfish.Silica 1.0

// alows the creation of an task or shopping list
Dialog {
    id: settings

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All
    property string id : ""

    property string itemType : "shop" // shop/task
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
                text: qsTr("New list")
                font.pixelSize: Theme.fontSizeLarge
                anchors.left: parent.left
                anchors.leftMargin: Theme.paddingLarge
            }

            TextField {
                id: itemName
                width: parent.width
                inputMethodHints: Qt.ImhSensitiveData
                label: qsTr("List name")
                text: ""
                placeholderText: qsTr("Set name")
                errorHighlight: text.length === 0
                EnterKey.enabled: !errorHighlight
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                font.capitalization: Font.MixedCase
                //EnterKey.onClicked: defaultAmount.focus = true
            }

            ComboBox {
                id: unit
                label: qsTr("Type")
                menu: ContextMenu {
                    Repeater {
                        id: typeRepeater
                        model: typeModel
                        MenuItem {
                            text: DisplayName
                        }
                    }
                }
            }
        }
    }

    ListModel {
        id: typeModel
        ListElement { Name: "shop"; DisplayName: qsTr("shopping list") }
        ListElement { Name: "task"; DisplayName: qsTr("tasklist ") }
    }

    Component.onCompleted: {
       if (item === null) {
           item = { Id: null, Category: null, Order: 0}
       }
       if (mode == 1) { // edit
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
        applicationWindow.controller.createList(itemName.text, itemType)
        // currenly called by controller:
        // bcommons.updateParentPage(itemType)
    }
    // user has rejected editing entry data, check if there are unsaved details
    onRejected: {
        // no need for saving if input fields are invalid
        if (canNavigateForward) {
            // ?!
        }
    }
}
