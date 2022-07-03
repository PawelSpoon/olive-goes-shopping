
import QtQuick 2.1
import Sailfish.Silica 1.0

//short click will increase howMany by one
//long press will clear

MouseArea {
    id: root

    property alias id: uidLabel.text
    property alias name: label.text
    property int amount
    property alias unit: unitLabel.text
    property alias itemType: typeLabel.text
    property int howMany
    property bool done
    property string category

    property variant receiver

    property bool checked : (howMany > 0)
    property real leftMargin
    property real rightMargin: Theme.paddingLarge
    property bool highlighted: false
    property bool busy


    width: parent ? parent.width : Screen.width
    implicitHeight: Math.max(toggle.height, desc.y + desc.height)

    Item {
        id: toggle

        width: Theme.itemSizeExtraSmall
        height: Theme.itemSizeSmall
        anchors {
            left: parent.left
            leftMargin: root.leftMargin
        }

        GlassItem {
            id: indicator
            anchors.centerIn: parent
            opacity: root.enabled ? 1.0 : 0.4
            dimmed: !checked
            falloffRadius: checked ? defaultFalloffRadius : 0.075
            Behavior on falloffRadius {
                NumberAnimation { duration: busy ? 450 : 50; easing.type: Easing.InOutQuad }
            }
            // KLUDGE: Behavior and State don't play well together
            // http://qt-project.org/doc/qt-5/qtquick-statesanimations-behaviors.html
            // force re-evaluation of brightness when returning to default state
            brightness: { return 1.0 }
            Behavior on brightness {
                NumberAnimation { duration: busy ? 450 : 50; easing.type: Easing.InOutQuad }
            }
            color: highlighted ? Theme.highlightColor : Theme.primaryColor
        }
        states: State {
            when: root.busy
            PropertyChanges { target: indicator; brightness: busyTimer.brightness; dimmed: false; falloffRadius: busyTimer.falloffRadius; opacity: 1.0 }
        }

    }

    Label {
        id: label
        opacity: root.enabled ? 1.0 : 0.4
        anchors {
            verticalCenter: toggle.verticalCenter
            // center on the first line if there are multiple lines
            verticalCenterOffset: lineCount > 1 ? (lineCount-1)*height/lineCount/2 : 0
            left: toggle.right
            right: prio.left
        }
        wrapMode: Text.NoWrap
        color: highlighted ? Theme.highlightColor : (checked ? Theme.primaryColor : Theme.secondaryColor)
        truncationMode: TruncationMode.Elide
    }

    Item {
        id: prio
        width: Theme.itemSizeExtraSmall
        height: Theme.itemSizeSmall
        anchors {
            right: parent.right
        }
        visible: howMany > 0

        Label {
            id: prioIndicator
            anchors.centerIn: parent
            text: howMany
            color: highlighted ? Theme.highlightColor : (checked ? Theme.primaryColor : Theme.secondaryColor)
        }
    }

    Label {
        id: desc
        height: text.length ? (implicitHeight + Theme.paddingMedium) : 0
        opacity: root.enabled ? 1.0 : 0.4
        anchors {
            top: label.bottom
            left: label.left
            //right: parent.right
            rightMargin: Theme.paddingLarge
        }
        wrapMode: Text.NoWrap
        font.pixelSize: Theme.fontSizeExtraSmall
        color: highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
        truncationMode: TruncationMode.Elide
    }

    Label {
        id: unitLabel
        height: desc.height
        opacity: root.enabled ? 1.0 : 0.4
        anchors {
            top: label.bottom
            left: desc.right
            //right: parent.right
            rightMargin: Theme.paddingLarge
        }
        wrapMode: Text.NoWrap
        font.pixelSize: Theme.fontSizeExtraSmall
        color: highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor
        truncationMode: TruncationMode.Elide
    }

    Label {
        id: uidLabel
        visible: false
    }

    Label {
        id: typeLabel
        visible: false
    }

    onClicked: {
        howMany ++
        checked = (howMany > 0)
        print(id + " " + name + " " + howMany + " " + itemType + " " + category)
        receiver.update(id,name,itemType,category,amount,unit,howMany)
    }

    onPressAndHold: {
        howMany = 0
        checked = false
        receiver.update(id,name,itemType,category,amount,unit,howMany,done)
    }

}
