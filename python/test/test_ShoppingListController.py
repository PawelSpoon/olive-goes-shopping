import os
import unittest
import sys
from controller.assetmanager import AssetManager
sys.path.append('../src')


from storage import persistance


from controller.shoppinglistcontroller import ShoppingListController
from controller.constants import *

class ShoppingListControllerTest(unittest.TestCase):
     
    rootDir = "./src/assets"
    currentDir = os.path.join(rootDir, currentDir)
    demoPath = os.path.join(currentDir, "demo.shop.json")
    testOutDir = "./test/test-out"
    testTemplateDir = os.path.join(testOutDir, "shoplist")

    def setUp(self):
        super().setUp()
        try:
            os.remove(os.path.join(self.testTemplateDir, "demo-copy.json"))  
        except OSError as e: # name the Exception `e`
            print("Failed with:", e.strerror) # look what it says       
        try:
            os.remove(os.path.join(self.testTemplateDir, "empty-copy.json"))  
        except OSError as e: # name the Exception `e`
            print("Failed with:", e.strerror) # look what it says   
        
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
        controller.addItems2List(persistance.readItems(self.demoPath).values())
        self.assertEqual(2,len(controller.getList().keys()))
        self.assertEqual(2,controller.getList()["Condoms"][FieldAmount])
        self.assertEqual(2,controller.getList()["Beer"][FieldAmount])

    def testAddDoubleWithModUnit(self):
        controller = ShoppingListController("demo",self.demoPath,self.rootDir)     
        controller.load()
        # load to have a file to modify
        second = persistance.readItems(self.demoPath)
        second["Condoms"][FieldUnit] = "10"
        second["Beer"][FieldUnit] = "-"
        controller.addItems2List(second.values())
        self.assertEqual(2,len(controller.getList()))
        self.assertEqual(11,controller.getList()["Condoms"][FieldAmount])
        self.assertEqual(1.1,controller.getList()["Beer"][FieldAmount])

    def testAddDoubleWithModNotFittingUnit(self):
        controller = ShoppingListController("demo",self.demoPath,self.rootDir)     
        controller.load()
        second = persistance.readItems(self.demoPath)
        second["Beer"][FieldUnit] = "l"
        controller.addItems2List(second.values())
        self.assertEqual(3,len(controller.getList()))
        self.assertEqual(2,controller.getList()["Condoms"][FieldAmount])
        self.assertEqual(1,controller.getList()["Beer"][FieldAmount])
        self.assertEqual(1,controller.getList()["Beer:l"][FieldAmount])

    def testTemplateCreationFromExisting(self):
        # should create a copy in templtes folder
        # and name should appear in getTemplateNames   
        manager = AssetManager(self.testOutDir)
        manager.load()
        templates = manager.getTemplateListNames(shoplistType)
        self.assertEqual(1,len(templates))         

        controller = ShoppingListController("demo",self.demoPath,self.rootDir)  
        controller.load()
        manager.createTemplate(controller.items,shoplistType,"demo-copy")
        templates = manager.getTemplateListNames(shoplistType)
        self.assertEqual(2,len(templates))   


    def testTemplateCreationEmpty(self):
        # should create a copy in templtes folder
        # and name should appear in getTemplateNames   
        manager = AssetManager(self.testOutDir)
        manager.load()
        templates = manager.getTemplateListNames(shoplistType)
        self.assertEqual(1,len(templates))         

        manager.createTemplate(None,shoplistType,"empty-copy")
        templates = manager.getTemplateListNames(shoplistType)
        self.assertEqual(2,len(templates))   

if __name__ == '__main__':
    unittest.main()