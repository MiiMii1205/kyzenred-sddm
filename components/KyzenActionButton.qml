import QtQuick 2.8
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls.Styles.Plasma 2.0 as Styles
import QtQuick.Shapes 1.5
import QtQuick.Layouts 1.1

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras


KyzenFlatSvgButton {
    id: button

    property real iconSize:  (inner_login_box.width * 32) / 480 

    topInset: -5
    leftInset: -5
    rightInset: -5
    bottomInset: -5

    contentItem: ColumnLayout {
        id: action_button_label
        opacity: button.enabled ? 1 : 0.5
        anchors.fill:parent

        Layout.alignment: Qt.AlignVCenter
        spacing: 2

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


        Item {

            Layout.fillWidth: true
            Layout.fillHeight: true 
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.minimumHeight: iconSize
            Layout.minimumWidth: iconSize

            layer.enabled: true
            layer.samples: 4

            // Layout.minimumWidth: (login_container.width * units.iconSizes.medium) / 480 
            // Layout.preferredWidth: (login_container.width * units.iconSizes.large) / 480 
            // Layout.minimumHeight: Layout.minimumWidth
            // Layout.preferredHeight: Layout.preferredWidth
            // Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

            Shape {
                id: icon
                width: svgWidth
                height: svgHeight

                transformOrigin: Item.Center
                anchors.centerIn:parent

                scale:((parent.height) / height)

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
            
            font: button.font
            visible: button.text != ""
            text:button.text
            Layout.fillWidth: true
            Layout.fillHeight: true
            
            // anchors {    
            //     top: icon.bottom
            //     topMargin: (1 * icon.scale) * units.smallSpacing
            //     left: parent.left
            //     right: parent.right
            // }

            KyzenColorFade on color {}
            color: root.kyzenButtonTextColor
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignTop
            wrapMode: Text.WordWrap
            elide: Text.ElideRight
        }
    }

}