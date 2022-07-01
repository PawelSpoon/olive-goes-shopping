#ifndef OGSSETTINGS_H
#define OGSSETTINGS_H

#include <QObject>
#include <QStringList>
#include "settings.h"


class OGSSettings : public Settings
{
    Q_OBJECT
public:
    explicit OGSSettings(QObject *parent = 0);
    ~OGSSettings();

    // proxy to Qt QSettings, because QtQuick module "Qt.labs.settings" is not available
    Q_PROPERTY(bool useRecipes READ recipes WRITE setRecipes NOTIFY moduleChanged)
    bool recipes();
    void setRecipes(const bool value);

    Q_PROPERTY(bool useItemtypes READ itemtypes WRITE setItemtypes NOTIFY moduleChanged)
    bool itemtypes();
    void setItemtypes(const bool value);

    Q_PROPERTY(bool useTasks READ tasks WRITE setTasks NOTIFY moduleChanged)
    bool tasks();
    void setTasks(const bool value);

    Q_PROPERTY(bool useLists READ lists WRITE setLists NOTIFY moduleChanged)
    bool lists();
    void setLists(const bool value);

    Q_PROPERTY(bool useCategories READ categories WRITE setCategories NOTIFY categoryChanged)
    bool categories();
    void setCategories(const bool value);

    Q_PROPERTY(bool categorizeShoppingList READ categorizeShoppingList WRITE setCategorizeShoppingList NOTIFY categoryChanged)
    bool categorizeShoppingList();
    void setCategorizeShoppingList(const bool value);

    Q_PROPERTY(bool categorizeItems READ categorizeItems WRITE setCategorizeItems NOTIFY categoryChanged)
    bool categorizeItems();
    void setCategorizeItems(const bool value);

    Q_PROPERTY(bool useCapitalization READ capitalization WRITE setCapitalization NOTIFY capitalizationChanged)
    bool capitalization();
    void setCapitalization(const bool value);

signals:
    void moduleChanged();
    void categoryChanged();
    void capitalizationChanged();

};

#endif // SETTINGS_H
