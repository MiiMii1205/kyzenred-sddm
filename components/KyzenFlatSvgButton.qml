import QtQuick 2.8
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls.Styles.Plasma 2.0 as Styles
import QtQuick.Shapes 1.5
import QtQuick.Layouts 1.1

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras


KyzenSvgButton { 
    id: button

    opacity: button.enabled ? 1 : 0.5
    KyzenPropertyFade on opacity {}
    padding:7

    contentItem: RowLayout {
        spacing: units.smallSpacing

        property real minimumWidth: implicitWidth + button.letfPadding + button.rightPadding
        onMinimumWidthChanged: {
            if (button.minimumWidth !== undefined) {
                // label.minimumWidth = minimumWidth;
                button.minimumWidth = minimumWidth;
            }
        }

        property real minimumHeight: implicitHeight + button.topPadding + button.bottomPadding
        onMinimumHeightChanged: {
            if (button.minimumHeight !== undefined) {
            // label.minimumHeight = minimumHeight;
                button.minimumHeight = minimumHeight;
            }   
        }

        Item {

            layer.enabled: true
            layer.samples: 12

            Layout.fillHeight: true
            Layout.fillWidth: true

            // Layout.minimumWidth: (login_container.width * units.iconSizes.medium) / 480 
            // Layout.preferredWidth: (login_container.width * units.iconSizes.large) / 480 
            // Layout.minimumHeight: Layout.minimumWidth
            // Layout.preferredHeight: Layout.preferredWidth
            // Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

            // Layout.minimumWidth: button.minimumWidth
            // Layout.minimumHeight: button.minimumHeight
            Layout.preferredWidth: height

                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

            Shape {
                id: icon
                width: svgWidth
                height: svgHeight

                transformOrigin: Item.Center
                anchors.centerIn:parent

                scale: width < height ? ((parent.width) / width) : ((parent.height) / height)

                ShapePath {
                    id: icon_path
                    fillColor: label.color
                    strokeWidth: -1
                    startX: 128; startY: 128
                    PathSvg {
                        path: iconSvgPath
                    }
                }
            }

        }

        PlasmaComponents.Label {
            id: label
            Layout.fillHeight: true
            text: button.text
            height: undefined
            font: button.font
            visible: button.text != ""
            Layout.fillWidth: true
            color: root.kyzenButtonTextColor
            KyzenColorFade on color {}
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }
    }
    
    background: KyzenBorderedFrame {
        buttonBorderColor: "transparent"
        implicitHeight: Math.floor(Math.max(theme.mSize(button.font).height*1.6, contentItem.minimumHeight))

        opacity: button.pressed || parent.hovered ? 1: 0
        KyzenPropertyFade on opacity {}  

        implicitWidth: contentItem.width
    }
}