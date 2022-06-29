# this is the guy who controlls the all real to-be-done lists
# allows to create / delete shopping lists & tasklists


from fileinput import filename
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

    def getPath(self):
        return self.rootDir + "/current"

    def file2ListName(self,fileName):
        return fileName.replace("." + self.type + ".json","")

    def list2FileName(self, listName):
        return listName + "." + self.type + ".json"

    def load(self):
        lists = os.listdir(self.getPath())
        for list in lists:
            # load only if propper type
            if ("." + self.type + "." in list): 
                lst = persistance.readItems(self.getPath() + "/" + list)
                if (self.type == tasklistType):
                    ctl = TaskListController(self.file2ListName(list)) 
                if (self.type == shoplistType):
                    ctl = ShoppingListController(self.file2ListName(list),self.rootDir)
                ctl.load(lst)
                self.listController[ctl.getTypeName()] = ctl

    def store(self):
        for key in self.listController.keys():
            persistance.storeItems(self.getPath() + "/" + self.list2FileName(key),self.listController[key].getList())

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
                ctl = ShoppingListController(name,self.rootDir)  
            self.listController[name] = ctl
        else:
            print("name already exists, will not add controller")

    def delete(self, name):
        if (name in self.listController.keys()):
            print("removing controller and file")
            self.listController.pop(name)
            os.remove(self.getPath() + "/" + self.list2FileName(name))
    