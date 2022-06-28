

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
currentDirPath = "/" + currentDir
itemDir = "item"
tasklistDir = "tasklist"
tasklistDirPath = "/" + tasklistDir
shoplistDir = "shoplist"
shoplistDirPath = "/" + shoplistDir
recipeDir = recipe
recipeDirPath = "/" + recipeDir

unitFilePath = "/" + unit + ".json"
categoryFilePath = "/" + category + ".json"
phydimFilePath = "/" + phydim + ".json"
itemtypeFilePath = "/" + itemtype + ".json"
 


FieldDone = "Done"
FieldName = "Name"
FieldAmount = "Amount"
FieldUnit = "Unit"
FieldPhydim = "Phydim"
FieldFactor = "Factor"
FieldOffset = "Offset"

# ab 1.7 freitesten verkehrsbeschränkt, wenn 48 stunden
# ab 6.7 frei

