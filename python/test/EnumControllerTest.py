import unittest
import sys
sys.path.append('../src')

from controller.enumcontroller import EnumController
from storage.persistance import readEnums, readItems, storeEnums, storeItems
from controller.constants import *

class EnumControllerTest(unittest.TestCase):
  
    phydimFile = "../src/assets/phydim.json"
    phydimOutFile = "./test-out/phydim.json"
    itemtypeFile = "../src/assets/itemtype.json"
    itemtypeOutFile = "./test-out/itemtype.json"  

    def setUp(self) -> None:
        return super().setUp()
        

    def testCreation(self):
        print("create controller")
        controller = EnumController(phydim)
        self.assertTrue(controller.getEnumName() == phydim)  

    def testLoad(self):
        enums = readEnums(self.phydimFile)
        self.assertTrue("Volume" in enums)
        controller = EnumController(phydim)
        controller.load(enums)
        self.assertTrue("Volume" in controller.getList())

    def testAdd(self):
        enums = readEnums(self.phydimFile)
        self.assertTrue("Volume" in enums)
        controller = EnumController(phydim)
        controller.load(enums)
        controller.add("me")
        self.assertTrue("me" in controller.getList())

    def testDuplicateAdd(self):
        enums = readEnums(self.phydimFile)
        self.assertTrue("Length" in enums)
        controller = EnumController(phydim)
        controller.load(enums)
        ret = controller.add("Length")
        self.assertTrue(ret == False)
        self.assertTrue(len(controller.getList()) == 4)

    def testRename(self):
        enums = readEnums(self.phydimFile)
        self.assertTrue("Weight" in enums)
        controller = EnumController(phydim)
        controller.load(enums)
        ret = controller.rename("Weight","Muschi")
        self.assertTrue(ret == True)
        self.assertTrue("Muschi" in controller.getList())
        self.assertTrue("Weight" not in controller.getList())
        self.assertTrue(len(controller.getList()) == 4)    
        ret = controller.rename("Weight","Maus")  
        self.assertTrue(ret == False)  
        self.assertTrue("Maus" not in controller.getList())

    def testStore(self):
        enums = readEnums(self.phydimFile)
        self.assertTrue("Weight" in enums)
        controller = EnumController(phydim)
        controller.load(enums)
        ret = controller.rename("Weight","Muschi")
        storeEnums(self.phydimOutFile, controller.getList())
        ##
        enums = readEnums(self.itemtypeFile)
        controller = EnumController(itemtype)
        controller.load(enums)
        storeEnums(self.itemtypeOutFile, controller.getList())
  
if __name__ == '__main__':
    unittest.main()