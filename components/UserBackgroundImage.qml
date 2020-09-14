import QtQuick 2.8
import QtGraphicalEffects 1.0

Item {
    id: image
    anchors.fill: parent
    
    property alias source: background.source
    clip: true
    smooth: true
    
    opacity:0

    Image {
        id:background
        fillMode: Image.PreserveAspectCrop
        anchors.fill: parent
        visible: root.softwareRendering || !root.useBlur
    }

    FastBlur {
        id: blur
        anchors.fill: image
        source: background
        radius: 64
        visible: !root.softwareRendering && root.useBlur
        KyzenPropertyFade on radius {}
    }

    KyzenPropertyFade on opacity {}
    
}