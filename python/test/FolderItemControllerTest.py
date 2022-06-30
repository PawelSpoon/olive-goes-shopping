import os
import unittest
import sys
sys.path.append('../src')

from controller.folderitemcontroller import FolderItemController
from storage.persistance import readItems

class FolderItemControllerTest(unittest.TestCase):
  
    recipeDir = "../src/assets/recipe"
    recipeOutDir = "./test-out/recipe"

    def setUp(self) -> None:
        self.cleanUp()
        return super().setUp()
        

    def cleanUp(self):
        files = os.listdir(FolderItemControllerTest.recipeOutDir)
        for file in files:
            os.remove(os.path.join(FolderItemControllerTest.recipeOutDir, file))  

    def testCreation(self):
        print("testCreation")
        controller = FolderItemController("recipe",self.recipeDir)
        self.assertTrue(controller.getTypeName() == "recipe")  

    def testLoad(self):
        print("testLoad")
        controller = FolderItemController("recipe",self.recipeDir)
        controller.load()
        self.assertTrue("Krautsuppe" in controller.items.keys())
        self.assertTrue("Krautsuppe" in controller.getList().keys())

    def testAdd(self):
        print("testAdd")
        controller = FolderItemController("recipe",self.recipeDir)
        controller.load()
        self.assertTrue(controller.add({"Name":"me"}))
        self.assertTrue("me" in controller.getList().keys())

    def testDuplicateAdd(self):
        controller = FolderItemController("recipe",self.recipeDir)
        controller.load()
        self.assertTrue(len(controller.getList()) == 2)
        self.assertTrue("Krautsuppe" in controller.getList().keys())
        ret = controller.add({"Name": "Krautsuppe"})
        self.assertTrue(ret == False)
        print(len(controller.getList()))
        self.assertTrue(len(controller.getList()) == 2)

    def testRename(self):
        controller = FolderItemController("recipe",self.recipeDir)
        controller.load()
        controller.filePath = self.recipeOutDir
        controller.store()
        ret = controller.rename("Krautsuppe","Kartoffelsuppe")
        self.assertTrue(ret == True)
        self.assertTrue("Kartoffelsuppe" in controller.getList())
        self.assertTrue("Krautsuppe" not in controller.getList())
        self.assertTrue(len(controller.getList()) == 2)    
        ret = controller.rename("Krautsuppe","Patata")  
        self.assertTrue(ret == False)  
        self.assertTrue("Patata" not in controller.getList())

    def testStore(self):
        controller = FolderItemController("recipe",self.recipeDir)
        controller.load()
        controller.filePath = self.recipeOutDir
        controller.store() # basically copies to file to our dir, needed for rename tests
        ret = controller.rename("Krautsuppe","Patata")
        self.assertTrue(ret)
        controller.store()

    def testUpdate(self):
        controller = FolderItemController("recipe",self.recipeDir)
        controller.load()
        controller.filePath = self.recipeOutDir
        controller.store()
        ret = controller.update("Krautsuppe",{"Name": "Patata", "Servings": 3, "Category": "Soup", "Rating": 9, "Ingredients": [{"Name": "Kraut", "Amount": "1", "Unit": "-"}], "HowTo": "This very long text describes the cooking process"})
        self.assertTrue(ret)
        controller.store()

  
if __name__ == '__main__':
    unittest.main()