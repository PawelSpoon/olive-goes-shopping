# this is the guy who controlls the all the pre-conditions:
# catagories
# item types
# recipes
# pre defined task lists

import os
from controller.constants import *
from controller.folderitemcontroller import FolderItemController
from controller.itemcontroller import ItemController
from controller.itemtypecontroller import ItemTypeController
from storage import persistance


class AssetManager:
    def __init__(self, root) -> None:
        self.rootDir = root
        self.catController = ItemController(category,self.rootDir + categoryFilePath) 
        self.itemtypeController = ItemTypeController(itemtype,
         self.rootDir + itemtypeFilePath,
         os.path.join(self.rootDir,itemDir)) 
        self.unitController = ItemController(unit, self.rootDir + unitFilePath)
        self.phydimController = ItemController(phydim,self.rootDir + phydimFilePath)
        # multiple item-controller, one for each item-type 
        self.itemControllerDict = dict()
        # one recipe controller
        self.recipeController = FolderItemController(recipe,os.path.join(self.rootDir,recipeDir))
        # do i need these controllers for pre-defined list at all ? aren't names sufficient ?

        self.taskTemplateController = ItemTypeController(tasklistType,
          self.rootDir + tasktemplateFilePath,
          self.getTaskPath())
        self.shopListTemplateController = ItemTypeController(shoplistType, 
          self.rootDir + shoplisttemplateFilePath,
          self.getShopListPath())
        # multiple task list controler (to modify pre-defined task lists)
        self.taskitemController = dict()
        # multiple shop list controler (to modify pre-defined shop lists)
        self.shopitemController = dict()


    # folder with recipes
    def getRecipePath(self):
        return os.path.join(self.rootDir,recipeDir)

    # folder with pre-defined task list 'templates'
    def getTaskPath(self):
        return os.path.join(self.rootDir,tasklistDir)

    # folder with pre-defined shopping list
    def getShopListPath(self):
        return os.path.join(self.rootDir,shoplistDir)

    def load(self):
        print('asset manager loading from: ' + self.rootDir)
        # complex type        
        self.phydimController.load()
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

        # 
        self.taskTemplateController.load()


        # predefined task list takes over the name from file
        # get all files from /list folder and init multiple itemcontrollers
        # to be done later
        # self.taskitemController...
        tasklists = os.listdir(self.getTaskPath())
        for tasklist in tasklists:
            tmp = persistance.readItems(self.getTaskPath() + "/" + tasklist)
            templateName = tasklist.replace(".json","")
            self.taskitemController[templateName] = tmp
            # todo: if not in tasktemplatecontroller -> add it
            if templateName not in self.taskTemplateController.items.keys():
              self.taskTemplateController.add(templateName)

        shoplists = os.listdir(self.getShopListPath())
        for shoplist in shoplists:
            tmp = persistance.readItems(self.getShopListPath() + "/" + shoplist)
            templateName = shoplist.replace(".json","")
            self.shopitemController[shoplist.replace(".json","")] = tmp
            # todo: if not in tasktemplatecontroller -> add it
            if templateName not in self.shopListTemplateController.getList().keys():
              self.shopListTemplateController.addWithName(templateName)
    
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
        if (type == tasklistType):
            return self.taskTemplateController
        if (type == shoplistType):
            return self.shopListTemplateController
        # first look in itemtypes
        if (type in self.itemControllerDict.keys()):
            return self.itemControllerDict[type]
        if (type in self.taskitemController.keys()):
            return self.taskitemController[type]
        if (type in self.shopitemController.keys()):
            return self.shopitemController [type]  
        print("not found")
        return None
        # second look lists
        # shall we look into active too ?
        # no, this is assetscontroller, active are in another controller

    def getTemplateListName(self, type):
        if (type == shoplistType):
            return self.shopitemController.keys()
        if (type == tasklistType):
            return self.taskitemController.keys()
    
    # i do not want to add store-as-new to itemcontroller
    # feels wrong for me, even though it would be just a copy ..
    # rather get the items from current
    def createTemplate(self, items, type, name):
        return


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
  