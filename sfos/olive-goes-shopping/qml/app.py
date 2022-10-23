import os
import pyotherside

from controller.assetmanager import AssetManager
from controller.listmanager import ListManager

class App:

    shopType = "shop"
    taskType = "task"

    def setup(self,rootDir,qObject):
        self.init = False
        self.assetManager = AssetManager(rootDir)
        self.root = rootDir
        self.assetManager.load()
        self.listManager = ListManager(rootDir,'shop')
        self.listManager.load()
        self.taskManager = ListManager(rootDir,'task')
        self.taskManager.load()
        self.init = True
        pyotherside.send('init')

    def getAssetManager(self):
        return self.assetManager

    def reInitAssetManager(self):
        self.init = False
        self.assetManager = AssetManager(self.root)
        self.assetManager.load()
        self.listManager = ListManager(self.root, 'shop')
        self.listManager.load()
        self.taskManager = ListManager(self.root, 'task')
        self.taskManager.load()
        self.init = True
        pyotherside.send('init')

    def getTemplateItems(self, type, name):
        # shop / task would return the controller to add/remove a template
        # name will return the template-controller
        # templates are also per name in
        temp = self.assetManager.getController(name)
        return temp.getAsList()

    def getAssetList(self, type):
        temp = self.assetManager.getController(type)
        if temp == None:
            pyotherside.send('error',['no controller',type])
        return temp.getAsList()

    def clearAssets(self, type):
        temp = self.assetManager.getController(type)
        temp.clearItems()
        temp.store()
        return temp.getAsList()

    def deleteAsset(self, type, name):
        temp = self.assetManager.getController(type)
        temp.remove(name)
        temp.store()
        return temp.getAsList()

    def addAsset(self, type, item):
        temp = self.assetManager.getController(type)
        temp.add(item)
        temp.store()        
        return temp.getAsList()

    def updateAsset(self, type, oldName, item):
        temp = self.assetManager.getController(type)
        temp.update(oldName, item)
        temp.store()
        return temp.getAsList()

    def getShoppingLists(self):
        temp = self.listManager.getListNames()
        print(len(temp))
        return temp

    def getTaskLists(self):
        temp = self.taskManager.getListNames()
        print(len(temp))
        return temp

    def createList(self, name, type, items):
        if type == self.shopType :
            self.listManager.addFromTemplate(name, items)
        else:
            ctrl = self.taskManager.addFromTemplate(name, items)

    # does not delete list from file    
    def deleteList(self, name,type):
        if type == self.taskType:
            self.taskManager.delete(name)
        else:
            self.listManager.delete(name)    

    def getListController(self,type,name):
        if type == self.shopType:
            return self.listManager.getController(name)
        if type == self.taskType:
            return self.taskManager.getController(name)
        pyotherside.send('error',['no controller',type])
        return None

    def getList(self, type, name):
        ctrl = self.getListController(type,name)
        ctrl.load()
        return ctrl.getAsList()

    # add is separated for some reason
    def addItem2ShoppingList(self, listName, items):
        ctrl = self.listManager.getController(listName)
        ctrl.addItems2List(items)
        ctrl.store()

    def addItem2TaskList(self, listName, items):
        ctrl = self.taskManager.getController(listName)
        ctrl.addItems2List(items)
        ctrl.store()

    def setDoneValue(self, type, listName, name, done):
        ctrl = self.getListController(type,listName)
        ctrl.setDoneValue(name, done)
        ctrl.store()

    def clearDone(self, type, listName):
        ctrl = self.getListController(type,listName)
        ctrl.clearDone()
        ctrl.store()

    # reset all
    def resetDone(self, type, listName):
        ctrl = self.getListController(type,listName)
        ctrl.resetDone()
        ctrl.store()

    def clearAll(self, type, listName):
        ctrl = self.getListController(type,listName)
        ctrl.clearItems()
        ctrl.store()

    def deleteOne(self, type, listName, name):
        ctrl = self.getListController(type,listName)
        ctrl.deleteOne(name)
        ctrl.store()

    def updateOne(self, type, listName, oldName, item):
        ctrl = self.getListController(type,listName)
        ctrl.update(oldName, item)
        ctrl.store()

    def getTemplateListNames(self, type):
        return self.assetManager.getTemplateListNames(type)
        temp = self.assetManager.getController(type)
        if temp == None:
            pyotherside.send('error',['no controller',type])
        return temp.getAsList()

    def createTemplate(self, items, type, name):
        self.assetManager.createTemplate(items,type,name)
        self.reInitAssetManager()

    def deleteTemplate(self, type, name):
        return self.assetManager.deleteTemplate(type,name)

    def getTemplate(self, type, name):
        ctrl = self.assetManager.getTemplateController(type, name)
        return ctrl.getAsList()

    def deleteOneFromTemplate(self, type, listName, name):
        ctrl = self.assetManager.getTemplateController(type, listName)
        ctrl.deleteOne(name)
        ctrl.store()

    def updateOneInTemplate(self, type, listName, oldName, item):
        ctrl = self.assetManager.getTemplateController(type, listName)
        ctrl.update(oldName, item)
        ctrl.store()

    def addItem2Template(self, type, listName, items):
        ctrl = self.assetManager.getTemplateController(type, listName)
        ctrl.addItems2List(items)
        ctrl.store()

app_object = App()
