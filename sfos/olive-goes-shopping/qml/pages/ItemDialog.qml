//<license>

import QtQuick 2.2
import Sailfish.Silica 1.0
//import QtQuick.Controls 2.0

Dialog {
    id: settings

    // The effective value will be restricted by ApplicationWindow.allowedOrientations
    allowedOrientations: Orientation.All
    property string id : ""

    property string itemType
    property int mode
    //property alias name_ : itemName.text

    //property alias amount_ : defaultAmount.text
    //property string unit_
    //property alias category_ : categoryName.text

    property var item

    SilicaFlickable{

        id: settingsFlickable
        onActiveFocusChanged: print(activeFocus)
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: col.height

        ListModel {
            id: categoryModel
            //ListElement {Id:""; Name: "dummy" }
        }

        ListModel {
            id: unitModel
        }




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
                text: { if (mode === 2) qsTr("New item")
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
                font.capitalization: applicationWindow.controller.getCapitalization();//Font.MixedCase
                EnterKey.onClicked: defaultAmount.focus = true
            }

            TextField {
                id: defaultAmount
                width: parent.width
                inputMethodHints: Qt.ImhDigitsOnly
                label: qsTr("Standard package size")
                text: ""
                placeholderText: qsTr("Set standard package size")
                errorHighlight: text.length === 0 // not mandatory
                EnterKey.enabled: !errorHighlight
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: unit.focus = true
            }

            ComboBox {
                id: unit
                label: qsTr("Unit")
                menu: ContextMenu {
                    Repeater {
                        id: unitRepeater
                        model: unitModel
                        MenuItem {
                            text: Name
                        }
                    }
                }
            }

            ComboBox {
                id: categoryCombo
                label: qsTr("Category")
                menu: ContextMenu {
                    Repeater {
                        id: catRepeater
                        model: categoryModel
                        MenuItem {
                            text: Name
                        }
                    }
                }
            }


            TextField {
                id: co2
                width: parent.width
                inputMethodHints: Qt.ImhDigitsOnly
                label: qsTr("co2 in []")
                text: ""
                placeholderText: qsTr("Set co2 footprint")
                errorHighlight: text.length === 0 // not mandatory
                EnterKey.enabled: !errorHighlight
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: unit.focus = true
            }

        }
    }



    Component.onCompleted: {

        unitModel.clear()
        categoryModel.clear()
        commons.fillUnitModel(unitModel)
        commons.fillCategoryModel(categoryModel)

        if (mode == 1) {
           send2Controlls()
        }
    }

    function send2Controlls() {
        itemName.text = item['Name']
        defaultAmount.text = item['Amount']
        var index =  commons.getIndexForItem(item['Unit'], unitModel)
        unit.currentIndex  = index
        categoryCombo.currentIndex = commons.getIndexForItem(item['Category'], categoryModel)
    }


    Component.onDestruction: {

    }

    AssetCommons {
        id: commons
    }

    function collectCurrentItem()
    {
        var current = {}
        current['Id'] = id
        current['Name']  = itemName.text
        current['Amount']  = defaultAmount.text
        current['Unit']  = commons.getUnit(unit.value, unitModel)
        current['Category']  = commons.getUnit(categoryCombo.value, categoryModel)
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
