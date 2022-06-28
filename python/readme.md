unit, phydim, itemtype, category can be extended as json
/recipes contains all recipes
/list contains reusable - repeatable lists
/items contains the items db based on itemtype
/active contains (multiple ?) shopping list and possibly multiple tasklists
enumcontroller is for simple strings:
- itemtypes
- phydims
- serializes to array of strings
itemcontroller is for complex types
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

listmanager is the controller for current working set, the real shopping lists ..
- can create new shopping list
- can delete one
- gives you the controller for a list

shall i combine all types into 1 list ?
