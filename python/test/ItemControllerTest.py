import unittest
import sys
sys.path.append('../src')

from controller.itemcontroller import ItemController
from storage.persistance import readItems

class ItemControllerTest(unittest.TestCase):
  
    foodFile = "../src/assets/item/food.json"
    foodOutFile = "./test-out/food.json"

    def setUp(self) -> None:
        return super().setUp()
        

    def testCreation(self):
        print("testCreation")
        controller = ItemController("food",self.foodFile)
        self.assertTrue(controller.getTypeName() == "food")  

    def testLoad(self):
        print("testLoad")
        enums = readItems(self.foodFile)
        self.assertTrue("Potato" in enums)
        controller = ItemController("food",self.foodFile)
        controller.loadString(enums)
        self.assertTrue("Potato" in controller.getList())
        test = controller.getAsList()
        for t in test:
            print(t)

    def testAdd(self):
        print("testAdd")
        controller = ItemController("food",self.foodFile)
        controller.load()
        self.assertTrue("Potato" in controller.getList().keys())
        self.assertTrue(controller.add({'Name':"me"}))
        self.assertTrue("me" in controller.getList().keys())

    def testDuplicateAdd(self):
        controller = ItemController("food",self.foodFile)
        controller.load()
        ret = controller.add({"Name": "Potato"})
        self.assertTrue(ret == False)
        self.assertTrue(len(controller.getList()) == 2)

    def testRename(self):
        enums = readItems(self.foodFile)
        controller = ItemController("food",self.foodFile)
        controller.loadString(enums)
        ret = controller.rename("Potato","Pitato")
        self.assertTrue(ret == True)
        self.assertTrue("Pitato" in controller.getList())
        self.assertTrue("Potato" not in controller.getList())
        self.assertTrue(len(controller.getList()) == 2)    
        ret = controller.rename("Potato","Patata")  
        self.assertTrue(ret == False)  
        self.assertTrue("Patata" not in controller.getList())

    def testStore(self):
        controller = ItemController("food",self.foodFile)
        controller.load()
        ret = controller.rename("Potato","Patata")
        controller.filePath = self.foodOutFile
        controller.store()

    def testUpdateFoodWithUnit(self):
        controller = ItemController("food",self.foodFile)
        controller.load()
        controller.update('Apple',{ 'Name': 'Apple', 'Unit': {'Id': '4', 'Name':'pound'}})
        self.assertTrue(controller.getList()['Apple']['Unit']['Name']=='pound')

    def testRenameFoodWithUnit(self):
        controller = ItemController("food",self.foodFile)
        controller.load()
        ret = controller.update('Apple',{ 'Name': 'Pear', 'Unit': {'Id': '4', 'Name':'pound'}})
        self.assertTrue(ret)
        self.assertTrue(controller.getList()['Pear']['Unit']['Name']=='pound')   
        self.assertTrue(len(controller.getList().keys()) == 2)  

    def testRenameFoodWithUnitWithConflict(self):
        controller = ItemController("food",self.foodFile)
        controller.load()
        ret = controller.update('Apple',{ 'Name': 'Potato', 'Unit': {'Id': '4', 'Name':'pound'}})
        self.assertFalse(ret)
        self.assertTrue(controller.getList()['Potato']['Unit']['Name']=='kg')   
        self.assertTrue(len(controller.getList().keys()) == 2)   

    #def testInvAdd(self):
    #    print("testInvAdd")
    #    controller = ItemController("food",self.foodFile)
    #    controller.load()
    #    self.assertRaise(Exception,controller.add("Name"))
  
if __name__ == '__main__':
    unittest.main()