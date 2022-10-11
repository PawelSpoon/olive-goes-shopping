/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0
import oarg.pawelspoon.olivegoesshopping.ogssettings 1.0

//this page allows to manage all the lists and settings
Page {
    id: managePage

    // The effective value will be restricted by ApplicationWindow.allowedOrientationso
    allowedOrientations: Orientation.All

    Component.onCompleted:
    {
        console.log(applicationWindow.settings);
        applicationWindow.controller.signal_asset_updated.connect(onAssetChanged)
        initPage()
    }

    function initPage()
    {
        itemtypeModel.clear()
        if (applicationWindow.settings.useItemtypes) {
            commons.fillItemtypesModel(itemtypeModel)
        }
        tasksModel.clear()
        if (applicationWindow.settings.useTasks) {
            //commons.fillTasksModel(tasksModel)
        }        
        listsModel.clear()
        if (applicationWindow.settings.useLists) {
            //commons.fillListstypesModel(listsModel)
        }        
    }

    // callback from e.g dialog pages
    function onAssetChanged(itemType) {
        page.initPage()
    }

    AssetCommons {
        id: commons
    }

    ListModel { //food, household, you name it 
        id: itemtypeModel
    }

    ListModel { // jans, olives shopping list ...
        id: listsModel
    }

    ListModel { // task lists
        id: tasksModel
    }


    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        id: shoppingList
        anchors.fill: parent
        contentHeight: col.height


        PushUpMenu {
            MenuItem {
                text: qsTr("Help")
                onClicked: {
                    applicationWindow.controller.openHelpPage();
                }
            }
            MenuItem {
                text: qsTr("About")
                onClicked: {
                    controller.openAboutPage();
                }
            }
        }

        PageHeader {
            id: header
            title: qsTr("Configure Application")
        }

        VerticalScrollDecorator {}

        // REM: add a slider in case you put more buttons into this column !
        Column {
            id: col
            width: parent.width
            spacing: Theme.paddingLarge
            // could be f(orientation)
            anchors.topMargin: Theme.paddingLarge * 2 * Theme.pixelRatio
            anchors.horizontalCenter: parent.horizontalCenter

            TextArea {
                id: explain
                text: "\n \n"
                readOnly: true
            }
            SectionHeader {
                text: qsTr("General")
            }
            Column {
                width: parent.width
                Button {
                    id: settings
                    text: qsTr("Settings")
                    // anchors.top: head.bottom -- not defined, guess i would need to reference col
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: {
                        applicationWindow.controller.openSettingsPage();
                    }
                }
            }
            SectionHeader {
                text: qsTr("Basics")
            }
            Column {
                width: parent.width
                spacing: Theme.horizontalPageMargin
                Button {
                    id: managePhydims
                    visible: true
                    text: qsTr("Physical dimensions")
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: applicationWindow.controller.openPhyDimMngmtPage()
                }
                Button {
                    id: manageUnits
                    visible: true
                    text: qsTr("Units")
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: applicationWindow.controller.openUnitsMngmtPage()
                }
                Button {
                    id: manageCategories
                    visible: applicationWindow.settings.useCategories
                    text: qsTr("Categories")
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: applicationWindow.controller.openCategoryMngmtPage();
                }
            }
            SectionHeader {
                text: qsTr("Presets")
            }
            Column {
                width: parent.width
                spacing: Theme.horizontalPageMargin
                Button {
                    id: manageRecipes
                    visible: applicationWindow.settings.useRecipes
                    text: qsTr("Recipes")
                    // anchors.top: head.bottom -- not defined, guess i would need to reference col
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: {
                        applicationWindow.controller.openRecipesMngmtPage();
                    }
                }                
                Button {
                    id: manageItemTypes
                    visible: applicationWindow.settings.useItemtypes
                    text: qsTr("Pick list definition")
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: applicationWindow.controller.openItemTypeMngmtPage()
                }
                Label {
                    text: qsTr(" --- Pick lists --- ")
                    anchors.horizontalCenter: parent.horizontalCenter
                    visible: applicationWindow.settings.useItemtypes
                }
                Repeater {
                    id: itemTypeRepeater
                    model: itemtypeModel
                    Button {
                        text: Name
                        anchors.horizontalCenter: parent.horizontalCenter
                        onClicked: applicationWindow.controller.openItemsMngmtPage(text)                        
                    }
                }
                Label {
                    text: " ------ "
                    visible: applicationWindow.settings.useItemtypes
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                // not yet implemented
                /*Button {
                    id: manageLists
                    visible: applicationWindow.settings.useLists
                    text: qsTr("Shopping list definition")
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: applicationWindow.controller.openItemsMngmtPage("list")
                }
                Label {
                    text: " --- shopping list templates --- "
                    visible: applicationWindow.settings.useLists                 
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Repeater {
                    id: listsRepeater
                    model: listsModel
                    Button {
                        text: Name
                        anchors.horizontalCenter: parent.horizontalCenter
                        onClicked: applicationWindow.controller.openItemsMngmtPage(text)                        
                    }
                }
                Label {
                    text: " ------ "
                    visible: applicationWindow.settings.useLists
                    anchors.horizontalCenter: parent.horizontalCenter
                } */
                Button {
                    id: manageTasks
                    visible: applicationWindow.settings.useTasks
                    text: qsTr("Task list templates definition")
                    anchors.horizontalCenter: parent.horizontalCenter
                    // this should allow to add / delete templates ..
                    // edit using buttons below
                    onClicked: applicationWindow.controller.openTemplateMngmtPage("task",2)
                }
                Label {
                    text: " --- task list templates --- "
                    visible: applicationWindow.settings.useTasks
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                Repeater {
                    id: tasksRepeater
                    visible: applicationWindow.settings.useTasks
                    model: tasksModel
                    Button {
                        text: Name
                        anchors.horizontalCenter: parent.horizontalCenter
                        onClicked: applicationWindow.controller.openTemplateMngmtPage("task",text)
                    }
                }
                Label {
                    text: " ------ "
                    visible: applicationWindow.settings.useTasks
                    anchors.horizontalCenter: parent.horizontalCenter
                }                
            }
            SectionHeader {
                text: qsTr("Advanced")
            }
            Column {
                width: parent.width
                spacing: Theme.horizontalPageMargin
                Button {
                    id: impExport
                    text: qsTr("Import Export Reset")
                    anchors.horizontalCenter: parent.horizontalCenter
                    onClicked: {
                        pageStack.push(Qt.resolvedUrl("ExportPage.qml"))
                    }
                }
            }
        }
    }
}

