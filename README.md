# olive-goes-shopping
new (hopefully) cross platform version of the shopping list app harbour-olive-goes-shopping

# details
## python
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
