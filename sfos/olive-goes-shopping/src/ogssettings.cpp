#include "ogssettings.h"
#include <QDesktopServices>
#include <QDirIterator>
#include <QFile>
#include <QTextStream>
#include <QSettings>

// FIXME
#include <QDebug>

OGSSettings::OGSSettings(QObject *parent) :
    Settings(parent)
{
}

OGSSettings::~OGSSettings()
{
    //missing: call destructor
}

bool OGSSettings::recipes()
{
    return getValue("recipes").toBool();
}

void OGSSettings::setRecipes(const bool value)
{
    setValue("recipes", value);
    emit moduleChanged();
}

bool OGSSettings::itemtypes()
{
    return getValue("itemtypes").toBool();
}

void OGSSettings::setItemtypes(const bool value)
{
    setValue("itemtypes", value);
    emit moduleChanged();
}

bool OGSSettings::tasks()
{
    return getValue("tasks").toBool();
}

void OGSSettings::setTasks(const bool value)
{
    setValue("tasks", value);
    emit moduleChanged();
}

bool OGSSettings::lists()
{
    return getValue("lists").toBool();
}

void OGSSettings::setLists(const bool value)
{
    setValue("lists", value);
    emit moduleChanged();
}

bool OGSSettings::categories()
{
    return getValue("categories").toBool();
}

void OGSSettings::setCategories(const bool value)
{
    setValue("categories", value);
    emit categoryChanged();
}

bool OGSSettings::categorizeShoppingList()
{
    return getValue("categorizeShoppingList").toBool();
}

void OGSSettings::setCategorizeShoppingList(const bool value)
{
    setValue("categorizeShoppingList", value);
    emit categoryChanged();
}

bool OGSSettings::categorizeItems()
{
    return getValue("categorizeItems").toBool();
}

void OGSSettings::setCategorizeItems(const bool value)
{
    setValue("categorizeItems", value);
    emit categoryChanged();
}

bool OGSSettings::capitalization()
{
    return getValue("capitalization").toBool();
}

void OGSSettings::setCapitalization(const bool value)
{
    setValue("capitalization", value);
    emit capitalizationChanged();
}
