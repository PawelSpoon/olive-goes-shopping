import QtQuick 2.0
import "pages"

// 

Item {

    id: dataCache

    // will i need an dictionary ? 
    // i would not cache all, only the 'static' ones
    property var phydimList : undefined
    property var unitsList: undefined
    property var categoryList : undefined
    property var itemtypeList : undefined

    function invalidate() {
        phydimList = undefined
        unitsList= undefined
        categoryList = undefined
        itemtypeList = undefined
    }

    function getPhydims() {
        if (phydimList === undefined)
        {
            phydimList = applicationWindow.python.getAssets("phydim")
        }
        return phydimList
    }

    function getUnits() {
        if (unitsList === undefined)
        {
            unitsList = applicationWindow.python.getAssets("unit")
        }
        return unitsList
    }

    function getCategories() {
        if (categoryList === undefined)
        {
            categoryList = applicationWindow.python.getAssets("category")
        }
        return categoryList
    }

    function getItemtypes() {
        if (itemtypeList === undefined)
        {
            itemtypeList = applicationWindow.python.getAssets("itemtype")
        }
        return itemtypeList
    }

    // returns the names of existing shopping lists
    function getShoppingLists() {
        return applicationWindow.python.getShoppingLists()
    }

    function getItemsOfType(type)
    {
        return applicationWindow.python.getAssets(type)
    }

    // DO NOT PUT CURRENT shopping lists and tasks lists here in you idiot


}
