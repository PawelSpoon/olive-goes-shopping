
 
class ItemController:

    def __init__(self,enumName):
        self.mytype = enumName

    items = dict()

    def getItemName(self):
        return self.mytype

    def add(self,item):
        if (item["Name"] in self.items.keys()):
            print(item["Name"] + " already in list")
            return False
        else:
            self.items[item["Name"]] =item
            return True

    def remove(self, name):
        if (name in self.items.keys()):
            self.items.pop(name)
            return True
        return False

    def update(self, oldName, new):
        if (oldName in self.items.keys()):
            if (new["Name"] not in self.items.keys()):
                self.items.pop(oldName)
                self.items[new["Name"]]= new
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
                temp["Name"] = newName
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

    def load(self, json):
        self.items = dict(json)
        return True

    def clearItems(self):
        self.items.clear()

