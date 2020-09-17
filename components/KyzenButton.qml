import QtQuick 2.8
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls.Styles.Plasma 2.0 as Styles
import QtQuick.Shapes 1.5
import QtQuick.Layouts 1.1

import QtQuick.Controls 2.0

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras


Button { 
    id: button
    hoverEnabled: true
    font: root.kyzenFont
    padding: 7

    opacity: (button.enabled ? 1 : 0.5)
    KyzenPropertyFade on opacity {}

    contentItem: RowLayout {
            
            spacing: units.smallSpacing

            property real minimumWidth: implicitWidth + button.letfPadding + button.rightPadding
            onMinimumWidthChanged: {
                if (button.minimumWidth !== undefined) {
                label.minimumWidth = minimumWidth;
                    button.minimumWidth = minimumWidth;
                }
            }

            property real minimumHeight: implicitHeight + button.topPadding + button.bottomPadding
            onMinimumHeightChanged: {
                if (button.minimumHeight !== undefined) {
                label.minimumHeight = minimumHeight;
                    button.minimumHeight = minimumHeight;
                }   
            }

            PlasmaCore.IconItem {
                id: icon
                source: button.iconName || button.iconSource
                Layout.minimumWidth: valid ? units.iconSizes.tiny : 0
                Layout.preferredWidth: valid ? units.iconSizes.small : 0
                visible: valid
                Layout.minimumHeight: Layout.minimumWidth
                Layout.preferredHeight: Layout.preferredWidth
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                active: button.hovered
                colorGroup: PlasmaCore.Theme.ButtonColorGroup
                status: button.activeFocus && !button.pressed && !button.checked ? PlasmaCore.Svg.Selected : PlasmaCore.Svg.Normal
            }

            PlasmaComponents.Label {
                KyzenColorFade on color {}
                id: label
                Layout.fillHeight: true
                text: button.text
                height: undefined
                font: button.font
                visible: button.text != ""
                Layout.fillWidth: true
                color:  root.kyzenButtonTextColor
                KyzenColorFade on color {}
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }
        }

        background: KyzenBorderedFrame {
            flatButtonBackgoundOpacity: 1

            implicitHeight: Math.floor(Math.max(theme.mSize(button.font).height*1.6, contentItem.minimumHeight))

            implicitWidth: {
                if (button.text.length == 0) {
                    height;
                } else {
                    theme.mSize(button.font).width*12
                }
            }

        }
}