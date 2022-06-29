import pyotherside
from controller.assetmanager import AssetManager

class App:

    def setup(self,rootDir,qObject):

        self.assetManager = AssetManager(rootDir)
        self.assetManager.load()
        self.pyHandler = qObject
        self.init = True

    def getAssetManager(self):
        return self.assetManager

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
        # if type was itemtype, i need to create an itemcontroller too + file
        # rename is also nice         
        return temp.getAsList()


    def updateAsset(self, type, oldName, item):
        temp = self.assetManager.getController(type)
        temp.update(oldName, item)
        temp.store()
        return temp.getAsList()
    

app = App()
