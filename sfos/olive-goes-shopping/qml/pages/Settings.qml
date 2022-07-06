//<license>

import QtQuick 2.0
import Sailfish.Silica 1.0
import oarg.pawelspoon.olivegoesshopping.ogssettings 1.0

Page {
    /*OGSSettings {
        id: settings
    }*/

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height + Theme.paddingLarge

        Component.onCompleted:
        {
            console.log(applicationWindow.settings.useRecipes)

            useRecipes.checked = applicationWindow.settings.useRecipes
            useItemTypes.checked = applicationWindow.settings.useItemtypes
            useLists.checked = applicationWindow.settings.useLists
            useTasks.checked = applicationWindow.settings.useTasks
            useCategories.checked = applicationWindow.settings.useCategories
            categorizeItems.checked = applicationWindow.settings.categorizeItems
            categorizeShoppingList.checked = applicationWindow.settings.categorizeShoppingList
            useCapitalization.checked = applicationWindow.settings.useCapitalization
        }

        // Why is this necessary?
        contentWidth: parent.width

        VerticalScrollDecorator {}
        Column {
            id: column
            spacing: Theme.paddingLarge
            width: parent.width
            PageHeader {
                title: qsTr("Settings")
            }
            SectionHeader {
                text: qsTr("Modules")
            }
            Column {
                width: parent.width
                property bool playing
                TextSwitch {
                    id: useRecipes
                    text: qsTr("Use recipes")
                    description: "will allow you to manage recipes and add those to shopping list"
                    automaticCheck: true;
                    onCheckedChanged: {
                        applicationWindow.settings.useRecipes = checked;
                    }
                }
                TextSwitch {
                    id: useItemTypes
                    text: qsTr("Use various pre-configured items")
                    description: "create pick lists e.g. household, food so speed up shopping list creation"
                    automaticCheck: true;
                    onCheckedChanged: {
                        applicationWindow.settings.useItemtypes = checked;
                    }
                }
                TextSwitch {
                    id: useLists
                    text: qsTr("Use (multiple) shopping lists")
                    description: "create shopping lists and add items or recipes to them"
                    automaticCheck: true;
                    onCheckedChanged: {
                        applicationWindow.settings.useLists = checked;
                    }
                }
                /*TextSwitch {
                    id: useTasks
                    text: qsTr("Use (multiple) task lists")
                    description: "simple task management"
                    automaticCheck: true;
                    onCheckedChanged: {
                        applicationWindow.settings.useList = checked;
                    }
                }*/
            }
            SectionHeader {
                text: "Categories"
            }
            TextSwitch {
                id: useCategories
                text: "Show categories"
                description: "will allow you to manage categories and link them to items"
                automaticCheck: true;
                onCheckedChanged: {
                    applicationWindow.settings.useCategories = checked;
                    if (checked === false) {
                        categorizeItems.checked = false;
                        categorizeShoppingList.checked = false;
                    }
                }
            }
            TextSwitch {
                id: categorizeShoppingList
                text: "Show categories in shopping list"
                visible: useCategories.checked
                // description: "includes categories"
                automaticCheck: true;
                onCheckedChanged: {
                    applicationWindow.settings.categorizeShoppingList = checked;
                }
            }
            TextSwitch {
                id: categorizeItems
                text: "Show categories in items"
                //description: "includes categories"
                visible: useCategories.checked
                automaticCheck: true;
                onCheckedChanged: {
                    applicationWindow.settings.categorizeItems = checked;
                }
            }
            /*SectionHeader {
                text: "Text input"
            }
            TextSwitch {
                id: useCapitalization
                text: "Capitalize items"
                description: "all textfields will capitalize your input (after restart)"
                automaticCheck: true;
                onCheckedChanged: {
                    applicationWindow.settings.useCapitalization = checked;
                    /*if (checked === false) {
                        categorizeItems.checked = false;
                        categorizeShoppingList.checked = false;
                    }*/
            /*    }
            }*/
        }
    }
}
