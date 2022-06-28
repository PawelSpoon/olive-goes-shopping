import os
import unittest
import sys
sys.path.append('../src')

from storage import persistance
from controller.constants import *
from controller.listmanager import ListManager
from storage.persistance import readEnums, readItems, storeEnums, storeItems

class ListManagerTest(unittest.TestCase):
  
    rootDir = "../src/assets"
    outDir = "./test-out"

    def setUp(self) -> None:
        return super().setUp()
        
    # Returns True or False. 
    def test(self):        
        self.assertTrue(True)
    
    def testCreation(self):
        print('testCreation')
        manager = ListManager(self.rootDir, shoplistType)
        self.assertTrue(manager.rootDir == self.rootDir)
        self.assertTrue(manager.type == shoplistType)

    def testLoad(self):
        print('testLoad')
        manager = ListManager(self.rootDir, shoplistType)
        manager.load()
        self.assertEqual(1,len(manager.listController.keys()))
        self.assertTrue("jan" in manager.listController.keys())
  
    def testStoreTak(self):
        print('testStore')
        manager = ListManager(self.rootDir, tasklistType)
        manager.load()
        self.assertEqual(1,len(manager.listController.keys()))
        self.assertTrue("annual maintenance - Breva" in manager.listController.keys())
        manager.rootDir = self.outDir
        manager.store()

    def testStoreShop(self):
        print('testStore')
        manager = ListManager(self.rootDir, shoplistType)
        manager.load()
        self.assertEqual(1,len(manager.listController.keys()))
        self.assertTrue("jan" in manager.listController.keys())
        manager.rootDir = self.outDir
        manager.store()

    def testGetController(self):
        print("testGetController")
        manager = ListManager(self.rootDir, shoplistType)
        manager.load()
        rpc = manager.getController("jan")

    def testAddController(self):
        print("testAddController")
        manager = ListManager(self.rootDir, shoplistType)
        manager.load()
        manager.add("olive")
        self.assertTrue("olive" in manager.listController.keys())
        manager.rootDir = self.outDir
        manager.store()
        persistance.readItems(self.outDir + "/current/olive.shop.json")

    def testDeleteController(self):
        print("testDeleteController")
        manager = ListManager(self.rootDir, shoplistType)
        manager.load()
        manager.add("maja")
        self.assertTrue("maja" in manager.listController.keys())
        manager.rootDir = self.outDir
        manager.store()
        persistance.readItems(self.outDir + "/current/maja.shop.json")
        manager.delete("maja")
        self.assertFalse(os.path.exists(self.outDir + "/current/maja.shop.json"))


if __name__ == '__main__':
    unittest.main()