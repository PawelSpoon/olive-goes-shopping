from typing import Dict


class ControlledItem:
  myName = ""
  def __init__(self, name):
    self.myName = name


class Category(ControlledItem):
    pass

class Enum(ControlledItem):
    pass

class ItemType(ControlledItem):
    pass

class PhyDim(ControlledItem):
    pass

class Unit(ControlledItem):
    def __init__(self,name):
        ControlledItem.__init__(self, name)
        self.factor = 1
        self.offset = 0
        self.phydim = ''

# preconfigure reusable task
class TaskItem(ControlledItem):
    def __init__(self,name):
        ControlledItem.__init__(self, name)
        self.note = ''
        # self.done = False
        # prio and due date might fit

# entity in food, household, any category list
class ListItem(ControlledItem):
    def __init__(self,name):
        ControlledItem.__init__(self, name)
        self.packagesize = 0
        self.unit = ''
        self.category = ''
        self.co2 = 0

# an ingredient in recipe
class Ingredient(ControlledItem):
    def __init__(self, name):
        super().__init__(name)
        self.amount = 0
        self.unit = ""
        self.category = ''

# recipe in recipe db
class Recipe(ControlledItem):
    def __init__(self, name):
        super().__init__(name)
        self.servings = 0
        self.recipetext = ''
        self.duration = ''
        self.rating = 0
        self.ingredients = dict(Ingredient)

class ShoppingListItem(ListItem):
    def __init__(self, name):
        super().__init__(name)
        self.done = False

class TaskListItem(TaskItem):
    def __init__(self, name):
        super().__init__(name)
        self.done = False

