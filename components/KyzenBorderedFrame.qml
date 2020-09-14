import QtQuick 2.8
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls.Styles.Plasma 2.0 as Styles
import QtQuick.Shapes 1.5
import QtQuick.Layouts 1.1

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras

Item {

    // Component.onCompleted: {
    //     padding.top = 7
    //     padding.left = 7
    //     padding.right = 7
    //     padding.bottom = 7
    // }

    id: frame_group
    layer.enabled: true
    layer.samples: 12

    property color buttonBackdropColor:  applyBackColor(applyState(Qt.rgba(root.kyzenButtonBackgroundColor.r,root.kyzenButtonBackgroundColor.g,root.kyzenButtonBackgroundColor.b,0), root.kyzenButtonHoverColor, root.kyzenButtonFocusColor, root.kyzenViewBackgroundColor)) 
    property color buttonBackgroundColor: applyBackColor(applyState( root.kyzenButtonBackgroundColor , root.kyzenButtonBackgroundColor, root.kyzenButtonBackgroundColor, root.kyzenViewBackgroundColor))
    property color buttonBorderColor:  applyState( root.kyzenButtonHoverColor , root.kyzenButtonFocusColor, root.kyzenButtonFocusColor, root.kyzenViewBackgroundColor) 
    property double flatButtonBackgoundOpacity: applyOpacityState() 
    
    function applyState(normal, hover, focus, active) {

    if(parent.enabled) {

        if(parent.pressed) {
            return active
        } else if (parent.activeFocus) {
            return focus
        } else if (parent.hovered) {
            return hover
        } 

    } 

    return normal

    }

    function applyOpacityState() {
        if(parent.enabled){
            return 1
        }
        return 0
    }

    function applyBackColor(color) {
    return  Qt.rgba(color.r, color.g, color.b, Math.min(0.5, Math.max(color.a, 0.005)))
    }

    KyzenColorFade on buttonBackdropColor {}
    KyzenColorFade on buttonBorderColor {}
    KyzenColorFade on buttonBackgroundColor {}
    KyzenPropertyFade on flatButtonBackgoundOpacity {}  

    // anchors.fill: parent

    Shape {
        id: top_left_frame
        width:7
        height:7

        anchors.left:parent.left
        anchors.top:parent.top

        transformOrigin: Item.TopLeft

        ShapePath {
            fillColor: frame_group.buttonBackdropColor
            strokeWidth:-1
            startX: 128; startY: 128

            PathSvg  {
                path: "M 7,7.0001407 V 1.5117999e-4 L 0,7.0001407 Z"
            }
        }

        ShapePath {
            fillColor: frame_group.buttonBackgroundColor
            strokeWidth:-1
            startX: 128; startY: 128

            PathSvg  {
                path: "M 7,7.0001407 V 1.5117999e-4 L 0,7.0001407 Z"
            }
        }

        ShapePath {
            fillColor: frame_group.buttonBorderColor
            strokeWidth:-1
            startX: 128; startY: 128

            PathSvg  {
                path: "M 1.3538045,6.9998414 6.9998348,1.3538111 V -1.4882001e-4 L 3.9219498e-4,6.999284 Z"
            }

        }

    } 

    Item {
        id:top_frame

        anchors.top:parent.top

        anchors.left:top_left_frame.right
        anchors.right:top_right_frame.left

        anchors.bottom:top_left_frame.bottom

        Rectangle {
            anchors.fill:parent
            color: frame_group.buttonBackdropColor
        }

        Rectangle {
            anchors.fill:parent
            color: frame_group.buttonBackgroundColor
        }

        Rectangle {
            anchors.top:parent.top
            anchors.right:parent.right
            anchors.left:parent.left

            color: frame_group.buttonBorderColor
            height: 1.354
        }
            
    }


    Shape {
        id: top_right_frame
        width:7
        height:7

        anchors.right:parent.right
        anchors.top:parent.top

        transformOrigin: Item.TopRight

        ShapePath {
            fillColor: frame_group.buttonBackdropColor
            strokeWidth:-1
            startX: 128; startY: 128

            PathSvg  {
                path: "M 1.5003498e-4,6.8729988e-5 V 6.9999231 H 6.9999999 V 6.8729988e-5 Z"
            }
        }

        ShapePath {
            fillColor: frame_group.buttonBackgroundColor
            strokeWidth:-1
            startX: 128; startY: 128

            PathSvg  {
                path: "M 1.5003498e-4,6.8729988e-5 V 6.9999231 H 6.9999999 V 6.8729988e-5 Z"
            }
        }

        ShapePath {
            fillColor: frame_group.buttonBorderColor
            strokeWidth:-1
            startX: 128; startY: 128

            PathSvg  {
                path: "M 5.6474692,6.9992734 H 6.9995404 L 6.9998903,6.8729988e-5 3.4981508e-8,7.8729988e-5 V 1.3537107 H 5.6474692 Z"
            }

        }

    } 


    Item {
        id:left_frame

        anchors.left:parent.left

        anchors.top:top_left_frame.bottom
        anchors.bottom:bottom_left_frame.top

        anchors.right:top_left_frame.right

        Rectangle {
            anchors.fill:parent
            color: frame_group.buttonBackdropColor
        }

        Rectangle {
            anchors.fill:parent
            color: frame_group.buttonBackgroundColor
        }

        Rectangle {
            anchors.top:parent.top
            anchors.bottom:parent.bottom
            anchors.left:parent.left

            color: frame_group.buttonBorderColor
            width: 1.354
        }
            
    }

    Item {
        id: center_frame

        anchors.bottom:bottom_frame.top
        anchors.top:top_frame.bottom
        anchors.left:left_frame.right
        anchors.right:right_frame.left

        Rectangle {
            anchors.fill:parent
            color: frame_group.buttonBackdropColor
        }

        Rectangle {
            anchors.fill:parent
            color: frame_group.buttonBackgroundColor
        }

    }

    Item {
        id:right_frame

        anchors.right:parent.right

        anchors.top:top_right_frame.bottom
        anchors.bottom:bottom_right_frame.top

        anchors.left:top_right_frame.left

        Rectangle {
            anchors.fill:parent
            color: frame_group.buttonBackdropColor
        }

        Rectangle {
            anchors.fill:parent
            color: frame_group.buttonBackgroundColor
        }

        Rectangle {
            anchors.top:parent.top
            anchors.bottom:parent.bottom
            anchors.right:parent.right

            color: frame_group.buttonBorderColor
            width: 1.354
        }
            
    }


    Shape {
        id: bottom_left_frame
        width:7
        height:7

        anchors.left:parent.left
        anchors.bottom:parent.bottom

        transformOrigin: Item.BottomRight

        ShapePath {
            fillColor: frame_group.buttonBackdropColor
            strokeWidth:-1
            startX: 128; startY: 128

            PathSvg  {
                path: "M 1.5003498e-4,6.8729988e-5 V 6.9999231 H 6.9999999 V 6.8729988e-5 Z"
            }

        }

        ShapePath {
            fillColor: frame_group.buttonBackgroundColor
            strokeWidth:-1
            startX: 128; startY: 128

            PathSvg  {
                path: "M 1.5003498e-4,6.8729988e-5 V 6.9999231 H 6.9999999 V 6.8729988e-5 Z"
            }

        }

        ShapePath {
            fillColor: frame_group.buttonBorderColor
            strokeWidth:-1
            startX: 128; startY: 128

            PathSvg  {
                path: "M 1.3537288,2.0592999e-4 H 3.5078498e-4 L -2.1501849e-7,6.9992149 6.9996953,6.9992049 V 5.6466469 H 1.3537288 Z"
            }

        }

    } 



    Item {
        id:bottom_frame

        anchors.bottom:parent.bottom

        anchors.left:bottom_left_frame.right
        anchors.right:bottom_right_frame.left

        anchors.top:bottom_left_frame.top

        Rectangle {
            anchors.fill:parent
            color: frame_group.buttonBackdropColor
        }

        Rectangle {
            anchors.fill:parent
            color: frame_group.buttonBackgroundColor
        }

        Rectangle {
            anchors.bottom:parent.bottom
            anchors.right:parent.right
            anchors.left:parent.left

            color: frame_group.buttonBorderColor
            height: 1.354
        }
            
    }


    Shape {
        id: bottom_right_frame
        width:7
        height:7

        anchors.right:parent.right
        anchors.bottom:parent.bottom

        transformOrigin: Item.BottomRight

        ShapePath {
            fillColor: frame_group.buttonBackdropColor
            strokeWidth:-1
            startX: 128; startY: 128

            PathSvg  {
                path: "M -1.1501849e-7,-1.4200116e-6 V 6.9999984 L 7.0000001,-1.4200116e-6 Z"
            }

        }

        ShapePath {
            fillColor: frame_group.buttonBackgroundColor
            strokeWidth:-1
            startX: 128; startY: 128

            PathSvg  {
                path: "M -1.1501849e-7,-1.4200116e-6 V 6.9999984 L 7.0000001,-1.4200116e-6 Z"
            }

        }

        ShapePath {
            fillColor: frame_group.buttonBorderColor
            strokeWidth:-1
            startX: 128; startY: 128

            PathSvg  {
                path: "M 5.6473396,-6.5200116e-6 -1.1501849e-7,5.6474124 v 1.352581 L 6.9994496,5.4337999e-4 Z"
            }

        }

    } 
}