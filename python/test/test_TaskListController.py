import os
import unittest
import sys
from controller.assetmanager import AssetManager
sys.path.append('../src')

from storage import persistance
from controller.constants import *
from testconstants import *
from controller.tasklistcontroller import TaskListController
from storage.persistance import readEnums, readItems, storeEnums, storeItems

class TaskListControllerTest(unittest.TestCase):
  
    rootDir = "./src/assets"
    outDir = "./test/test-out"
    currentDir = os.path.join(rootDir, currentDir)
    brevafilePath = os.path.join(currentDir, tasklistBreva + ".task.json")
    testOutDir = "./test/test-out"
    testTemplateDir = os.path.join(testOutDir, "tasklist")

    def setUp(self) -> None:
        return super().setUp()
        
    # Returns True or False. 
    def test(self):        
        self.assertTrue(True)
    
    def testCreation(self):
        print('testCreation')
        manager = TaskListController(tasklistBreva,self.brevafilePath)
        #self.assertTrue(manager.rootDir == self.rootDir)
        self.assertTrue(manager.getTypeName() == tasklistBreva)

    def testLoad(self):
        print('testLoad')
        manager = TaskListController(tasklistBreva,self.brevafilePath)
        manager.load()
        self.assertEqual(2,len(manager.getList().keys()))
        self.assertTrue("Oil change" in manager.getList().keys())
  
    def testAddItem(self):
        manager = TaskListController(tasklistBreva,self.brevafilePath)       
        manager.load()
        manager.add({"Name":"olive","Done":False})
        self.assertTrue("olive" in manager.items.keys())
        manager.rootDir = self.outDir
        persistance.storeItems(self.outDir + "/current/olive.shop.json",manager.getList())


    def testRemoveItem(self):
        manager = TaskListController(tasklistBreva,self.brevafilePath)   
        manager.load()
        manager.add({"Name":"maja","Done":False})
        self.assertTrue("maja" in manager.getList().keys())
        manager.remove("maja")
        self.assertFalse("maja" in manager.getList().keys())
 
    def testMarkAndSetAsDone(self):
        manager = TaskListController(tasklistBreva,self.brevafilePath)   
        manager.load()
        manager.add({"Name":"maja","Done":False})
        self.assertTrue("maja" in manager.getList().keys())
        self.assertTrue(manager.getList()["maja"][FieldDone] == False)
        manager.markAsDone("maja")
        self.assertTrue("maja" in manager.getList().keys())
        self.assertTrue(manager.getList()["maja"][FieldDone] == True)
        manager.setDoneValue("maja",False)
        self.assertTrue(manager.getList()["maja"][FieldDone] == False)
        manager.setDoneValue("maja",True)
        self.assertTrue(manager.getList()["maja"][FieldDone] == True)
        manager.resetDone()
        self.assertTrue(manager.getList()["maja"][FieldDone] == False)    

    # test removing done items from shopping list
    def testClearDone(self):
        manager = TaskListController(tasklistBreva,self.brevafilePath)   
        manager.load()
        manager.add({"Name":"maja","Done":False})
        self.assertTrue("maja" in manager.getList().keys())
        self.assertTrue(manager.getList()["maja"][FieldDone] == False)
        manager.setDoneValue("maja",True)
        manager.clearDone()
        self.assertFalse("maja" in manager.getList().keys())

    # add from a second list list
    def testAddItems2TaskList(self):
        manager = TaskListController(tasklistBreva,self.brevafilePath)   
        manager.load()
        manager.setDoneValue("Oil change",True)
        self.assertTrue(manager.getList()["Oil change"][FieldDone] == True)
        secondmanager = TaskListController(tasklistBreva, self.brevafilePath)
        secondmanager.load()
        secondmanager.add({"Name":"Coolant change","Done":False})
        manager.addItems2TaskList(secondmanager.getList())
        self.assertTrue(manager.getList()["Oil change"][FieldDone] == False)
        self.assertTrue("Coolant change" in manager.getList().keys())

    def testDeleteNonExistingOne(self):
        manager = TaskListController(tasklistBreva,self.brevafilePath)   
        manager.load()
        manager.setDoneValue("Oil change",True) 
        self.assertTrue(manager.getList()["Oil change"][FieldDone] == True)
        self.assertFalse(manager.deleteOne("something"))    

    def testDeleteExistingOne(self):
        controller = TaskListController(tasklistBreva,self.brevafilePath)   
        controller.load()
        controller.setDoneValue("Oil change",True) 
        self.assertTrue(controller.getList()["Oil change"][FieldDone] == True)
        self.assertTrue(controller.deleteOne("Oil change"))     
        self.assertEqual(1,len(controller.getAsList()))   

    def testTemplateCreationFromExisting(self):
        # should create a copy in templtes folder
        # and name should appear in getTemplateNames
        # os.remove(os.path.join(self.testTemplateDir,"Breva-copy.json"))
        manager = AssetManager(self.testOutDir)
        manager.load()
        templates = manager.getTemplateListNames(tasklistType)
        self.assertEqual(2,len(templates))         

        controller = TaskListController(tasklistBreva,self.brevafilePath)   
        controller.load()
        # controller.export(os.path.join(self.testTemplateDir,"Breva-copy.json"))
        manager.createTemplate(controller.items,tasklistType,"Breva-copy")
        manager.load()
        templates = manager.getTemplateListNames(tasklistType)
        self.assertEqual(3,len(templates))   



if __name__ == '__main__':
    unittest.main()