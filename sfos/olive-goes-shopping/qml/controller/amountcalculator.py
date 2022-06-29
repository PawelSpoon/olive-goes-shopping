
from storage import persistance
from controller.constants import *


class AmountCalculator:

    def __init__(self, rootD):
        self.rootDir = rootD

    units = dict()

    def init(self):
        self.units = persistance.readItems(self.rootDir + unitFilePath)


    # returns false if not possible, else the value in oldunit
    def doAmountMagic(self, oldValue, oldUnit, addValue, addUnit):
        # that is the simple case
        if oldUnit == addUnit:
            return oldValue + addValue
            
        # ensure that both units are in db
        if oldUnit not in self.units or addUnit not in self.units:
            return False

        oldPhydim = self.units.get(oldUnit)[FieldPhydim]
        addPhydim = self.units.get(addUnit)[FieldPhydim]
        if oldPhydim == addPhydim:
            oldFactor = self.units.get(oldUnit)[FieldFactor]
            addFactor = self.units.get(addUnit)[FieldFactor]
            return (addValue * addFactor / oldFactor) + oldValue
        else:
            # if not convertible, not same phydim
            return False

    def try1(self):
        self.doAmountMagic(2,"kg",500,"g")

        (2*1 + 500*0.001)/1 