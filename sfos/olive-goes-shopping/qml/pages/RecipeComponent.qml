//<license>

import QtQuick 2.0
import Sailfish.Silica 1.0
//import QtQuick.Controls 2.0


// Dialog to edit a recipe

    SilicaFlickable{
        id: settingsFlickable

        property string itemType
        property int mode

        property var item_


        onActiveFocusChanged: print(activeFocus)
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: col.height

        // Show a scollbar when the view is flicked, place this over all other content
        VerticalScrollDecorator {}

        AssetCommons {
            id: commons
        }

        ListModel {
            id: categoryModel
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
                text: { if ( mode === 2) qsTr("New recipe")
                        else qsTr("Recipe") }
                font.pixelSize: Theme.fontSizeLarge
                anchors.left: parent.left
                anchors.leftMargin: Theme.paddingLarge
            }

            TextField {
                id: itemName
                width: parent.width
                inputMethodHints: Qt.ImhSensitiveData
                label: qsTr("Recipe name")
                text: ""
                placeholderText: qsTr("Set recipe name")
                errorHighlight: text.length === 0
                EnterKey.enabled: !errorHighlight
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                font.capitalization: applicationWindow.controller.getCapitalization();//Font.MixedCase
                EnterKey.onClicked: servings.focus = true
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

            ComboBox {
                id: servings
                width: parent.width
                label: qsTr("Servings")
                menu: ContextMenu {
                     Repeater {
                        model: commons.getServingsModel()
                        MenuItem {
                            text: Name
                        }
                     }
                 }

            }

            ComboBox {
                id: rating
                width: parent.width
                label: qsTr("Rating")
                menu: ContextMenu {
                    Repeater {
                        model: commons.getRatingModel()
                        MenuItem {
                           text: Name
                        }
                    }
                }
            }

            TextField {
                id: howto
                width: parent.width
                inputMethodHints: Qt.ImhNone
                label: qsTr("Recipe")
                text: ""
                placeholderText: qsTr("..how do you cook that..")
                errorHighlight: text.length === 0
                EnterKey.enabled: !errorHighlight
                EnterKey.iconSource: "image://theme/icon-m-enter-next"
                font.capitalization: Font.MixedCase
                EnterKey.onClicked: addButton.focus = true
            }

            Button {
                id: addButton
                text: qsTr("Add ingredient")
                anchors.left: parent.left
                anchors.leftMargin: Theme.paddingLarge
                onClicked: {
                   console.log("Add ingredient clicked ")
                   pageStack.push(Qt.resolvedUrl("RecipeItemDialog.qml"), {itemType: itemType, recipeDialog: settings} )
                }

            }

            SilicaListView {
                id: ingredientsList
                //anchors.top: addButton.bottom
                width : parent.width
                height: 800
                //anchors.bottom: parent.bottom
                model: ingredientsModel
                header: PageHeader { title: "Ingredients" }

                ViewPlaceholder {
                    enabled: ingredientsList.count == 0
                    text: qsTr("Please add ingredient")
                }

                delegate: Item {
                    id: myListItem
                    property bool menuOpen: contextMenu != null && contextMenu.parent === myListItem
                    property int myIndex: index
                    property Item contextMenu

                    width: ListView.view.width
                    height: menuOpen ? contextMenu.height + contentItem.height : contentItem.height

                    function remove() {
                        var removal = removalComponent.createObject(myListItem)
                        ListView.remove.connect(removal.deleteAnimation.start)
                        removal.execute(contentItem, "Deleting", function() {
                            print("n:"+name)
                            //DB.getDatabase().removeItem(uid,name,amount,unit,done);
                            ingredientsModel.remove(index);
                            //todo: this should be a reusabel fu
                            storeIndredientModelToItem()
                            }
                        )
                    }

                    BackgroundItem {
                        id: contentItem

                        width: parent.width
                        onPressAndHold: {
                            if (!contextMenu)
                                contextMenu = contextMenuComponent.createObject(settingsFlickable)
                            contextMenu.show(myListItem)
                        }
                        onClicked: {
                            console.log("Clicked ingredient: " + ingreName.text)
                            // uid is used to differ between add and edit
                            pageStack.push(Qt.resolvedUrl("RecipeItemDialog.qml"), {uid_:"1", name_: ingreName.text, amount_: parseInt(ingreAmount.text), unit_: ingreUnit.value,itemType: itemType, recipeDialog: settings} )
                        }
                        Image {
                            id: typeIcon
                            anchors.left: parent.left
                            anchors.leftMargin: Theme.paddingSmall
                            source: {
                                //if (type === "note") "image://theme/icon-l-copy" else
                                "image://theme/icon-m-levels"
                            }
                            height: parent.height
                            width: height
                        }
                        Label {
                            id: ingreName
                            text: name
                            anchors.left: typeIcon.right
                            anchors.leftMargin: Theme.paddingMedium
                            anchors.verticalCenter: parent.verticalCenter
                            truncationMode: TruncationMode.Elide
                            elide: Text.ElideRight
                            color: contentItem.down || menuOpen ? Theme.highlightColor : Theme.primaryColor
                        }
                        Label {
                            id: ingreAmount
                            text: amount
                            anchors.left: ingreName.right
                            anchors.leftMargin: Theme.paddingMedium
                            anchors.verticalCenter: parent.verticalCenter
                            truncationMode: TruncationMode.Elide
                            elide: Text.ElideRight
                            color: contentItem.down || menuOpen ? Theme.highlightColor : Theme.primaryColor
                        }
                        Label {
                            id: ingreUnit
                            text: unit
                            anchors.left: ingreAmount.right
                            anchors.leftMargin: Theme.paddingMedium
                            anchors.verticalCenter: parent.verticalCenter
                            truncationMode: TruncationMode.Elide
                            elide: Text.ElideRight
                            color: contentItem.down || menuOpen ? Theme.highlightColor : Theme.primaryColor
                        }
                    }

                    Component {
                        id: removalComponent
                        RemorseItem {
                            property QtObject deleteAnimation: SequentialAnimation {
                                PropertyAction { target: myListItem; property: "ListView.delayRemove"; value: true }
                                NumberAnimation {
                                    target: myListItem
                                    properties: "height,opacity"; to: 0; duration: 300
                                    easing.type: Easing.InOutQuad
                                }
                                PropertyAction { target: myListItem; property: "ListView.delayRemove"; value: false }
                            }
                            onCanceled: destroy()
                        }
                    }
                    Component {
                        id: contextMenuComponent
                        ContextMenu {
                            id: menu
                            MenuItem {
                                text: "Delete"
                                onClicked: {
                                    menu.parent.remove();
                                }
                            }
                        }
                    }
                }

            }

            ListModel {
                id: ingredientsModel
                ListElement {name:"123";amount:0;unit:"g"}
            }

        }

        function doAccept() {
            //(itemType,mode,oldItem, currentItem)
            commons.onAccept(itemType,mode,item_,collectCurrentItem())
            commons.updateParentPage(itemType)
        }

        function collectCurrentItem()
        {
            var current = {}
            if (mode == 2) { // add
                current['Id'] = applicationWindow.controller.getUniqueId()
            } else { // edit
                current['Id'] = item['Id']
            }
            current['Name']  = itemName.text
            current['Servings']  = commons.getUnit(servings.value, commons.getServingsModel()).Name
            current['Rating']  = commons.getUnit(rating.value, commons.getRatingModel()).Name
            current['Category']  = commons.getUnit(categoryCombo.value, categoryModel)
            current['HowTo'] = howto.text
            // todo ingres:
            return current;
        }


    Component.onCompleted: {
        categoryModel.clear()
        commons.fillCategoryModel(categoryModel)

        if (mode != 2) {
           send2Controlls()
        }
    }

    function send2Controlls()
    {
        itemName.text = item_['Name']
        servings.currentIndex = commons.getIndexForName(item['Servings'], commons.getServingsModel())
        categoryCombo.currentIndex = commons.getIndexForItem(item_['Category'], categoryModel)
        rating.currentIndex = commons.getIndexForName(item['Rating'], commons.getRatingModel())
        howto.text = item_['HowTo']
        fillIngredientsList()
    }

    function fillIngredientsList()
    {
        var ingres = item_['Ingredients']
        if (ingres === null)
        {
            print("ingredient is null, set howMany to 0")
            return
        }
        if (ingres == "")
        {
            print("ingredient is empty string set howMany to 0")
            return
        }
        print(ingres)
        // convert string to object
        var ingre = JSON.parse(ingres)
        ingredientsModel.clear()
        if (ingre === null) return; // no ingredients yet
        for (var i = 0; i < ingre.length; i++)
        {
            var ing = ingre[i]
            print(ing.Name + " " + ing.Amount  + " " + ing.Unit)
            var elem =  {Name: ing.Name, Amount:ing.Amount, Unit: ing.Unit}
            ingredientsModel.append(elem)
        }
        ingredientsList.height = i * 150
    }

    function addIngredient(ingre_, amount_, unit_)
    {
        var elem =  {name: ingre_, amount: amount_, unit: unit_}
        ingredientsModel.append(elem)

        storeIndredientModelToItem()

        fillIngredientsList()
    }

    function updateIngredient(ingre_, amount_, unit_, orgIngre)
    {
        // search for original name, only when orgName empty then search for new name
        var searchName = orgIngre;
        if (searchName == null) searchName = ingre_;

        // find and update ingredient
        for (var i=0; i < ingredientsModel.count; i++)
        {
            if (ingredientsModel.get(i).name === searchName) {
                //var elem =  {name: ingre_, amount: amount_, unit: unit_}
                ingredientsModel.setProperty(i,"name",ingre_)
                ingredientsModel.setProperty(i,"amount",amount_)
                ingredientsModel.setProperty(i,"unit",unit_)
            }
        }
        // do i need to update the list ?
        // no but you need to update ingedients_ string representation
        storeIndredientModelToItem()
    }

    function storeIndredientModelToItem()
    {
        var ingre = []
        for (var i=0; i < ingredientsModel.count; i++)
        {
            var elemi =  ingredientsModel.get(i)
            ingre.push(elemi)
        }
        ingredients_ = JSON.stringify(ingre)
    }
}
