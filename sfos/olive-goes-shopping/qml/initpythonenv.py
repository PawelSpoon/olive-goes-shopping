# This Python file uses the following encoding: utf-8

# if __name__ == "__main__":
#     pass

from controller.constants import *
from controller.assetmanager import AssetManager

global assetManager
assetManager = AssetManager("/usr/share/olive-goes-shopping/assets")
assetManager.load()

def getController(which):
    return assetManager.getController(which)


