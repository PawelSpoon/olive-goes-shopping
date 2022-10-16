
 
from controller.constants import FieldName
from controller.model import ControlledItem
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
        name = item[FieldName]
        if name != '':
            return item[FieldName]
        else:
            raise Exception("item's Name is empty")

    def addWithName(self, name):
        item = dict()
        item[FieldName] = name
        self.add(item)
            
    def add(self,item):
        if type(item) != type(dict()):
            raise Exception('item is not a dictionary')
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
                # rename
                self.items.pop(oldName)
                self.items[new[FieldName]]= new
                return True
            else:
                if oldName == new[FieldName]:
                    # pure update
                    self.items[oldName] = new
                else:
                    # conflict
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

    # returns in fact a dictiory
    def getList(self):
        return self.items

    # returns keys == names of items
    def getKeys(self):
        return self.items.keys()

    # returns a real list
    def getAsList(self):
        return list(self.items.values()).copy()

    # used for create-new-from-template usecase
    def loadItems(self, items):
        self.items = items
        return True

    def loadString(self, json):
        self.items = dict(json)
        return True

    # standard load function
    # will load items from filePath defined in constructor
    def load(self):
        return self.loadString(persistance.readItemsIfExists(self.filePath))

    def clearItems(self):
        self.items.clear()

    # standard save
    # will update items in file defined in constructor
    def store(self):
        persistance.storeItems(self.filePath,self.items)        



