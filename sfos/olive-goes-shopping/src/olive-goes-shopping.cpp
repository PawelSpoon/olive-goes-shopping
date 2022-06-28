#ifdef QT_QML_DEBUG
#include <QtQuick>
#endif

#include <sailfishapp.h>
#include <QGuiApplication>
#include <QtGui>
#include <QSettings>
#include "settings.h"
#include "ogssettings.h"

int main(int argc, char *argv[])
{
    QString appname = "Olive goes shopping";
    QString pkgname = "olive-goes-shopping";
    QString orgname = "oarg.pawelspoon";

//    it did work without these settings so lets try to avoid them
//    QCoreApplication::setOrganizationDomain(orgname);
//    QCoreApplication::setOrganizationName(orgname); // needed for Sailjail
//    QCoreApplication::setApplicationName(pkgname);

//    qmlRegisterType<ImportExport>("oarg.pawelspoon.olivegoesshopping.import_export", 1, 0, "ImportExport");
    qmlRegisterType<OGSSettings>("oarg.pawelspoon.olivegoesshopping.ogssettings", 1, 0, "OGSSettings");
    qmlRegisterType<Settings>("oarg.pawelspoon.olivegoesshopping.settings", 1, 0, "Settings");

    return SailfishApp::main(argc, argv);
}
