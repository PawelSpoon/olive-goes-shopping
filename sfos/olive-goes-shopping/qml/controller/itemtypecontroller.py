
 
import os
from controller.constants import FieldName
from controller.itemcontroller import ItemController
from storage import persistance

# extends the normal itemcontroller with sync to itemtype lists located in item
# stores immediately !! in that sense that list files are created, renamed deleted..
# it does not care about the content of the item files

# can work for templates too if i introduce a file similar to itemtype.json
# tasktemplate.json shoplisttemplate.json
class ItemTypeController(ItemController):

    def __init__(self,itemName,_filePath,_itemListDir):
        super().__init__(itemName,_filePath)   
        self.itemListDir = _itemListDir    

    def file2ListName(self,fileName):
        temp = fileName.replace(self.itemListDir + "/","")
        return temp.replace(".json","")

    def list2FileName(self, itemTypeName):
        return os.path.join(self.itemListDir,(itemTypeName +".json"))

    def add(self,item):
        if super().add(item):
            # create new file in itemListDir
            name = self.getItemName(item)
            persistance.storeItems(self.list2FileName(name),dict())
            return True
        return False

    def remove(self, name):
        if (super().remove(name)):
            os.remove(self.list2FileName(name))
            return True
        return False

    def update(self, oldName, new):
        if (super().update(oldName,new)):
            os.rename(self.list2FileName(oldName),self.list2FileName(new[FieldName]))
            return True
        return False

    def rename(self, oldName, newName):
        if (super().rename(oldName,newName)):
            os.rename(self.list2FileName(oldName),self.list2FileName(newName))
            return True
        return False

    def load(self):
        self.loadString(persistance.readItemsIfExists(self.filePath))
        return self.ensureAllsynced()

    def clearItems(self):
        self.items.clear()
        # todo: delete all files

    def store(self):
        super().store()
        return self.ensureAllsynced()

    def ensureAllsynced(self):
        # each item in list must have a file, else init a new one
        for itemtype in self.items.keys():
            if os.path.exists(self.list2FileName(itemtype)):
                pass
            else:
                persistance.storeItems(self.list2FileName(itemtype),dict())
        # remove files without items
        files = os.listdir(self.itemListDir)
        for file in files:
            if file.replace(".json","") not in self.items.keys():
                print("removing file")
                os.remove(os.path.join(self.itemListDir,file))

        return True


