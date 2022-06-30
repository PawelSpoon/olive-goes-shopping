#ifdef QT_QML_DEBUG
#include <QtQuick>
#endif

#include <sailfishapp.h>
#include <QGuiApplication>
#include <QLocale>
#include <QtGui>
#include <QtQml>
#include <QSettings>
#include "importexport.h"
#include "settings.h"
#include "ogssettings.h"
#include <iostream>


/*#include <QTranslator>
#include <QProcess>
#include "importexport.h"
*/


bool copyDir(const QString &source, const QString &destination, bool override)
{
     QDir directory(source);
     if (!directory.exists())
     {
         //std::cout << "where the hack is the source ?!" << std::endl;
         //std::cout << directory.absolutePath().toStdString() << std::endl;
         return false;
     }


     QString srcPath = QDir::toNativeSeparators(source);
     if (!srcPath.endsWith(QDir::separator()))
         srcPath += QDir::separator();
     QString dstPath = QDir::toNativeSeparators(destination);
     if (!dstPath.endsWith(QDir::separator()))
         dstPath += QDir::separator();


     bool error = false;
     QStringList fileNames = directory.entryList(QDir::AllEntries | QDir::NoDotAndDotDot | QDir::Hidden);
     for (QStringList::size_type i=0; i != fileNames.size(); ++i)
     {
         QString fileName = fileNames.at(i);
         QString srcFilePath = srcPath + fileName;
         QString dstFilePath = dstPath + fileName;
         QFileInfo fileInfo(srcFilePath);
         if (fileInfo.isFile() || fileInfo.isSymLink())
         {
           if (override)
           {
               // what a fuck, had only write not read rights
               QFile::setPermissions(dstFilePath, QFile::WriteOwner| QFile::ReadOwner);
           }
           QFile::copy(srcFilePath, dstFilePath);
         }
         else if (fileInfo.isDir())
         {
             QDir dstDir(dstFilePath);
             dstDir.mkpath(dstFilePath);
             if (!copyDir(srcFilePath, dstFilePath, override))
             {
                 error = true;
             }
         }
     }

     return !error;
}

void copyAssetsToWriteable(bool force)
{

    QString pathNew = "/oarg.pawelspoon/olive-goes-shopping/assets";
    QDir newDbDir = (QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation) + pathNew);

    if(newDbDir.exists()) {
        std::cout << "leaving early folder exits! fake" << std::endl;
        if (!force) return;
    }

     std::cout << copyDir("/usr/share/olive-goes-shopping/assets" ,newDbDir.absolutePath(), true);
}

int main(int argc, char *argv[])
{
    QString appname = "Olive goes shopping";
    QString pkgname = "olive-goes-shopping";
    QString orgname = "oarg.pawelspoon";

    // rem: i could use args to forcefully rewrite the shit
    copyAssetsToWriteable(false);

//    it did work without these settings so lets try to avoid them
    QCoreApplication::setOrganizationDomain(orgname);
    QCoreApplication::setOrganizationName(orgname); // needed for Sailjail
    QCoreApplication::setApplicationName(pkgname);

    qmlRegisterType<ImportExport>("oarg.pawelspoon.olivegoesshopping.import_export", 1, 0, "ImportExport");
    qmlRegisterType<OGSSettings>("oarg.pawelspoon.olivegoesshopping.ogssettings", 1, 0, "OGSSettings");
    qmlRegisterType<Settings>("oarg.pawelspoon.olivegoesshopping.settings", 1, 0, "Settings");

    return SailfishApp::main(argc, argv);
}
