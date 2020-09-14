import QtQuick 2.8

Behavior{
    id:b_root
    // property Item target: targetProperty.object

    PropertyAnimation {
        // target: b_root.target
        duration: root.baseAnimationTime
        easing.type: Easing.InOutCirc
        easing.overshoot: 0
        id:property_fade
    }  

}