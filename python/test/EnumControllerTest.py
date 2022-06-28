import unittest
import sys
sys.path.append('../src')

from controller.enumcontroller import EnumController
from storage.persistance import readEnums, readItems, storeEnums, storeItems

class EnumControllerTest(unittest.TestCase):
  
    categoryFile = "../src/assets/category.json"
    unitFile = "../src/assets/unit.json"
    categoryOutFile = "./test-out/category.json"
    unitOutFile = "./test-out/unit.json"

    def setUp(self) -> None:
        return super().setUp()
        

    def testCreation(self):
        print("create controller")
        controller = EnumController("category")
        self.assertTrue(controller.getEnumName() == "category")  

    def testLoad(self):
        enums = readEnums(self.categoryFile)
        self.assertTrue("Meat" in enums)
        controller = EnumController("category")
        controller.load(enums)
        self.assertTrue("Meat" in controller.getList())

    def testAdd(self):
        enums = readEnums(self.categoryFile)
        self.assertTrue("Meat" in enums)
        controller = EnumController("category")
        controller.load(enums)
        controller.add("me")
        self.assertTrue("me" in controller.getList())

    def testDuplicateAdd(self):
        enums = readEnums(self.categoryFile)
        self.assertTrue("Meat" in enums)
        controller = EnumController("category")
        controller.load(enums)
        ret = controller.add("Meat")
        self.assertTrue(ret == False)
        self.assertTrue(len(controller.getList()) == 3)

    def testRename(self):
        enums = readEnums(self.categoryFile)
        self.assertTrue("Meat" in enums)
        controller = EnumController("category")
        controller.load(enums)
        ret = controller.rename("Meat","Muschi")
        self.assertTrue(ret == True)
        self.assertTrue("Muschi" in controller.getList())
        self.assertTrue("Meat" not in controller.getList())
        self.assertTrue(len(controller.getList()) == 3)    
        ret = controller.rename("Meat","Maus")  
        self.assertTrue(ret == False)  
        self.assertTrue("Maus" not in controller.getList())

    def testStore(self):
        enums = readEnums(self.categoryFile)
        self.assertTrue("Meat" in enums)
        controller = EnumController("category")
        controller.load(enums)
        ret = controller.rename("Meat","Muschi")
        storeEnums(self.categoryOutFile, controller.getList())
        ##
        enums = readEnums(self.unitFile)
        controller = EnumController("unit")
        controller.load(enums)
        storeEnums(self.unitOutFile, controller.getList())
  
if __name__ == '__main__':
    unittest.main()