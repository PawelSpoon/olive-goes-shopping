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
            anchors.fill: parent
            width: parent.width
            spacing: Theme.paddingLarge

            DialogHeader {
                acceptText: qsTr("Save")
                cancelText: qsTr("Discard")
            }

            // important. else it will scroll up and never back again
            height: recipeComponent.height + 300

            RecipeComponent {
                id: recipeComponent
                topMargin: 300
                itemType: itemType
                item_:  item
                mode: mode
                width: parent.width

            }
        }
    }

    Component.onCompleted: {
        recipeComponent.mode = mode
        recipeComponent.itemType = itemType
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
