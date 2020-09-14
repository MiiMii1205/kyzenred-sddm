import QtQuick 2.8

Behavior{
    id:b_root
    // property Item target: targetProperty.object

    ColorAnimation {
        duration: root.baseAnimationTime
        easing.type: Easing.InOutCirc
        easing.overshoot: 0
        id:color_fade
    } 

}
