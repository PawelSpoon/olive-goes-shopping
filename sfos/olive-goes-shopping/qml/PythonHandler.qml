import QtQuick 2.0
import io.thp.pyotherside 1.5

/***
 the needed wrapper to flaten the method calls
 */

Python {
  id: python

  Component.onCompleted: {
    /*setHandler('asset_updated', asset_updated);
    setHandler('a_get_station_messages', a_get_station_messages);*/
    setHandler('error', error_handler);
    // initalization done
    setHandler('init', init_handler);

    addImportPath(Qt.resolvedUrl('.'));
    importModule('controller', function () {});
    importModule('storage', function () {});
    importModule('app', function () {});
    importModule('app', function () {
      call_sync('app.app_object.setup', ['.local/share/oarg.pawelspoon/olive-goes-shopping/assets',python]);
      //call('tfl.tfl_object.set_python_handler', [python]);
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
    console.log('Module ERROR - source:', module_id, method_id, 'error:', description);
    applicationWindow.signal_init(module_id, method_id, description);
  }

  function reInit(type) {
    applicationWindow.cache.invalidate()
      return call_sync('app.app_object.reInitAssetManager',[])
  }

  // assets - what ever assetmanager can init and load is in this region

  function getAssets(type) {
      return call_sync('app.app_object.getAssetList',[type])
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

  function getShoppingLists() { // and object with Name attribute that contains a list
      return call_sync('app.app_object.getShoppingLists',[])
  }
    // single task or shopping list}
  function getShoppingList(name) { // and object with Name attribute that contains a list
      return call_sync('app.app_object.getShoppingList',[name])
  }
}
