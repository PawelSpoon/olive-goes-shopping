# olive-goes-shopping
new (hopefully) cross platform version of the shopping list app harbour-olive-goes-shopping

# details
## python
### template handling
- every list can persist itself as a template
- can override an existing template
- add list
-- select type
-- select from scratch / template
-- requires to load all templates for a type
-- create a new list as copy, could be done by itemcontroller with an alternative load, then store or by listmanager that copies it.
## sfos
### applicationcontroller
- invokes all the pages
- defines signals

### lists
- loaded from controllers
- contain id, name, item
- subscribe to signal
- let app controller invoke the dialogs , passes on the item
- signal updates them on dialog close

### dialogs
- invoker hands over item object
- this holds the original object or nothing if new, gets never modified
- copy2Controls then clones the data
- onAccept current object gets collected and passed with oldName to appcontroller
