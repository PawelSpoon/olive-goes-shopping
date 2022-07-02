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
        self.init = True
        pyotherside.send('init')


    def getAssetList(self, type):
        return self.assetManager.getController(type).getAsList()

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

    def getShoppingList(self, name):
        ctrl = self.listManager.getController(name)
        ctrl.load()
        return ctrl.getAsList()



app_object = App()
