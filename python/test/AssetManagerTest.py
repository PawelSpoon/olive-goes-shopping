import unittest
import sys
sys.path.append('../src')

from controller.assetmanager import AssetManager
from storage.persistance import readEnums, readItems, storeEnums, storeItems

class AssetManagerTest(unittest.TestCase):
  
    rootDir = "../src/assets"
    outDir = "./test-out"

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
        self.assertEqual(12,len(manager.unitController.getList()))
  
    def testStore(self):
        print('testStore')
        manager = AssetManager(self.rootDir)
        manager.load()
        manager.rootDir = self.outDir
        manager.store()

    def testGetController(self):
        print("testGetController")
        manager = AssetManager(self.rootDir)
        manager.load()
        rpc = manager.getController("recipe")
        rpc.add({"Name":"My-Recipe"})
        manager.rootDir = self.outDir
        manager.store()

if __name__ == '__main__':
    unittest.main()