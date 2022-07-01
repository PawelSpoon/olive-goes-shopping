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

    addImportPath(Qt.resolvedUrl('.'));
    importModule('controller.assetmanager', function () {});
    importModule('app', function () {
      call('app.app.setup', ['/home/defaultuser/.local/share/oarg.pawelspoon/olive-goes-shopping/assets',python]);
      //call('tfl.tfl_object.set_python_handler', [python]);
    });
    /*importModule('database', function () {
      call('database.database_object.set_app', [app]);
      call('database.database_object.set_python_handler', [python]);
    });
    importModule('tfgm', function () {});
    importModule('tfgm_xml', function () {});*/
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
    app.signal_error(module_id, method_id, description);
  }

  // assets - what ever assetmanager can init and load is in this region

  function getAssets(type) {
      return call_sync('app.app.getAssetList',[type])
  }


  function clearAssets(type) {
      return call_sync('app.app.clearAssets',[type])
  }

  function deleteAsset(type, name) {
      return call_sync('app.app.deleteAsset',[type,name])
  }

  function updateAsset(type, oldName, item) {
      return call_sync('app.app.updateAsset',[type,oldName,item])
  }

  function addAsset(type, item) {
      return call_sync('app.app.addAsset',[type,item])
  }

  // list manager to manage task and shopping list creation



  // single task or shopping list

}
