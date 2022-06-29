
from storage import persistance


class Enum:
    mytype = type
 
class EnumController:

    def __init__(self,enumName, _filePath):
        self.mytype = enumName
        self.filePath = _filePath

    items =[]

    def getEnumName(self):
        return self.mytype

    def add(self,item):
        # we could check here for strings or literals only
        if (item in self.items):
            print(item + " already in list")
            return False
        else:
            self.items.append(item)
            self.items.sort()
            return True

    def remove(self, item):
        if (item in self.items):
            self.items.remove(item)
            self.items.sort()
            return True
        return False

    def rename(self, old, new):
        if (old in self.items):
            if (new not in self.items):
                self.items.remove(old)
                self.items.append(new)
                return True
            else:
                print("new would cause a duplicaton")
        else:
            print("old is not present")
        return False

    def getList(self):
        return self.items

    def loadString(self, json):
        self.items = list(json)
        return True

    def load(self):
        self.items = list(persistance.readEnumsIfExists(self.filePath))

    def store(self):
        persistance.storeEnums(self.filePath, self.items)


