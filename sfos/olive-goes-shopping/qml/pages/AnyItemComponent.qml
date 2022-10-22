//<license>

import QtQuick 2.0
import Sailfish.Silica 1.0
//import QtQuick.Controls 2.0

// this component allows to add an item to shopping list
SilicaListView {

    id: anyItemComponent

    property string uid_ : ""
    property string itemType
    property string name_
    property int amount_
    property string unit_
    property string category_
    property bool done_

    property int mode

    AssetCommons{
        id: commons
    }

    ListModel {
        id: unitModel
    }

    ListModel {
        id: categoryModel
    }

    Component.onCompleted: {
        unitModel.clear()
        categoryModel.clear()
        commons.fillUnitModel(unitModel)
        commons.fillCategoryModel(categoryModel)

        if (mode == 1) {
           send2Controlls()
        }
         itemName.forceActiveFocus()
    }

    function send2Controlls(){
        itemName.text = name_ //item['Name']
        defaultAmount.text = amount_ //item['Amount']
        var index =  commons.getIndexForName(unit_/*item['Unit']*/, unitModel)
        console.log("index of unit: " + unit_ + " is " + index)
        if (index > -1) { unit.currentIndex  = index }
        index =  commons.getIndexForName(category_/*item['Unit']*/, categoryModel)
        if (index > -1) { category.currentIndex  = index }
        console.log("index of category: " + category_ + " is " + index)
    }

    SilicaFlickable{

        id: anyItemFlickable
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

            Label {
                text: qsTr("Item")
                font.pixelSize: Theme.fontSizeLarge
                anchors.leftMargin: Theme.paddingLarge
                anchors.left: parent.left
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
                focus: true
                EnterKey.onClicked: {
                    if (applicationWindow.settings.useCategories) {
                       changeCategory.forceActiveFocus()
                    }
                    else {
                       defaultAmount.forceActiveFocus()
                    }
                }
            }
            TextField {
                id: defaultAmount
                width: parent.width
                inputMethodHints: Qt.ImhDigitsOnly
                label: qsTr("Standard package size")
                text: "1"
                placeholderText: qsTr("Set standard package size")
                errorHighlight: text.length === 0 // not mandatory
                EnterKey.enabled: !errorHighlight
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: unit.focus = true
            }
            // the next part could be shown only if household xor's food
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
                id: category
                label: qsTr("Category")
                menu: ContextMenu {
                    Repeater {
                        id: categoryRepeater
                        model: categoryModel
                        MenuItem {
                            text: Name
                        }
                    }
                }
            }
            /*Button {
                id: saveAndClose
                text: qsTr("Save and close")
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.rightMargin: Theme.paddingLarge
                anchors.leftMargin: Theme.paddingLarge
                  onClicked: {
                      doAccept();
                }
            }*/
            Button {
                id: saveAndKeep
                text: qsTr("Create another")
                visible: mode == 2
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.rightMargin: Theme.paddingLarge
                anchors.leftMargin: Theme.paddingLarge
                  onClicked: {
                      saveAndKeep.forceActiveFocus();
                      doAccept();
                      reset();
                      itemName.editor.forceActiveFocus();
                }
            }
            /*TextArea {
                id: explain
                width: parent.width
                text: qsTr("All following fields are only required, if you want to add this item also into your db. if not, swipe to accept.")
                readOnly: true
            }
            ComboBox {
                id: type
                label: qsTr("Type")
                menu: ContextMenu {
                    MenuItem { text: "household" }
                    MenuItem { text: "food" }
                }
            }
            TextField {
                id: co2
                width: parent.width
                inputMethodHints: Qt.ImhDigitsOnly
                label: qsTr("co2 in []")
                text: "1"
                placeholderText: qsTr("Set co2 footprint")
                errorHighlight: text.length === 0 // not mandatory
                EnterKey.enabled: !errorHighlight
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                EnterKey.onClicked: unit.focus = true
            }

            Button {
                id: addButton
                text: qsTr("Add this item to DB")
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: Theme.paddingLarge
                anchors.rightMargin: Theme.paddingLarge
                onClicked: {
                    // adds item to household/food db !
                    var isThereAny = DB.getDatabase().getItemPerName(itemName.text)
                    if (isThereAny.length < 1)
                    {
                      var freshUid = DB.getDatabase().db.getUniqueId()
                      DB.getDatabase().setItem(freshUid,itemName.text,parseInt(defaultAmount.text), unit.value,type.value,0,categoryName.text,co2.text);
                      uid_ = freshUid
                    }
                    //todo: show pop up error that aready there
                }
            }*/
            TextArea {
                id: empty
                width: parent.width
                text: "  "
                readOnly: true
            }
        }
    }

    Component.onDestruction: {

    }

    function collectCurrentItem()
    {
        var current = {}
        current['Id'] = uid_
        current['Name']  = itemName.text
        current['Amount']  = parseInt(defaultAmount.text)
        current['Unit']  = unit.value
        current['Done'] = done_
        current['Category']  = category.value
        current['ItemType'] = itemType
        commons.traceItem(current)
        return current;
    }

    function doAccept() {

        console.log("mode: " + mode)
        if (mode == 1) {
            // edit -> needs to update list
            console.log('update list')
            applicationWindow.python.updateOne(listName,name_,collectCurrentItem())
            return
        }

        if (mode == 2) {
            // adds item to shopping list !
            // ignore accept if no name was entered
            var name = itemName.text;
            if (itemName.text === null || itemName.text === "") return;
            if (applicationWindow.settings.useCapitalization === false) {
              name = name.toLowerCase();
            }

            // convert object to list and store
            var list2Add = []
            var tmp= collectCurrentItem()
            commons.traceItem(tmp)
            list2Add.push(tmp)
            applicationWindow.python.addItem2ShoppingList(listName,list2Add)
        }
    }

    function reset()
    {
        uid_ = "";
        name_ = "";
        amount_ = 1;
        unit_ = "-";
        category_ = "";
        itemType = "household"
    }

}
