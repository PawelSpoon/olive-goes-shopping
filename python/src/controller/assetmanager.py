# this is the guy who controlls the all the pre-conditions:
# catagories
# item types
# recipes
# pre defined task lists

import os
from controller.constants import *
from controller.enumcontroller import EnumController
from controller.folderitemcontroller import FolderItemController
from controller.itemcontroller import ItemController
from storage import persistance


class AssetManager:
    def __init__(self, root) -> None:
        self.rootDir = root
        self.catController = ItemController(category,self.rootDir + categoryFilePath) # due to ordernr
        self.itemtypeController = ItemController(itemtype, self.rootDir + itemtypeFilePath) #due to id
        self.unitController = ItemController(unit, self.rootDir + unitFilePath) # due to id
        self.phydimController = EnumController(phydim,self.rootDir + phydimFilePath)
        # multiple itemControllers
        self.itemControllerDict = dict()
        # one recipe controller
        self.recipeController = FolderItemController(recipe,os.path.join(self.rootDir,recipeDir))
        # multiple task list controler
        self.taskitemController = dict()

    def getRecipePath(self):
        return self.rootDir + recipeDirPath

    def getTaskPath(self):
        return self.rootDir + tasklistDirPath

    def load(self):
        print('asset manager loading from: ' + self.rootDir)
        # simple string
        self.phydimController.load()
        # complex type
        self.catController.load()
        self.itemtypeController.load()        
        self.unitController.load()

        for type in self.itemtypeController.getList().keys():
            # for each item type create an controller and load it
            temp = ItemController(type,os.path.join(self.rootDir, "item", type + '.json'))
            print(type)
            temp.load()
            self.itemControllerDict[type] = temp

        # recipe conroller needs an own loader that loads all files from a folder into controller
        # ..
        self.recipeController.load()


        # predefined task list takes over the name from file
        # get all files from /list folder and init multiple itemcontrollers
        # to be done later
        # self.taskitemController...
        tasklists = os.listdir(self.getTaskPath())
        for tasklist in tasklists:
            tmp = persistance.readItems(self.getTaskPath() + "/" + tasklist)
            self.taskitemController[tasklist.replace(".json","")] = tmp
    
    def getController(self, type):
        if (type == phydim):
            return self.phydimController
        if (type == unit):
            return self.unitController
        if (type == category):
            return self.catController
        if (type == recipe):
            return self.recipeController
        if (type == itemtype):
            return self.itemtypeController
        # first look in itemtypes
        if (type in self.itemControllerDict.keys()):
            return self.itemControllerDict[type]
        if (type in self.taskitemController.keys()):
            return self.taskitemController[type]
        print("not found")
        return None
        # second look lists
        # shall we look into active too ?
        # no this i another controller

    # not used as the controller copies contain data not the managers ones
    def store(self):
        return
        print('asset manager storing to: ' + self.rootDir)
        persistance.storeItems(self.rootDir + categoryFilePath,self.catController.getList())
        persistance.storeItems(self.rootDir + itemtypeFilePath,self.itemtypeController.getList())
        persistance.storeEnums(self.rootDir + phydimFilePath  ,self.phydimController.getList())
        persistance.storeItems(self.rootDir + unitFilePath   ,self.unitController.getList())

        for type in self.itemtypeController.getList().keys():
            # for each item type get the controller and store
            temp = self.itemControllerDict[type]
            if temp != None:
                temp.store()

        for item in self.recipeController.getList().values():
            persistance.storeObject(self.getRecipePath() + "/" + item["Name"] + ".json", item)

        for item in self.taskitemController.keys():
            persistance.storeItems(self.getTaskPath() + "/" + item + ".json", self.taskitemController[item])



        