//<license>

import QtQuick 2.2
import Sailfish.Silica 1.0

// alows the creation of an task or shopping list
Dialog {
    id: settings

    allowedOrientations: Orientation.All
    property string id : ""

    property string itemType : "shop" // shop/task
    property int mode // 0 read only 1 edit 2 create, not used here atm
    
    property var item

    property bool showCategory

    canAccept: itemName.text.len > 0

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
                // EnterKey.iconSource: "image://theme/icon-m-enter-next"
                font.capitalization: Font.MixedCase
                onTextChanged: {
                    settings.canAccept = text.length >= 3
                }
            }

            ComboBox {
                id: itemTypeCombo
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
                onCurrentIndexChanged: {
                    if (1==1) { //if (init) { // init might not be needed as no complex init fu
                        itemType = itemTypeCombo.value
                        print(itemType)
                        //items.itemType = itemTypeCombo.value
                        loadTemplateModel()
                    }
                }
            }

            ComboBox {
                id: prefil
                label: qsTr("Initial")
                menu: ContextMenu {
                    Repeater {
                        id: templateRepeater
                        model: templateModel
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
        ListElement { Name: "shop"; DisplayName: qsTr("shop") }
        ListElement { Name: "task"; DisplayName: qsTr("task") }
    }

    ListModel {
        id: templateModel
        ListElement { Name: "empty"; DisplayName: qsTr("empty list") }
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

    function loadTemplateModel()
    {
      // first entry is empty
      // then the template names
      // can use GetAssets (with task/shop)
      print(itemType)
      var items = applicationWindow.python.getAssets(itemType);
      // fill and store itemModel
      // used filtered one for the list// This is available in all editors.
      var firstEntry = templateModel.get(0)
      templateModel.clear()
      templateModel.append(firstEntry)
      templateModel.append(items)
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
        // commons.updateParentPage(itemType)
    }
    // user has rejected editing entry data, check if there are unsaved details
    onRejected: {
        //
    }
}
