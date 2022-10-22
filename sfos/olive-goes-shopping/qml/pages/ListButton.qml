//<license>

import QtQuick 2.2
import Sailfish.Silica 1.0
//import QtQuick.Controls 2.0

Row {
    id: row
    signal clicked()
    property alias text: button.text
    property alias itemType: button.itemType

    Image {
        id: typeIcon
        source: {
            isShop() ?  "image://theme/icon-m-levels" : "image://theme/icon-l-copy"
        }
        height: parent.height
        width: height
    }

    function isShop()
    {
        console.log(itemType)
        if (itemType === "shop") return true
        return false
    }

    Button {
        id: button
        property alias text: button.text
        property string itemType

        onClicked: {
            row.clicked()
        }
    }
}
