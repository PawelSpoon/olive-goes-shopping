
 
import os
from controller.constants import FieldName
from controller.itemcontroller import ItemController
from storage import persistance

# same as ItemController but different persistance
# filePath is a folderPaath
class FolderItemController(ItemController):

    def __init__(self,itemName,_folderPath):
        super().__init__(itemName,_folderPath)

    def loadString(self, json): None

    def load(self):
        # recipe conroller needs an own loader that loads all files from a folder into controller
        # ..
        #self.recipeController.load(self.rootDir + '/recipe')
        recipes = os.listdir(self.filePath)
        for recipe in recipes:
            print(recipe)
            tmp = persistance.readObject(self.filePath + "/" + recipe)
            self.add(tmp)

    def store(self):
        for recipe in self.items.keys():
            persistance.storeObject(self.filePath + "/" + recipe + ".json",self.items[recipe])

