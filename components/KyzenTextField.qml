import QtQuick 2.8
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls.Styles.Plasma 2.0 as Styles
import QtQuick.Shapes 1.5

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras

import QtQuick.Controls 2.0

TextField { 
    id: field

    font: root.kyzenFont
    
    passwordCharacter: root.kyzenPasswordFieldCharacter
    property string bottomText
    color: root.kyzenTextColor
    placeholderTextColor: root.kyzenTextColor
    selectionColor: root.kyzenHighlightColor
    selectedTextColor: root.kyzenHighlightTextColor
    selectByMouse: true
    property real controlOffsets: 0
    opacity: field.enabled ? 1 : 0.5
    KyzenPropertyFade on opacity {}

    KyzenColorFade on selectedTextColor {}
    KyzenColorFade on selectionColor {}
    KyzenColorFade on color {}
    KyzenColorFade on placeholderTextColor {}

    leftPadding : 7
    topPadding : 1
    bottomPadding : 1
    rightPadding :  7 + controlOffsets

    topInset:0
    leftInset: 0
    rightInset: 0
    bottomInset: bottom_text_label.height
    
    
    background: Item {
        id:field_background
        implicitHeight: Math.max(metrics.height * 1.6,
                        metrics.height + 1 + 1)
        implicitWidth: theme.mSize(field.font).width * 12

        anchors.fill: parent

        TextMetrics {
            id: metrics
            text: "M"
            font: field.font
        }
    
        property size lineScale: field.activeFocus ? "2x2" : "2x1"
        property int lineWidth: field.activeFocus ? 2 : 1
        property double lineOpacity: field.activeFocus ? 1 : 0.3
        
        property color lineColor: field.activeFocus ? root.kyzenHighlightColor : root.kyzenTextColor

        KyzenColorFade on lineColor {}
        KyzenPropertyFade on lineOpacity {}
        KyzenPropertyFade on lineScale {}

        Shape {
            id: bottom_right_lineedit
            width:3.500
            height:0.999

            anchors.right:parent.right
            anchors.bottom:parent.bottom

            transformOrigin: Item.TopLeft
            opacity:field_background.lineOpacity

            ShapePath {
                fillColor: field_background.lineColor
                strokeWidth:-1
                startX: 128; startY: 128

                PathSvg  {
                    path: "M 3.5,1.193634e-8 0,0.99901794 V 1.193634e-8 Z"
                }

            }

            transform: Scale { 
                origin.x: 0
                origin.y: 0
                xScale: 2
                yScale: field_background.lineWidth
            }

        } 
        
        Shape {
            id: bottom_left_lineedit
            width:3.500
            height:0.999
            opacity:field_background.lineOpacity

            anchors.left:parent.left
            anchors.bottom:parent.bottom

            transformOrigin: Item.TopLeft

            ShapePath {
                fillColor: field_background.lineColor
                strokeWidth:-1
                startX: 128; startY: 128


                PathSvg  {
                    path: "M 0,1.193634e-8 3.5,0.99901794 V 1.193634e-8 Z"
                }

            }

            transform: Scale { 
                origin.x: 3.500
                origin.y: 0
                xScale: 2
                yScale:field_background.lineWidth
            }

        }

        Rectangle {
            id: bottom_lineedit
            height:bottom_right_lineedit.height
            color: field_background.lineColor
            opacity:field_background.lineOpacity
            transformOrigin: Item.Top

            anchors.bottom:bottom_right_lineedit.bottom
            anchors.left:bottom_left_lineedit.right
            anchors.right:bottom_right_lineedit.left

            transform: Scale { 
                origin.y: 0
                yScale: field_background.lineWidth
            }
            
        }

        PlasmaComponents.Label {
            id:bottom_text_label
            text: field.bottomText
            font.pointSize: field.font.pointSize * 0.75
            font.family: field.font.family
            color: field_background.lineColor
            opacity:field_background.lineOpacity
            elide: Text.ElideRight

            anchors {
                top:parent.bottom
                topMargin: font.pointSize / 2
                right:parent.right
                left:parent.left
                leftMargin: field.leftPadding
            }
            
            font.weight: Font.Bold
            verticalAlignment: Text.AlignTop
            horizontalAlignment: Text.AlignLeft
            visible: field.bottomText != ""
        }
    }

}