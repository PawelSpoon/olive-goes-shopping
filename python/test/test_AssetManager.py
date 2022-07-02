import unittest
import sys
sys.path.append('../src')

from controller.assetmanager import AssetManager
from storage.persistance import readEnums, readItems, storeEnums, storeItems
from controller.constants import *

class AssetManagerTest(unittest.TestCase):
  
    rootDir = "./src/assets"
    outDir = "./test/test-out"

    def setUp(self) -> None:
        return super().setUp()
        
    # Returns True or False. 
    def test(self):        
        self.assertTrue(True)
    
    def testCreation(self):
        print('testCreation')
        manager = AssetManager(self.rootDir)
        self.assertTrue(manager.rootDir == self.rootDir)

    def testLoad(self):
        print('testLoad')
        manager = AssetManager(self.rootDir)
        manager.load()
        self.assertEqual(3,len(manager.itemtypeController.getList()))
        self.assertEqual(4,len(manager.phydimController.getList()))
        self.assertTrue("food" in manager.itemControllerDict.keys())
        self.assertEqual(2,len(manager.itemControllerDict["food"].getList()))
        self.assertEqual(13,len(manager.unitController.getList()))
  
    def testStore(self):
        print('testStore')
        manager = AssetManager(self.rootDir)
        manager.load()
        manager.rootDir = self.outDir

    def testGetController(self):
        print("testGetController")
        manager = AssetManager(self.rootDir)
        manager.load()
        rpc = manager.getController(recipe)
        ret = rpc.add({"Name":"My-Recipe"})
        self.assertTrue(ret)
        manager.rootDir = self.outDir

    def testGetNoneController(self):
        print("testGetNoneController")
        manager = AssetManager(self.rootDir)
        manager.load()
        rpc = manager.getController("None")
        self.assertTrue(None==rpc)

    def testGetCategoryController(self):
        print("testGetCategoryController")
        manager = AssetManager(self.rootDir)
        manager.load()
        rpc = manager.getController(category)
        self.assertTrue(rpc != None)
        ret = rpc.add({"Id":"doit","Name":"My-Recipe"})
        self.assertTrue(ret)
        rpc.filePath = self.outDir + categoryFilePath
        rpc.store()

    def testGetPhydimController(self):
        print("testGetPhydimController")
        manager = AssetManager(self.rootDir)
        manager.load()
        rpc = manager.getController(phydim)
        self.assertTrue(rpc != None)
        ret = rpc.add({"Name":"My-Recipe"})
        self.assertTrue(ret)    
        rpc.filePath = self.outDir + phydimFilePath
        rpc.store()

    def testStoreFoodWithUnit(self):
        manager = AssetManager(self.rootDir)
        manager.load()
        ctrl = manager.getController("food")
        ctrl.getList()
        ctrl.update('Apple',{ 'Name': 'Apple', 'Unit': {'Id': '4', 'Name':'pound'}})
        print(ctrl.getList()["Apple"]['Unit']['Id'])
        ctrl.filePath = self.outDir + "/item/food.json"
        ctrl.store()

    def testLoadCats(self):
        manager = AssetManager(self.rootDir)
        manager.load()
        ctrl = manager.getController("category")
        self.assertTrue(ctrl.getList()["fresh produce"]["Name"]=="fresh produce")




if __name__ == '__main__':
    unittest.main()