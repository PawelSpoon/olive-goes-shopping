unit, phydim, itemtype, category can be extended as json

/recipe contains all recipes
/list contains reusable - repeatable lists
/item contains the items db based on itemtype
/current contains (multiple ?) shopping list and possibly multiple tasklists

thought on serialization: if i want to bring in version -> then i will have
{ version: 1, data: [] }
so in fact i do need only one method in persistance :)

enumcontroller is for simple strings:
- phydims
- serializes to array of strings
itemcontroller is for complex types
- itemtypes
- units
- categries
- recipes
- serializes to array of json objects
multiple itemcontrollers for e.g.
- items db (of itemtypes)

assetmanager is the controller for managing all db's
- category
- itemtypes: household, food ..
- recipes
- reusable tasklists
- reusable shoppinglists
- he can only setup the system, call store on the dedicated controllers

listmanager is the controller for current working set, the real shopping lists ..
- can create new shopping list
- can delete one
- gives you the controller for a list

shall i combine all types into 1 list ?
