import QtQuick 2.8
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls.Styles.Plasma 2.0 as Styles
import QtQuick.Shapes 1.5
import QtQuick.Layouts 1.1

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras


Item { 
    
        id: frame_group
        layer.enabled: true
        layer.samples: 4

        property color frameColor: root.kyzenViewBackgroundColor

        KyzenColorFade on frameColor {}
       
            // anchors.fill: parent

            Shape {
                id: top_left_frame
                width:7
                height:7

                anchors.left:parent.left
                anchors.top:parent.top

                transformOrigin: Item.TopLeft

                ShapePath {
                    fillColor: frame_group.frameColor
                    strokeWidth:-1
                    startX: 128; startY: 128

                    PathSvg  {
                        path: "M 7,7.0001407 V 1.5117999e-4 L 0,7.0001407 Z"
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
                    color: frame_group.frameColor
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
                    fillColor: frame_group.frameColor
                    strokeWidth:-1
                    startX: 128; startY: 128

                    PathSvg  {
                        path: "M 1.5003498e-4,6.8729988e-5 V 6.9999231 H 6.9999999 V 6.8729988e-5 Z"
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
                    color: frame_group.frameColor
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
                    color: frame_group.frameColor
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
                    color: frame_group.frameColor
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
                    fillColor: frame_group.frameColor
                    strokeWidth:-1
                    startX: 128; startY: 128

                    PathSvg  {
                        path: "M 1.5003498e-4,6.8729988e-5 V 6.9999231 H 6.9999999 V 6.8729988e-5 Z"
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
                    color: frame_group.frameColor
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
                    fillColor: frame_group.frameColor
                    strokeWidth:-1
                    startX: 128; startY: 128

                    PathSvg  {
                        path: "M -1.1501849e-7,-1.4200116e-6 V 6.9999984 L 7.0000001,-1.4200116e-6 Z"
                    }

                }

            } 
        
    
}