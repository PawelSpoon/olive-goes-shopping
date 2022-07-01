import os
import pyotherside
from controller.assetmanager import AssetManager

class App:

    def setup(self,rootDir,qObject):

        os.path.join("$HOME",rootDir)
        self.assetManager = AssetManager(rootDir)
        self.root = rootDir
        self.assetManager.load()
        self.pyHandler = qObject
        self.init = True

    def getAssetManager(self):
        return self.assetManager

    def reInitAssetManager(self):
        self.assetManager = AssetManager(self.root,self.pyHandler)
        self.assetManager.load()


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
    

app = App()
