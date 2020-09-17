import QtQuick 2.8
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls.Styles.Plasma 2.0 as Styles
import QtQuick.Shapes 1.5
import QtQuick.Layouts 1.1

import QtQuick.Controls 2.0

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras


ComboBox { 
    id: button
    property string arrowSvgPath
    property real svgWidth
    property real svgHeight
    textRole: "longName"
    valueRole: "shortName"
    hoverEnabled: true
    font: root.kyzenFont
    displayText: i18nd("plasma_lookandfeel_org.kde.lookandfeel", "Keyboard Layout: %1", currentValue || currentText || "")

    visible: count > 1

    opacity: (button.enabled ? 1 : 0.5)
    KyzenPropertyFade on opacity {}

    currentIndex: keyboard.currentLayout
    onActivated: keyboard.currentLayout = button.currentIndex

    padding:7

    delegate: KyzenMenuItem {
        id: wrapper
        width: button.width
        height: button.height
        text: modelData.longName
        font: button.font
        // property string shortName: modelData.shortName
        highlighted: button.highlightedIndex === index || wrapper.hovered
    }

    popup: KyzenMenu{
        property int sessionIndex: 0
        y: sessionIndex * -button.height
        width: button.width
        implicitHeight: contentItem.implicitHeight
        transformOrigin: Item.Center
        opacity: 0
        font: button.font

        Component.onCompleted: currentIndex = Qt.binding(function() {return keyboard.currentLayout});

        // KyzenPropertyFade on y {}

       enter: Transition {
             NumberAnimation {
                // target: b_root.target
                property:"opacity"
                duration: root.baseAnimationTime
                easing.type: Easing.InOutCirc
                to:1
                easing.overshoot: 0
            }  
        }

        exit: Transition {
            SequentialAnimation {
                NumberAnimation {
                    // target: b_root.target
                    property:"opacity"
                    duration: root.baseAnimationTime
                    easing.type: Easing.InOutCirc
                    to:0
                    easing.overshoot: 0
                }

                PropertyAction {
                    property: "sessionIndex"
                    value: button.currentIndex
                }
            }
        }
        
        contentItem: ListView {
            id:keyboard_list_view
            clip: true
            implicitHeight: contentHeight
            model: button.popup.visible ? button.delegateModel : null
            currentIndex: button.highlightedIndex
            ScrollIndicator.vertical: ScrollIndicator { }
        }

    }

    implicitHeight: Math.floor(Math.max(theme.mSize(font).height*1.6, contentItem.minimumHeight))
 
    implicitWidth: {
        if (displayText.length == 0) {
            return height;
        } else {
            return  theme.mSize(font).width*12
        }
    }

    contentItem:  PlasmaComponents.Label {
        property real minimumWidth: implicitWidth + button.letfPadding + button.rightPadding
        onMinimumWidthChanged: {
            if (button.minimumWidth !== undefined) {
                style.minimumWidth = minimumWidth;
                button.minimumWidth = minimumWidth;
            }
        }

        property real minimumHeight: implicitHeight + button.topPadding + button.bottomPadding
        onMinimumHeightChanged: {
            if (button.minimumHeight !== undefined) {
                style.minimumHeight = minimumHeight;
                button.minimumHeight = minimumHeight;
            }   
        }

        opacity: (1 - button.popup.opacity)
        id: label
        text: button.displayText
        font: button.font
        visible: button.text != ""
        color: button.activeFocus && !button.pressed && !button.checked ? root.kyzenHighlightTextColor : root.kyzenButtonTextColor
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight

        anchors {
            left: parent.left
            leftMargin: 7
            verticalCenter: parent.verticalCenter
        }
        
        KyzenColorFade on color {}

    }

    indicator: Shape {
        id: arrow
        width: svgWidth
        height: svgHeight
        opacity: label.opacity 

        transformOrigin: Item.Center

        anchors {
            right: button.right
            rightMargin: button.rightPadding/2
            verticalCenter: button.verticalCenter
        }

        scale:(16 / height)

        ShapePath {
            fillColor: label.color
            strokeWidth: -1
            startX: 128; startY: 128
            PathSvg {
                path: arrowSvgPath
            }
        }
    }

    background: KyzenBorderedFrame {
        flatButtonBackgoundOpacity: 1

        // visible:!popup.visible
        opacity: 1 - button.popup.opacity 

        implicitHeight: Math.floor(Math.max(theme.mSize(font).height*1.6, button.contentItem.minimumHeight))

        implicitWidth: {
            if (currentText.length == 0) {
                height;
            } else {
                theme.mSize(font).width*12
            }
        }

    }
}