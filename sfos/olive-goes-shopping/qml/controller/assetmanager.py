# this is the guy who controlls the all the pre-conditions:
# catagories
# item types
# recipes
# pre defined task lists

import os
from controller.constants import *
from controller.enumcontroller import EnumController
from controller.itemcontroller import ItemController
from storage import persistance


class AssetManager:
    def __init__(self, root) -> None:
        self.rootDir = root
        self.catController = ItemController(category) # due to ordernr
        self.itemtypeController = ItemController(itemtype) #due to id
        self.unitController = ItemController(unit) # due to id
        self.phydimController = EnumController(phydim)
        # multiple itemControllers
        self.itemControllerDict = dict()
        # one recipe controller
        self.recipeController = ItemController(recipe)
        # multiple task list controler
        self.taskitemController = dict()

    def getRecipePath(self):
        return self.rootDir + recipeDirPath

    def getTaskPath(self):
        return self.rootDir + tasklistDirPath

    def load(self):
        print('asset manager loading from: ' + self.rootDir)
        # simple string
        self.phydimController.load(persistance.readEnumsIfExists(self.rootDir + phydimFilePath))
        # complex type
        self.catController.load(persistance.readItemsIfExists(self.rootDir + categoryFilePath))
        self.itemtypeController.load(persistance.readItemsIfExists(self.rootDir + itemtypeFilePath))        
        self.unitController.load(persistance.readItemsIfExists(self.rootDir + unitFilePath))

        for type in self.itemtypeController.getList().keys():
            # for each item type create an controller and load it
            temp = ItemController(type)
            print(type)
            temp.load(persistance.readItemsIfExists(self.rootDir + '/item/' + type + '.json'))
            self.itemControllerDict[type] = temp

        # recipe conroller needs an own loader that loads all files from a folder into controller
        # ..
        #self.recipeController.load(self.rootDir + '/recipe')
        recipes = os.listdir(self.getRecipePath())
        for recipe in recipes:
            tmp = persistance.readObject(self.getRecipePath() + "/" + recipe)
            self.recipeController.add(tmp)

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
        if (type == "recipe"):
            return self.recipeController
        if (type == "itemtype"):
            return self.itemtypeController
        # first look in itemtypes
        if (type in self.itemControllerDict.keys()):
            return self.itemControllerDict[type]
        if (type in self.taskitemController.keys()):
            return self.taskitemController[type]
        # second look lists
        # shall we look into active too ?
        # no this i another controller

    def store(self):
        print('asset manager storing to: ' + self.rootDir)
        persistance.storeItems(self.rootDir + categoryFilePath,self.catController.getList())
        persistance.storeItems(self.rootDir + itemtypeFilePath,self.itemtypeController.getList())
        persistance.storeEnums(self.rootDir + phydimFilePath  ,self.phydimController.getList())
        persistance.storeItems(self.rootDir + unitFilePath   ,self.unitController.getList())

        for type in self.itemtypeController.getList().keys():
            # for each item type create an controller and load it
            temp = ItemController(type)
            persistance.storeItems(self.rootDir + '/item/' + type + '.json', temp.getList())     

        for item in self.recipeController.getList().values():
            persistance.storeObject(self.getRecipePath() + "/" + item["Name"] + ".json", item)

        for item in self.taskitemController.keys():
            persistance.storeItems(self.getTaskPath() + "/" + item + ".json", self.taskitemController[item])



        