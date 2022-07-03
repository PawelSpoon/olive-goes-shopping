import os
import unittest
import sys
sys.path.append('../src')


from storage import persistance


from controller.shoppinglistcontroller import ShoppingListController
from controller.constants import *

class ShoppingListControllerTest(unittest.TestCase):
     
    rootDir = "./src/assets"
    currentDir = os.path.join(rootDir, currentDir)
    demoPath = os.path.join(currentDir, "demo.shop.json")

    def setUp(self) -> None:
        return super().setUp()
        
    # Returns True or False. 
    def test(self):        
        self.assertTrue(True)

    def testCreation(self):
        controller = ShoppingListController("demo",self.demoPath,self.rootDir)
        self.assertTrue(controller.getTypeName() == "demo")  
        self.assertTrue(controller.rootDir == self.rootDir)  

    def testLoad(self):
        controller = ShoppingListController("demo",self.demoPath,self.rootDir)     
        controller.load()
        self.assertEqual(2,len(controller.getList().keys()))

    def testAddDouble(self):
        controller = ShoppingListController("demo",self.demoPath,self.rootDir)
        controller.load()
        self.assertEqual(2,len(controller.getList().keys()))             
        controller.addItems2ShoppingList(persistance.readItems(self.demoPath).values())
        self.assertEqual(2,len(controller.getList().keys()))
        self.assertEqual(2,controller.getList()["Condoms"][FieldAmount])
        self.assertEqual(2,controller.getList()["Beer"][FieldAmount])

    def testAddDoubleWithModUnit(self):
        controller = ShoppingListController("demo",self.demoPath,self.rootDir)     
        controller.load()
        # load to have a file to modify
        second = persistance.readItems(self.demoPath)
        second["Condoms"][FieldUnit] = "10er"
        second["Beer"][FieldUnit] = "-"
        controller.addItems2ShoppingList(second.values())
        self.assertEqual(2,len(controller.getList()))
        self.assertEqual(11,controller.getList()["Condoms"][FieldAmount])
        self.assertEqual(1.1,controller.getList()["Beer"][FieldAmount])

    def testAddDoubleWithModNotFittingUnit(self):
        controller = ShoppingListController("demo",self.demoPath,self.rootDir)     
        controller.load()
        second = persistance.readItems(self.demoPath)
        second["Beer"][FieldUnit] = "l"
        controller.addItems2ShoppingList(second.values())
        self.assertEqual(3,len(controller.getList()))
        self.assertEqual(2,controller.getList()["Condoms"][FieldAmount])
        self.assertEqual(1,controller.getList()["Beer"][FieldAmount])
        self.assertEqual(1,controller.getList()["Beer:l"][FieldAmount])

if __name__ == '__main__':
    unittest.main()