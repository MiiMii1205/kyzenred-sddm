import QtQuick 2.8
import QtQuick.Controls.Styles 1.4  
import QtQuick.Controls.Styles.Plasma 2.0 as Styles
import QtQuick.Shapes 1.5
import QtQuick.Layouts 1.1

import QtQuick.Controls 2.0

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras

ToolTip {
    id: tooltip
    visible: parent.hovered
    font: root.kyzenFont
    opacity: 0
    delay:units.longDuration

    contentItem: Text {
        text: tooltip.text
        font: tooltip.font
        color: root.kyzenButtonTextColor
        KyzenColorFade on color {}
    }

    background: KyzenBorderedFrame {
        buttonBackdropColor: Qt.rgba(root.kyzenButtonBackgroundColor.r,root.kyzenButtonBackgroundColor.g,root.kyzenButtonBackgroundColor.b,0)
        buttonBackgroundColor:applyBackColor(root.kyzenButtonBackgroundColor)
        buttonBorderColor:root.kyzenButtonHoverColor
        flatButtonBackgoundOpacity: 1
    }

    enter: Transition {
            NumberAnimation {
            property:"opacity"
            duration: root.baseAnimationTime
            easing.type: Easing.InOutCirc
            to:1
            easing.overshoot: 0
        }  
    }

    exit: Transition {
        NumberAnimation {
            property:"opacity"
            duration: root.baseAnimationTime
            easing.type: Easing.InOutCirc
            to:0
            easing.overshoot: 0
        }
    }

}