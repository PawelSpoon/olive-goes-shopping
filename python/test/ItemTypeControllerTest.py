import os
import unittest
import sys
sys.path.append('../src')

from controller.itemtypecontroller import ItemTypeController
from controller.constants import *

class ItemTypeControllerTest(unittest.TestCase):
  
    itemTypeFile = "../src/assets/itemtype.json"
    itemTypeOutFile = "./test-out/itemtype.json"
    itemTypeListDir = "../src/assets/item"
    itemTypeListOuDir = "./test-out/item"

    def cleanUp(self):
        files = os.listdir(self.itemTypeListOuDir)
        for file in files:
            os.remove(os.path.join(self.itemTypeListOuDir, file))  

    def setUp(self) -> None:
        return super().setUp()
        

    def testCreation(self):
        print("testCreation")
        controller = ItemTypeController(itemtype,self.itemTypeFile,self.itemTypeListDir)
        self.assertTrue(controller.getTypeName() == itemtype)  

    def testList2FileEtc(self):
        print("testList2Fiel")
        controller = ItemTypeController(itemtype,self.itemTypeFile,self.itemTypeListDir)
        self.assertEqual(os.path.join(controller.itemListDir,"ex.json"), controller.list2FileName("ex"))
        self.assertEqual("hex",controller.file2ListName("hex.json"))  
        self.assertEqual("hex",controller.file2ListName(os.path.join(controller.itemListDir,"hex.json")))  

    def testLoad(self):
        print("testLoad")
        controller = ItemTypeController(itemtype,self.itemTypeFile,self.itemTypeListDir)
        controller.load()
        self.assertTrue("food" in controller.getList())

    def testLoadOnEmpty(self):
        print("testLoad")
        self.cleanUp()
        controller = ItemTypeController(itemtype,self.itemTypeFile,self.itemTypeListOuDir)
        controller.load()
        self.assertTrue("food" in controller.getList())
        self.assertTrue(os.path.exists(controller.list2FileName("food")))
        self.assertTrue("household" in controller.getList())
        self.assertTrue(os.path.exists(controller.list2FileName("household")))
        self.assertTrue(os.path.exists(controller.list2FileName("entertainment")))

    def testAdd(self):
        print("testAdd")
        controller = ItemTypeController(itemtype,self.itemTypeFile,self.itemTypeListDir)
        controller.load()
        controller.itemListDir = self.itemTypeListOuDir
        controller.filePath = self.itemTypeOutFile
        controller.add({"Id":5,"Name":"Dummy"})
        self.assertTrue("Dummy" in controller.getList().keys())
        self.assertTrue(os.path.exists(controller.list2FileName("Dummy")))
        self.assertTrue(len(controller.getList()) == 4)

    def testDuplicateAdd(self):
        controller = ItemTypeController(itemtype,self.itemTypeFile,self.itemTypeListDir)
        controller.load()
        controller.itemListDir = self.itemTypeListOuDir
        controller.filePath = self.itemTypeOutFile
        ret = controller.add({"Id":5,"Name":"Dummy"})
        self.assertTrue(ret == True)
        ret = controller.add({"Id":5,"Name":"Dummy"})
        self.assertTrue(ret == False)
        self.assertTrue(len(controller.getList()) == 4)

    def testRename(self):
        controller = ItemTypeController(itemtype,self.itemTypeFile,self.itemTypeListDir)
        controller.load()
        controller.itemListDir = self.itemTypeListOuDir
        controller.filePath = self.itemTypeOutFile
        ret = controller.rename("food","feeed")
        self.assertTrue(ret == True)
        self.assertTrue("feeed" in controller.getList())
        self.assertTrue("food" not in controller.getList())
        self.assertTrue(len(controller.getList()) == 3)    
        self.assertTrue(os.path.exists(controller.list2FileName("feeed")))
        self.assertFalse(os.path.exists(controller.list2FileName("food")))

    def testStore(self):
        controller = ItemTypeController(itemtype,self.itemTypeFile,self.itemTypeListDir)
        controller.load()
        controller.itemListDir = self.itemTypeListOuDir
        controller.filePath = self.itemTypeOutFile        
        controller.store()
  
if __name__ == '__main__':
    unittest.main()