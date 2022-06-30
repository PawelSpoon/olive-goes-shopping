import QtQuick 2.0

Item {

    function wasRenamed(old,current)
    {
        if (old === current) return true
        return false
    }

    function onAccept(itemType,mode,oldItem, currentItem)
    {
        if (mode === 2) { // add
            console.log('in add')
            applicationWindow.pythonController.addAsset(itemType, currentItem)
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
        if (mode === 1) applicationWindow.pythonController.updateAsset(itemType, oldName, currentItem)

    }


    function updateParentPage(itemType)
    {
        console.log('assetcommon send signal')
        applicationWindow.controller.updateParentPage(itemType)
    }

    function fillCategoryModel(model)
    {
        var list = applicationWindow.controller.getCategories()
        model.append({"Name":" ", "Id": "-1"})
        for (var i = 0; i < list.length ; i++) {
            console.log(list[i].Name)
            model.append({"Name": list[i].Name, "Id": list[i].Id})
        }
        return model
    }

    function fillUnitModel(model)
    {
        var list = applicationWindow.controller.getUnits()
        for (var i = 0; i < list.length ; i++) {
                        console.log(list[i].Name)
            model.append({"Name": list[i].Name, "Id": list[i].Id})
        }
        return model
    }

    function getUnitIndex(item, listModel)
    {
        if (item === undefined) return 1
        var itemName = item['Name']
        if (itemName === '') return
        for (var i = 0; i < listModel.count ; i++) {
            if( listModel.get(i).Name === itemName) {
                return i
            }
        }
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
