//<license>

import QtQuick 2.0
import Sailfish.Silica 1.0
//import QtQuick.Controls 2.0

// Dialog to edit a recipe

Dialog {
    id: settings

    allowedOrientations: Orientation.All
 
    property string itemType
    property int mode

    property var item


    // quick hack
    property alias recipeComponent: recipeComponent

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
                text: { if (mode === 2) qsTr("New recipe")
                        else qsTr("Recipe") }
                font.pixelSize: Theme.fontSizeLarge
                anchors.left: parent.left
                anchors.leftMargin: Theme.paddingLarge
            }


            RecipeComponent {
                id: recipeComponent
                itemType: itemType
                item_:  item
                mode: mode
                width: parent.width
            }
        }
    }


    onAccepted: {
        recipeComponent.doAccept()
    }

    // user has rejected editing entry data, check if there are unsaved details
    onRejected: {
        // no need for saving if input fields are invalid
        if (canNavigateForward) {
            // ?!
        }
    }
 }
