

global shoplistType, tasklistType, currentDir, itemDir, recipeDir, tasklistDir, shoplistDir
global category, unit, phydim, itemtype, recipe

category = "category"
unit = "unit"
phydim = "phydim"
itemtype = "itemtype"
recipe = "recipe"

shoplistType = "shop"
tasklistType = "task"

currentDir = "current"
itemDir = "item"
tasklistDir = "tasklist"
shoplistDir = "shoplist"
recipeDir = recipe

# contains all units
unitFilePath = "/" + unit + ".json"
# contains all categories
categoryFilePath = "/" + category + ".json"
# contains all physical dimensions
phydimFilePath = "/" + phydim + ".json"
# contains all item types
itemtypeFilePath = "/" + itemtype + ".json"
# contains all task templates
tasktemplateFilePath = "/" + tasklistType + ".json"
# contains all shop list templates
shoplisttemplateFilePath = "/" + shoplistType + ".json"
 

FieldId = "Id"
FieldDone = "Done"
FieldName = "Name"
FieldAmount = "Amount"
FieldUnit = "Unit"
FieldPhydim = "Phydim"
FieldFactor = "Factor"
FieldOffset = "Offset"
FieldCategory = "Category"


