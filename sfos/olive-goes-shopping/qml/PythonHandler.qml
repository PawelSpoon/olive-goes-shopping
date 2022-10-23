import QtQuick 2.0
import io.thp.pyotherside 1.5

/***
 the needed wrapper to flaten the method calls
 */

Python {
  id: python

  Component.onCompleted: {
    setHandler('error', error_handler);
    // initalization done
    setHandler('init', init_handler);

    addImportPath(Qt.resolvedUrl('.'));
    importModule('controller', function () {});
    importModule('storage', function () {});
    importModule('app', function () {});
    importModule('app', function () {
      call('app.app_object.setup', ['.local/share/oarg.pawelspoon/olive-goes-shopping/assets',python]);
    });
  }

  Component.onDestruction: {

  }

  onError: {
    console.log('ERROR - unhandled error received:', traceback);
  }

  onReceived: {
    console.log('ERROR - unhandled data received:', data);  
  }

  function error_handler(module_id, method_id, description) {
    console.log('Module ERROR - source:', module_id, method_id, 'error:', description);
    applicationWindow.signal_error(module_id, method_id, description);
  }

  function init_handler(module_id, method_id, description) {
    console.log('init done:');
    applicationWindow.signal_init(module_id, method_id, description);  }

  function reInit(type) {
    applicationWindow.cache.invalidate()
      return call_sync('app.app_object.reInitAssetManager',[])
  }

  // assets - what ever assetmanager can init and load is in this region

  function getAssets(type) {
     console.log("python.getAssets("+type+")")
     var ret = call_sync('app.app_object.getAssetList',[type])
     console.log(ret)
     return ret
  }

  function clearAssets(type) {
      return call_sync('app.app_object.clearAssets',[type])
  }

  function deleteAsset(type, name) {
      return call_sync('app.app_object.deleteAsset',[type,name])
  }

  function updateAsset(type, oldName, item) {
      return call_sync('app.app_object.updateAsset',[type,oldName,item])
  }

  function addAsset(type, item) {
      return call_sync('app.app_object.addAsset',[type,item])

  }

  // list manager to manage task and shopping list creation

  function getShoppingLists() {
      return call_sync('app.app_object.getShoppingLists',[])
  }

  function getTaskLists() {
      return call_sync('app.app_object.getTaskLists',[])
  }

  function getTemplateItems(type,name) {
      console.log("python.getTemplateItems("+type+","+name+")")
      return call_sync('app.app_object.getTemplateItems',[type,name])
  }

  function createList(name,type,items) { // and object with Name attribute that contains a list
      console.log("python.createList("+name+","+type+")")
      var ret = call_sync('app.app_object.createList',[name,type,items])
      console.log(ret)
      return ret
  }

  function deleteList(name,type) { // and object with Name attribute that contains a list
      console.log("python.deleteList("+name+","+type+")")
      var ret = call_sync('app.app_object.deleteList',[name,type])
      console.log(ret)
      return ret
  }

  // single task or shopping list}
  function getList(type, name) { // and object with Name attribute that contains a list
      console.log("python.getList("+type+","+name+")")
      return call_sync('app.app_object.getList',[type,name])
  }

  function addItem2TaskList(listName, items) {
      return call_sync('app.app_object.addItem2TaskList',[listName,items])
  }

  function addItem2ShoppingList(listName, items) {
      return call_sync('app.app_object.addItem2ShoppingList',[listName,items])
  }

  function setDoneValue(type, listName, name, done) {
      return call_sync('app.app_object.setDoneValue',[type,listName,name,done])
  }

  function deleteOne(type, listName, name) {
      console.log("deleteOne("+type+","+listName+","+name+")")
      return call_sync('app.app_object.deleteOne',[type,listName,name])
  }

  function updateOne(type, listName, oldName, item) {
      return call_sync('app.app_object.updateOne',[type, listName,oldName,item])
  }

  function clearAll(type, listName) {
      return call_sync('app.app_object.clearAll',[type, listName])
  }

  function clearDone(type, listName) {
      return call_sync('app.app_object.clearDone',[type, listName])
  }

  function resetDone(type, listName) {
      return call_sync('app.app_object.resetDone',[type, listName])
  }

  /// template management

  function getTemplates(type) {
      console.log("python.getTemplates("+type+")")
      var ret = call_sync('app.app_object.getTemplateListNames',[type])
      console.log(ret.toString())
      return ret
  }

  function getTemplate(type,name) {
      console.log("python.getTemplate("+type+","+name+")")
      var ret = call_sync('app.app_object.getTemplate',[type, name])
      console.log(ret.toString())
      return ret
  }

  function createTemplate(items,name,type) {
      console.log("python.createTemplate("+name+","+type+")")
      var ret = call_sync('app.app_object.createTemplate',[items, type, name])
      console.log(ret)
      return ret
  }

  function deleteTemplate(name,type) {
      console.log("python.deleteTemplate("+name+","+type+")")
      var ret =  call_sync('app.app_object.deleteTemplate',[type, name])
      console.log(ret)
      return ret
  }

  function addItem2Template(type, listName, items) {
      console.log("python.addItem2Template("+type+","+listName+")")
      call_sync('app.app_object.addItem2Template',[type, listName, items])
  }

  function updateOneInTemplate(type, listName, oldName, item) {
      console.log("python.updateOneInTemplate("+listName+","+type+")")
      var ret =  call_sync('app.app_object.updateOneInTemplate',[type, listName, oldName, item])
      console.log(ret)
      return ret
  }

  function deleteOneFromTemplate(type, listName, name) {
      console.log("python.deleteOneFromTemplate("+listName+","+type+")")
      var ret =  call_sync('app.app_object.deleteOneFromTemplate',[type, listName, name])
      console.log(ret)
      return ret
  }

}
