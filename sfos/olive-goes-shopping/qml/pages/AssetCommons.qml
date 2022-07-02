import QtQuick 2.0

Item {

    function wasRenamed(old,current)
    {
        if (old === current) return true
        return false
    }

    function onAccept(itemType,mode,oldItem, currentItem)
    {
        console.log('onaccept of type: ' + itemType + ' and mode: ' + mode)
        if (mode === 2) { // add
            console.log('in add')
            applicationWindow.python.addAsset(itemType, currentItem)
            return
        }
        if (mode === 0) { // read-only, maybe sort is ok
            console.log('mode=0')
            return
        }
        var oldName = oldItem['Name']
        var id = oldItem['Id']
        if (oldName === undefined || oldName === null || oldName === '') oldName = currentItem['Name']
        if (id === "" ) id = applicationWindow.controller.getUniqueId()
        // here i could check old and new name for rename :) or python is so intelligent
        console.log('in edit')
        if (mode === 1) applicationWindow.python.updateAsset(itemType, oldName, currentItem)

    }

    ListModel {
        id: ratingModel
        ListElement { Name: "11"; color: "Green" }
        ListElement { Name: "10"; color: "Green" }
        ListElement { Name: "4"; color: "Green" }
        ListElement { Name: "3"; color: "Yellow" }
        ListElement { Name: "2"; color: "Orange" }
        ListElement { Name: "1"; color: "Red" }
        ListElement { Name: "0"; color: "Brown" }
    }

    function getRatingModel()
    {
        return ratingModel
    }

    ListModel {
        id: servingsModel
        ListElement { Name: "12"; color: "Green" }
        ListElement { Name: "10"; color: "Green" }
        ListElement { Name: "8"; color: "Green" }
        ListElement { Name: "6"; color: "Yellow" }
        ListElement { Name: "4"; color: "Orange" }
        ListElement { Name: "2"; color: "Red" }
        ListElement { Name: "1"; color: "Brown" }
    }

    function getServingsModel()
    {
        return servingsModel
    }


    function updateParentPage(itemType)
    {
        console.log('assetcommon send signal')
        applicationWindow.controller.updateParentPage(itemType)
    }

    function fillCategoryModel(model)
    {
        var list = applicationWindow.cache.getCategories()
        model.append({"Name":" ", "Id": "-1"})
        for (var i = 0; i < list.length ; i++) {
            console.log(list[i].Name)
            model.append({"Name": list[i].Name, "Id": list[i].Id})
        }
        return model
    }

    function fillItemtypesModel(model)
    {
        var list = applicationWindow.cache.getItemtypes()
        for (var i = 0; i < list.length ; i++) {
            console.log(list[i].Name)
            model.append({"Name": list[i].Name, "Id": list[i].Id})
        }
        return model
    }

    function fillUnitModel(model)
    {
        var list = applicationWindow.cache.getUnits()
        for (var i = 0; i < list.length ; i++) {
                        console.log(list[i].Name)
            model.append({"Name": list[i].Name, "Id": list[i].Id})
        }
        return model
    }


    function getIndexForName(name, listModel) {
        if (name === '') return -1
        for (var i = 0; i < listModel.count ; i++) {
            if( listModel.get(i).Name === name) {
                return i
            }
        }
        return -1
    }

    function getIndexForItem(item, listModel)
    {
        if (item === undefined) return -1
        var itemName = item['Name']
        return getIndexForName(itemName, listModel)
    }

    function getUnit(unitName, listModel)
    {
        if (unitName === '') return
        for (var i = 0; i < listModel.count ; i++) {
            if( listModel.get(i).Name === unitName) {
                var u = listModel.get(i)
                console.log(u.Id+u.Name)
                return { Id:u.Id, Name:u.Name}
            }
        }
    }
}
