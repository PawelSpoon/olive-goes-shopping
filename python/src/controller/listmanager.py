# this is the guy who controlls the all real to-be-done lists
# allows to create / delete shopping lists & tasklists

import os

from controller.constants import *
from controller.shoppinglistcontroller import ShoppingListController
from controller.tasklistcontroller import TaskListController
from storage import persistance


class ListManager:

    def __init__(self, root, type):
        self.rootDir = root
        self.type = type
        self.listController = dict()
       
    def getCurrentDirPath(self):
         return os.path.join(self.rootDir,currentDir)

    def file2ListName(self,fileName):
        return fileName.replace("." + self.type + ".json","")

    def list2FileName(self, listName):
        return listName + "." + self.type + ".json"

    def createShoppingListController(self, listName):
        filepath = os.path.join(self.getCurrentDirPath(),self.list2FileName(listName))  
        return ShoppingListController(listName,filepath,self.rootDir)
        

    def load(self):
        lists = os.listdir(self.getCurrentDirPath())
        for list in lists:
            # load only if propper type
            if ("." + self.type + "." in list): 
                if (self.type == tasklistType):
                    ctl = TaskListController(self.file2ListName(list))                 
                if (self.type == shoplistType):
                    print("adding for file: " + list)
                    extractedListName = self.file2ListName(list)
                    ctl = self.createShoppingListController(extractedListName)
                    self.listController[extractedListName] = ctl
                self.listController[ctl.getTypeName()] = ctl   

    # returns all loaded lists
    def getListNames(self):
        listOfNames = list()
        for listName in self.listController.keys():
            listOfNames.append(listName)
        dicOfNames = dict()
        dicOfNames[FieldName] = listOfNames
        return dicOfNames

    # creates new but downdates existing
    #def store(self):
     #   for key in self.listController.keys():
     #       persistance.storeItems(self.getCurrentDirPath() + "/" + self.list2FileName(key),self.listController[key].getList())

    def getController(self, name):
        if (name in self.listController.keys()):
            return self.listController[name]
        print("controller not found")

    def add(self, name):
        if (name not in self.listController.keys()):
            print("adding controller")
            if (self.type == tasklistType):
                ctl = TaskListController(name) 
            if (self.type == shoplistType):
                ctl = self.createShoppingListController(name)
            self.listController[name] = ctl
            ctl.store()
        else:
            print("name already exists, will not add controller")

    def delete(self, name):
        if (name in self.listController.keys()):
            print("removing controller and file")
            self.listController.pop(name)
            os.remove(self.getCurrentDirPath() + "/" + self.list2FileName(name))
    