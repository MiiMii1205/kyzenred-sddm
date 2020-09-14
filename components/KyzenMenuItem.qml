import QtQuick 2.8
import QtQuick.Controls.Styles 1.4  
import QtQuick.Controls.Styles.Plasma 2.0 as Styles
import QtQuick.Shapes 1.5
import QtQuick.Layouts 1.1

import QtQuick.Controls 2.0

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras

MenuItem {
    id: menuItem
    padding:7
    hoverEnabled: true
    contentItem: PlasmaComponents.Label {
        opacity: menuItem.enabled ? 1 : 0.5
        id: label
        Layout.fillHeight: true
        text: menuItem.text
        height: contentHeight
        font: menuItem.font
        visible: menuItem.text != ""
        Layout.fillWidth: true
        color: menuItem.highlighted ? root.kyzenHighlightTextColor : root.kyzenButtonTextColor
        KyzenColorFade on color {}
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
    }


    background: KyzenFrame {
        // visible: menuItem.highlighted || menuItem.hovered
        frameColor: root.kyzenHighlightColor

        opacity: menuItem.highlighted || menuItem.hover ? 1 : 0
        KyzenPropertyFade on opacity {}

    } 
}