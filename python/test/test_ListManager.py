import os
import unittest
import sys
sys.path.append('../src')

from storage import persistance
from controller.constants import *
from controller.listmanager import ListManager
from storage.persistance import readEnums, readItems, storeEnums, storeItems

class ListManagerTest(unittest.TestCase):
  
    rootDir = "./src/assets"
    outDir = "./test/test-out"

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
        self.assertTrue("demo" in manager.getListNames()[FieldName])

    def testLoadListItems(self):
        print('testLoadListItems')
        manager = ListManager(self.rootDir, shoplistType)
        manager.load()
        self.assertEqual(1,len(manager.listController.keys()))
        self.assertTrue("demo" in manager.getListNames()[FieldName])
        ctrl = manager.getController('demo')
        ctrl.load()
        self.assertTrue(ctrl.rootDir==self.rootDir)
        self.assertTrue(ctrl.mytype=='demo')
        self.assertTrue('demo.shop.json' in ctrl.filePath)
        self.assertTrue(ctrl.getTypeName() == 'demo')
        self.assertTrue("Beer" in ctrl.getList().keys())

    def testGetListNames(self):
        manager = ListManager(self.rootDir, shoplistType)
        manager.load()
        print(manager.getListNames())
        self.assertTrue("demo" in manager.getListNames()[FieldName])
  
   # def testStoreTask(self):
     #   print('testStore')
     #   manager = ListManager(self.rootDir, tasklistType)
     #   manager.load()
     #   self.assertEqual(1,len(manager.listController.keys()))
     #   self.assertTrue("annual maintenance - Breva" in manager.listController.keys())
    #    manager.rootDir = self.outDir

    def testGetController(self):
        print("testGetController")
        manager = ListManager(self.rootDir, shoplistType)
        manager.load()
        rpc = manager.getController("demo")

    def testAddController(self):
        print("testAddController")
        manager = ListManager(self.rootDir, shoplistType)
        manager.load()
        manager.rootDir = self.outDir
        manager.add("olive")
        self.assertTrue(os.path.exists(self.outDir + "/current/olive.shop.json"))      
        self.assertTrue("olive" in manager.listController.keys())
        manager.rootDir = self.outDir
        persistance.readItems(self.outDir + "/current/olive.shop.json")

    def testDeleteController(self):
        print("testDeleteController")
        manager = ListManager(self.rootDir, shoplistType)
        manager.load()
        manager.rootDir = self.outDir        
        manager.add("maja")
        self.assertTrue(os.path.exists(self.outDir + "/current/maja.shop.json"))        
        self.assertTrue("maja" in manager.listController.keys())
        persistance.readItems(self.outDir + "/current/maja.shop.json")
        manager.delete("maja")
        self.assertFalse(os.path.exists(self.outDir + "/current/maja.shop.json"))


if __name__ == '__main__':
    unittest.main()