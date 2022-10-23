
# for a single shopping list
from controller.constants import FieldDone, FieldName
from controller.itemcontroller import ItemController


class TaskListController(ItemController):

    def __init__(self, name, _filePath):
        super().__init__(name, _filePath)

    # load - inherited
    # store - not supported, implemented in managers

    # mark as done
    def markAsDone(self, name):
        self.setDoneValue(name, True)

    def setDoneValue(self, name, done):
        self.items[name][FieldDone] = done

    # clear done (remove all done items)
    def clearDone(self):
        deletethose = list()
        for item in self.getList().values():
            if item[FieldDone] == True:
                deletethose.append(item[FieldName])    # collect invalid
        for key in deletethose:
            self.getList().pop(key)

    # reset (set all as undone)
    def resetDone(self):
        for item in self.getList().values():
            if item[FieldDone] == True:
                item[FieldDone] = False

    # add - inherited
    # edit == update - inherited

    # addFromList - can't be inherited, shoppin list needs to sum up
    # in both cases Done must be added
    def addItems2List(self, listOfItems):
        # listOfItems is in fact a dict
        for item in listOfItems:
            item[FieldDone] = False
            itemName = item[FieldName]
            # add if not there
            # skip if there and not done
            # change to undo if there and done
            if itemName not in self.getList().keys():
                self.add(item)
                # self.getList()[itemName] = item
            else:
                if self.getList()[itemName][FieldDone] == True:
                    self.setDoneValue(itemName,False)
                else:
                    # print("nothing to do")
                    pass

    def deleteOne(self, name):
        if name not in self.getList().keys():
            print('not in')
            return False
        self.getList().pop(name)
        return True