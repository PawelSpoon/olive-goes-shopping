import unittest
import sys
sys.path.append('../src')

from controller.itemcontroller import ItemController
from storage.persistance import readItems

class ItemControllerTest(unittest.TestCase):
  
    foodFile = "./src/assets/item/food.json"
    foodOutFile = "./test/test-out/food.json"

    def setUp(self) -> None:
        return super().setUp()
        

    def testCreation(self):
        print("testCreation")
        controller = ItemController("food",self.foodFile)
        self.assertTrue(controller.getTypeName() == "food")  

    def testLoad(self):
        print("testLoad")
        enums = readItems(self.foodFile)
        self.assertTrue("potatoes" in enums)
        controller = ItemController("food",self.foodFile)
        controller.loadString(enums)
        self.assertTrue("potatoes" in controller.getList())
        self.assertTrue("potatoes" in controller.getKeys())
        test = controller.getAsList()
        for t in test:
            print(t)

    def testAdd(self):
        print("testAdd")
        controller = ItemController("food",self.foodFile)
        controller.load()
        self.assertTrue("potatoes" in controller.getList().keys())
        self.assertTrue(controller.add({'Name':"me"}))
        self.assertTrue("me" in controller.getList().keys())

    def testDuplicateAdd(self):
        controller = ItemController("food",self.foodFile)
        controller.load()
        ret = controller.add({"Name": "potatoes"})
        self.assertTrue(ret == False)
        self.assertEqual(len(controller.getList()),107)

    def testRename(self):
        enums = readItems(self.foodFile)
        controller = ItemController("food",self.foodFile)
        controller.loadString(enums)
        ret = controller.rename("potatoes","Pitato")
        self.assertTrue(ret == True)
        self.assertTrue("Pitato" in controller.getList())
        self.assertTrue("potatoes" not in controller.getList())
        self.assertEqual(len(controller.getList()),107)    
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
        controller.update('apple',{ 'Name': 'apple', 'Unit': {'Id': '4', 'Name':'lbs'}})
        self.assertTrue(controller.getList()['apple']['Unit']['Name']=='lbs')

    def testRenameFoodWithUnit(self):
        controller = ItemController("food",self.foodFile)
        controller.load()
        ret = controller.update('apple',{ 'Name': 'Pear', 'Unit': {'Id': '4', 'Name':'lbs'}})
        self.assertTrue(ret)
        self.assertTrue(controller.getList()['Pear']['Unit']['Name']=='lbs')   
        self.assertEqual(len(controller.getList().keys()), 107)  

    def testRenameFoodWithUnitWithConflict(self):
        controller = ItemController("food",self.foodFile)
        controller.load()
        ret = controller.update('apple',{ 'Name': 'potatoes', 'Unit': {'Id': '4', 'Name':'lbs'}})
        self.assertFalse(ret)
        self.assertTrue(controller.getList()['potatoes']['Unit']['Name']=='kg')   
        self.assertEqual(len(controller.getList().keys()), 107)   

    #def testInvAdd(self):
    #    print("testInvAdd")
    #    controller = ItemController("food",self.foodFile)
    #    controller.load()
    #    self.assertRaise(Exception,controller.add("Name"))
  
if __name__ == '__main__':
    unittest.main()