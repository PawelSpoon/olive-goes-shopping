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

app = App()
