import unittest
import sys
sys.path.append('../src')


from storage import persistance


from controller.shoppinglistcontroller import ShoppingListController
from controller.constants import *

class ShoppingListControllerTest(unittest.TestCase):
     
    rootDir = "../src/assets"
    janPath = rootDir + currentDirPath + "/jan.shop.json"

    def setUp(self) -> None:
        return super().setUp()
        
    # Returns True or False. 
    def test(self):        
        self.assertTrue(True)

    def testCreation(self):
        controller = ShoppingListController("jan",self.rootDir)
        self.assertTrue(controller.getItemName() == "jan")  
        self.assertTrue(controller.rootDir == self.rootDir)  

    def testLoad(self):
        controller = ShoppingListController("jan",self.rootDir)     
        controller.load( persistance.readItems(self.janPath))
        self.assertEqual(2,len(controller.getList()))

    def testAddDouble(self):
        controller = ShoppingListController("jan",self.rootDir)     
        controller.load(persistance.readItems(self.janPath))
        controller.addShoppingList(persistance.readItems(self.janPath))
        self.assertEqual(2,len(controller.getList()))
        self.assertEqual(2,controller.getList()["Condoms"][FieldAmount])
        self.assertEqual(2,controller.getList()["Beer"][FieldAmount])

    def testAddDoubleWithModUnit(self):
        controller = ShoppingListController("jan",self.rootDir)     
        controller.load(persistance.readItems(self.janPath))
        second = persistance.readItems(self.janPath)
        second["Condoms"][FieldUnit] = "10er"
        second["Beer"][FieldUnit] = "-"
        controller.addShoppingList(second)
        self.assertEqual(2,len(controller.getList()))
        self.assertEqual(11,controller.getList()["Condoms"][FieldAmount])
        self.assertEqual(1.1,controller.getList()["Beer"][FieldAmount])

    def testAddDoubleWithModNotFittingUnit(self):
        controller = ShoppingListController("jan",self.rootDir)     
        controller.load(persistance.readItems(self.janPath))
        second = persistance.readItems(self.janPath)
        second["Beer"][FieldUnit] = "l"
        controller.addShoppingList(second)
        self.assertEqual(3,len(controller.getList()))
        self.assertEqual(2,controller.getList()["Condoms"][FieldAmount])
        self.assertEqual(1,controller.getList()["Beer"][FieldAmount])
        self.assertEqual(1,controller.getList()["Beer:l"][FieldAmount])

if __name__ == '__main__':
    unittest.main()