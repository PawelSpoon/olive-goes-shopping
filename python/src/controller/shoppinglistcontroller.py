
# for a single shopping likst
from yaml import add_multi_constructor
from controller.amountcalculator import AmountCalculator
from controller.constants import FieldAmount, FieldDone, FieldName, FieldUnit
from controller.tasklistcontroller import TaskListController


class ShoppingListController(TaskListController):

    # rootD is needed for amountcalculator
    def __init__(self,listName,_filePath,rootD):
        super().__init__(listName,_filePath)
        self.mytype = listName
        self.rootDir = rootD
        self.calculator = AmountCalculator(self.rootDir)
        self.calculator.init()

    def setAmountValue(self, name, value):
        self.items[name][FieldAmount] = value

    def addItems2ShoppingList(self, listOfItems):
        # listOfItems is in fact a dict .values() but that does not work with qml, so removed
        for item in listOfItems:
            item[FieldDone] = False
            itemName = item[FieldName]
            # add if not there
            # update amount if there but convertable
            # add item if not convertable 
            if itemName not in self.getList().keys():
                self.getList()[itemName] = item
            else:
                ret = self.calculator.doAmountMagic(
                    self.getList()[itemName][FieldAmount], 
                    self.getList()[itemName][FieldUnit],
                    item[FieldAmount],item[FieldUnit])
                if (ret != False):
                    self.setAmountValue(itemName, ret)
                    if self.getList()[itemName][FieldDone] == True:
                        self.setDoneValue(itemName,False)
                    print("update done")
                else:    
                    # add an new entry to list with that unit
                    self.getList()[itemName + ":" + item[FieldUnit]] = item



    