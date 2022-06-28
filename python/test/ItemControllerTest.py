import unittest
import sys
sys.path.append('../src')

from controller.itemcontroller import ItemController
from controller.enumcontroller import EnumController
from storage.persistance import readEnums, readItems, storeEnums, storeItems

class ItemControllerTest(unittest.TestCase):
  
    foodFile = "../src/assets/item/food.json"
    foodOutFile = "./test-out/food.json"

    def setUp(self) -> None:
        return super().setUp()
        

    def testCreation(self):
        print("testCreation")
        controller = ItemController("food")
        self.assertTrue(controller.getItemName() == "food")  

    def testLoad(self):
        print("testLoad")
        enums = readItems(self.foodFile)
        self.assertTrue("Potato" in enums)
        controller = ItemController("food")
        controller.load(enums)
        self.assertTrue("Potato" in controller.getList())

    def testAdd(self):
        print("testAdd")
        enums = readItems(self.foodFile)
        self.assertTrue("Potato" in enums)
        controller = ItemController("food")
        controller.load(enums)
        controller.add({"Name":"me"})
        self.assertTrue("me" in controller.getList().keys())

    def testDuplicateAdd(self):
        enums = readItems(self.foodFile)
        controller = ItemController("food")
        controller.load(enums)
        ret = controller.add({"Name": "Potato"})
        self.assertTrue(ret == False)
        self.assertTrue(len(controller.getList()) == 2)

    def testRename(self):
        enums = readItems(self.foodFile)
        controller = ItemController("food")
        controller.load(enums)
        ret = controller.rename("Potato","Pitato")
        self.assertTrue(ret == True)
        self.assertTrue("Pitato" in controller.getList())
        self.assertTrue("Potato" not in controller.getList())
        self.assertTrue(len(controller.getList()) == 2)    
        ret = controller.rename("Potato","Patata")  
        self.assertTrue(ret == False)  
        self.assertTrue("Patata" not in controller.getList())

    def testStore(self):
        enums = readItems(self.foodFile)
        controller = ItemController("food")
        controller.load(enums)
        ret = controller.rename("Potato","Patata")
        storeItems(self.foodOutFile, controller.getList())
  
if __name__ == '__main__':
    unittest.main()