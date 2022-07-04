import QtQuick 2.0
import Sailfish.Silica 1.0

ListItem {
        id: delegate

        property string uid
        property alias name : itemLabel.text
        property int amount
        property string itemType
        property alias unit : unitLabel.text
        property string category //: categoryLabel.text
        property string order
        property bool checked

        signal toggled(string uid, string name, bool checked)
        signal pressed(string uid, string name, int mode)

        Component.onCompleted: {
            amountLabel.text = amount
        }

        Column
        {
            id: checked_column
            width: 80
            IconButton
            {
                icon.source: (checked > 0 ?
                    "../../icons/icon-m-checked.png" :
                    "../../icons/icon-m-unchecked.png")
                onClicked:
                {
                    console.log(uid + ": Clicked " + checked);
                    checked != checked
                    toggled(uid,name,checked)
                }
            }
        }
        Column
        {
            id: amount_column
            width: 120
            y: Theme.paddingLarge
            anchors
            {
                left: checked_column.right
                verticalCenter: checked_column.verticalCenter
            }

            Label {
                id: amountLabel
                x: Theme.horizontalPageMargin
                // text: model.qty + " " + model.checked + " " + model.item + " :: " + model.order
               // text: amount
                horizontalAlignment: Text.AlignLeft
//                        anchors.verticalCenter: parent.verticalCenter
                color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                width: parent.width
                truncationMode: TruncationMode.Fade
                font.strikeout: (checked > 0 && settings.strike_checked) ? true : false
            }
        }
        Column
        {
            id: unit_column
            width: 120
            y: Theme.paddingLarge
            anchors
            {
                left: amount_column.right
                verticalCenter: checked_column.verticalCenter
            }

            Label {
                id: unitLabel
                font.pixelSize: Theme.fontSizeSmall
                x: Theme.horizontalPageMargin
                // text: model.qty + " " + model.checked + " " + model.item + " :: " + model.order
               // text: amount
                horizontalAlignment: Text.AlignLeft
//                        anchors.verticalCenter: parent.verticalCenter
                color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                width: parent.width
                truncationMode: TruncationMode.Fade
                font.strikeout: (checked > 0 && settings.strike_checked) ? true : false
            }
        }
        Column
        {
            id: spacing_column
            width: 20
            anchors
            {
                left: unit_column.right
                verticalCenter: checked_column.verticalCenter
            }

            Label {
                text: ""
                color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                font.strikeout: (checked > 0 && settings.strike_checked) ? true : false
            }
        }
        Column
        {
            id: item_column
            width: 150
            y: Theme.paddingLarge
            anchors
            {
                left: spacing_column.right
                verticalCenter: checked_column.verticalCenter
            }

            Label {
                id: itemLabel
                x: Theme.horizontalPageMargin
                horizontalAlignment: Text.AlignLeft
//                        anchors.verticalCenter: parent.verticalCenter
                color: delegate.highlighted ? Theme.highlightColor : Theme.primaryColor
                truncationMode: TruncationMode.Fade
                font.strikeout: (checked > 0 && settings.strike_checked) ? true : false
            }
        }
//                onClicked: console.log(id + ": Clicked " + model.checked)
        onClicked:
        {
            console.log(uid + ": Clicked " + checked);
            checked = !checked
            toggled(uid,name,checked)
        }

        menu: ContextMenu {
            /*MenuItem {
                text: qsTr("Add Items")
                onClicked:
                {
                pressed(uid,name,3)
                }
            }*/
            MenuItem {
                text: qsTr("Edit Item")
                onClicked:
                {
                    pressed(uid,name,1)
                }
            }
            MenuItem {
                text: qsTr("Delete Item")
                // we need a remorse timer here
                onClicked:
                {
                    // this will create and remorse and finally fire event
                    remove(listName,name)
                }
            }
        }

        Component {
            id: removalComponent
            RemorseItem {
                property QtObject deleteAnimation: SequentialAnimation {
                    PropertyAction { target: root; property: "ListView.delayRemove"; value: true }
                    NumberAnimation {
                        target: root
                        properties: "height,opacity"; to: 0; duration: 300
                        easing.type: Easing.InOutQuad
                    }
                    PropertyAction { target: root; property: "ListView.delayRemove"; value: false }
                }
                onCanceled: destroy()
            }
        }

        // create remorse and fire if not canceled
        function remove(listName,name) {
            var removal = removalComponent.createObject() // should it be shoppingListItem ?
            //ListView.remove.connect(removal.deleteAnimation.start)
            removal.execute(delegate, "Deleting", function() {
                pressed(uid,name,3)
            })
        }
}
