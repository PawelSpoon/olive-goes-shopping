# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = olive-goes-shopping

# added by JS as perhttps://stackoverflow.com/questions/27035880/how-to-add-files-in-the-rpm-package-of-an-sailfish-os-project
DEPLOYMENT_PATH = /usr/share/$${TARGET}

CONFIG += sailfishapp

HEADERS += \
 #   src/importexport.h \
    src/ogssettings.h \
    src/settings.h

SOURCES += src/olive-goes-shopping.cpp \
    src/ogssettings.cpp \
    src/settings.cpp

DISTFILES += qml/olive-goes-shopping.qml \
    qml/ApplicationController.qml \
    qml/PythonHandler.qml \
    qml/cover/CoverPage.qml \
    qml/pages/FirstPage.qml \
    qml/pages/ManageMainPage.qml \
    qml/pages/ManageEnumsPage.qml\
    qml/pages/EnumDialog.qml \
    qml/pages/Settings.qml \
    \
    assets/category.json \
    assets/current/annual maintenance - Breva.task.json \
    assets/current/jan.shop.json \
    assets/item/entertainment.json \
    assets/item/food.json \
    assets/item/household.json \
    assets/itemtype.json \
    assets/phydim.json \
    assets/recipe/Krautsuppe.json \
    assets/recipe/My-Recipe.json \
    assets/recipe/annual maintenance - Breva.json \
    assets/shoplist/weekly.json \
    assets/tasklist/annual maintenance - Breva.json \
    assets/tasklist/annual maintenance - KTM.json \
    assets/unit.json \
    \
    rpm/olive-goes-shopping.changes.in \
    rpm/olive-goes-shopping.changes.run.in \
    rpm/olive-goes-shopping.spec \
    rpm/olive-goes-shopping.yaml \
    olive-goes-shopping.desktop \
    translations/*.ts

SAILFISHAPP_ICONS = 86x86 108x108 128x128 256x256

assets.files = assets
assets.path = $${DEPLOYMENT_PATH}

# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

# German translation is enabled as an example. If you aren't
# planning to localize your app, remember to comment out the
# following TRANSLATIONS line. And also do not forget to
# modify the localized app name in the the .desktop file.
TRANSLATIONS += translations/olive-goes-shopping-de.ts

OTHER_FILES += assets/category.json \
    assets/unit.json \
    assets/shoplist/weekly.json

INSTALLS += assets
