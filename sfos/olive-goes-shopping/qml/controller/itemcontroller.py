
 
from controller.constants import FieldName
from storage import persistance


class ItemController:

    def __init__(self,itemName,_filePath):
        self.mytype = itemName
        self.filePath = _filePath
        self.items = dict()

    def getTypeName(self):
        return self.mytype

    def getItemName(self,item):
        # could do check if exists
        return item[FieldName]

    def add(self,item):
        itemName = self.getItemName(item)
        if (itemName in self.items.keys()):
            print(itemName + " already in list")
            return False
        else:
            self.items[itemName] = item
            return True

    def remove(self, name):
        if (name in self.items.keys()):
            self.items.pop(name)
            return True
        return False

    def update(self, oldName, new):
        if (oldName in self.items.keys()):
            if (new[FieldName] not in self.items.keys()):
                self.items.pop(oldName)
                self.items[new[FieldName]]= new
                return True
            else:
                print("new would cause a duplication")
        else:
            print("old is not present")
        return False

    def rename(self, oldName, newName):
        if (oldName in self.items.keys()):
            if (newName not in self.items.keys()):
                temp = self.items[oldName]
                temp[FieldName] = newName
                self.items.pop(oldName)
                self.items[newName]= temp
                return True
            else:
                print("new would cause a duplication")
        else:
            print("old is not present")
        return False

    def getList(self):
        return self.items

    def getAsList(self):
        return list(self.items.values()).copy()

    def loadString(self, json):
        self.items = dict(json)
        return True

    def load(self):
        return self.loadString(persistance.readItemsIfExists(self.filePath))

    def clearItems(self):
        self.items.clear()

    def store(self):
        persistance.storeItems(self.filePath,self.items)

