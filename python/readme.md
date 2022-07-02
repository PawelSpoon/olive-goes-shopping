# IMPORTANT
the unit tests do work now from visual code. 
do open python folder, not the olive-goes-shopping root !
the settings file and .env file were important, see: 
https://binx.io/2020/03/05/setting-python-source-folders-vscode/

# IMPLEMENTATION
initially i wanted to support list of string and dictionary BUT:
- most of the enums could use id for easier renaming
- pyotherside does really support simple string arrays badly
everything is now a json with Id, Name:

# FOLDERSTRUCTURE

root
   /recipe contains all recipes
   /list contains reusable - repeatable lists
   /item contains the items db json files, one per each itemtype
      food.json
      household.json
   /current contains (multiple ?) shopping list and possibly multiple tasklists
      jan.shop.json
      jan.task.json
      ..
   category.json
   unit.json
   phydim.json

thought on serialization: if i want to bring in version -> then i will have
{ version: 1, data: [] }
so in fact i do need only one method in persistance :)

# CLASSES
enumcontroller is for simple strings (now obsolete)
- serializes to array of strings
itemcontroller is for complex types
- phydims
- itemtypes
- units
- categries
- recipes
- serializes to array of json objects
- allows add / remove / edit = update / rename
multiple itemcontrollers for e.g.
- items db (of itemtypes)

assetmanager is the controller for managing all db's
- category
- itemtypes: household, food ..
- recipes
- reusable tasklists
- reusable shoppinglists
- creates / removes new itemtypes, but managing is done by listcontroller
- he can only setup the system, call store on the dedicated controllers is needed
  (python has no byref)

listmanager is the controller for current working set, the real shopping lists ..
he can, similar to assetmanager for assets:
- create new shopping list / task list
- can delete one
- rename one
- gives you the controller for a list to handle that items

shall i combine all types into 1 list ?




