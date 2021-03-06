//<license>

import QtQuick 2.0
import Sailfish.Silica 1.0
//import QtQuick.Controls 2.0


/*********
  * this page is just a wrapper around AnyItemDialog
  * it allows the invocation as a standalone page / dialog
  * i.e. to edit an item in shoppingList
  * all attritubes are passed as aliases to AnyItemDialog ..
  * only onAccept has to be triggered from this page, but again impl is in ..
**********/
Dialog {
    id: settings
    allowedOrientations: Orientation.All

    property alias uid_: anyItemDialog.uid_
    //property alias shoppingListPage: anyItemDialog.shoppingListPage
    property alias itemType : anyItemDialog.itemType
    property alias name_ : anyItemDialog.name_
    property alias amount_ : anyItemDialog.amount_
    property alias unit_ : anyItemDialog.unit_
    property alias category_ : anyItemDialog.category_

    property string listName

    property alias mode : anyItemDialog.mode

    DialogHeader {
        id: dialogHeader
        acceptText: qsTr("Save") // should be switchable based on add: property
        cancelText: qsTr("Discard")
    }

    // will not work till i get updates from ..
    //canAccept: name_.len > 0

    AnyItemComponent {
        id:  anyItemDialog

        anchors.fill: parent
        anchors.topMargin: dialogHeader.height

        itemType: itemType
        uid_: uid_
        name_: name_
        amount_: amount_
        unit_: unit_
        category_: category_

    }


    onAccepted: {
        anyItemDialog.doAccept();
        applicationWindow.controller.signal_list_updated(listName)
    }
}
