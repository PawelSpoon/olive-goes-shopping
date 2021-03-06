import QtQuick 2.0
import QtTest 1.2

import "../qml/js/database.js" as Database
import "../qml/js/functions.js" as Functions
import "../qml/js/constants.js" as Constants

TestCase {
    name: "Database Tests"

    function test_someDBTest() {
        Database.resetApplication();
        Database.initApplicationTables();

        var watchlistId = 1;
        var data = {};
        data.symbol = 'BASF';
        data.name = 'BASF AG';
        data.watchlistId = 1;
        data.extRefId = 'BA01';
        data.currency = 'EUR';
        data.stockMarketSymbol = 'XTRA';
        data.stockMarketSymbol = 'Xetra';
        data.isin = 'DE234234234';
        data.symbol1 = 'BA1';
        data.symbol2 = 'BA2';
        data.price = 62.30;

        Database.persistStockData(data, watchlistId)

        var securityList = Database.loadAllStockData(watchlistId, Database.SORT_BY_NAME_ASC);
        var security = securityList[0];
        compare(security.watchlistId, data.watchlistId);
        compare(security.symbol1, data.symbol1);
        compare(security.isin, data.isin);
        compare(security.extRefId, data.extRefId);
        compare(security.currency, data.currency);
        compare(security.price, data.price);
    }

}
