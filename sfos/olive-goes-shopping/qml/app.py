import os
import pyotherside

from controller.assetmanager import AssetManager
from controller.listmanager import ListManager

class App:

    def setup(self,rootDir,qObject):
        self.init = False
        self.assetManager = AssetManager(rootDir)
        self.root = rootDir
        self.assetManager.load()
        self.listManager = ListManager(rootDir,'shop')
        self.listManager.load()
        self.taskManager = ListManager(rootDir,'task')
        #self.taskManager.load()
        self.init = True
        pyotherside.send('init')

    def getAssetManager(self):
        return self.assetManager

    def reInitAssetManager(self):
        self.init = False
        self.assetManager = AssetManager(self.root)
        self.assetManager.load()
        self.listManager = ListManager(self.root,'shop')
        self.listManager.load()
        self.taskManager = ListManager(self.root,'task')
        #self.taskManager.load()
        self.init = True
        pyotherside.send('init')


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

    def createList(self, name, type):
        if type == "shop":
            self.listManager.add(name)
            #self.listManager.store()
        else:
            self.taskManager.add(name)
            #self.taskManager.store()
        
    def deleteList(self, name,type):
        if type == "task":
            self.taskManager.delete(name)
        else:
            self.listManager.delete(name)    

    def getShoppingList(self, name):
        ctrl = self.listManager.getController(name)
        ctrl.load()
        return ctrl.getAsList()

    def addItem2ShoppingList(self, listName, items):
        ctrl = self.listManager.getController(listName)
        ctrl.addItems2ShoppingList(items)
        ctrl.store()

    def setDoneValue(self, listName, name, done):
        ctrl = self.listManager.getController(listName)
        ctrl.setDoneValue(name, done)
        ctrl.store()

    def clearDone(self, listName):
        ctrl = self.listManager.getController(listName)
        ctrl.clearDone()
        ctrl.store()

    # reset all
    def resetDone(self, listName):
        ctrl = self.listManager.getController(listName)
        ctrl.resetDone()
        ctrl.store()

    def clearAll(self, listName):
        ctrl = self.listManager.getController(listName)
        ctrl.clearItems()
        ctrl.store()

    def deleteOne(self, listName, name):
        ctrl = self.listManager.getController(listName)
        ctrl.deleteOne(name)
        ctrl.store()

    def updateOne(self, listName, oldName, item):
        ctrl = self.listManager.getController(listName)
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
        #self.assetManager.load()
        self.reInitAssetManager()

    def deleteTemplate(self, type, name):
        return self.assetManager.deleteTemplate(type,name)

app_object = App()
