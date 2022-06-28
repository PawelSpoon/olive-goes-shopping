# this is the guy who controlls the all the pre-conditions:
# catagories
# item types
# recipes
# pre defined task lists

import os
from typing import Dict
from controller.enumcontroller import EnumController
from controller.itemcontroller import ItemController
from storage import persistance


class AssetManager:
    def __init__(self, root) -> None:
        self.rootDir = root
        self.catController = EnumController("category")
        self.itemtypeController = EnumController("itemtype")
        self.unitController = ItemController("unit")
        self.phydimController = EnumController("phydim")
        # multiple itemControllers
        self.itemControllerDict = dict()
        # one recipe controller
        self.recipeController = ItemController('recipe')
        # multiple task list controler
        self.taskitemController = dict()

    def getRecipePath(self):
        return self.rootDir + "/recipe"

    def getTaskPath(self):
        return self.rootDir + "/tasklist"

    def load(self):
        print('asset manager loading from: ' + self.rootDir)
        # simple string
        self.catController.load(persistance.readEnumsIfExists(self.rootDir + '/category.json'))
        self.itemtypeController.load(persistance.readEnumsIfExists(self.rootDir + '/itemtype.json'))
        self.phydimController.load(persistance.readEnumsIfExists(self.rootDir + '/phydim.json'))
        # complex type
        self.unitController.load(persistance.readItemsIfExists(self.rootDir + '/unit.json'))

        for type in self.itemtypeController.getList():
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
        if (type == "phydim"):
            return self.phydimController
        if (type == "unit"):
            return self.unitController
        if (type == "category"):
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
        persistance.storeEnums(self.rootDir + '/category.json',self.catController.getList())
        persistance.storeEnums(self.rootDir + '/itemtype.json',self.itemtypeController.getList())
        persistance.storeEnums(self.rootDir + '/phydim.json'  ,self.phydimController.getList())
        persistance.storeItems(self.rootDir + '/unit.json'    ,self.unitController.getList())

        for type in self.itemtypeController.getList():
            # for each item type create an controller and load it
            temp = ItemController(type)
            print(type)
            persistance.storeItems(self.rootDir + '/item/' + type + '.json', self.itemControllerDict[type].getList())     

        for item in self.recipeController.getList().values():
            persistance.storeObject(self.getRecipePath() + "/" + item["Name"] + ".json", item)

        for item in self.taskitemController.keys():
            persistance.storeItems(self.getTaskPath() + "/" + item + ".json", self.taskitemController[item])



        