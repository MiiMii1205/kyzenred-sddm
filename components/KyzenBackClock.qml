import QtQuick 2.8
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.5

import org.kde.plasma.core 2.0
import org.kde.plasma.components 2.0 as PlasmaComponents

Item {
    
    anchors.fill: parent
    
    property real basePointSize : 48
    property font font

    Label {
        KyzenColorFade on color {}
        text: Qt.formatTime(timeSource.data["Local"]["DateTime"])
        color: root.kyzenButtonHoverColor
        font.pointSize: login_container.pointHeight * basePointSize / 810
        font.weight: "Black"
        font.family: parent.font.family
        Layout.alignment: Qt.AlignHCenter
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        Layout.fillWidth: true

        y: parent.parent.y - (height* (1/3))
        x: parent.parent.width - (width* (3/4))

    }
    
    Label {
        KyzenColorFade on color {}
        text: Qt.formatDate(timeSource.data["Local"]["DateTime"], Qt.DefaultLocaleLongDate)
        color: root.kyzenButtonHoverColor
        font.pointSize: login_container.pointHeight * basePointSize / 810
        font.weight: "Black"
        font.family: parent.font.family
        Layout.alignment: Qt.AlignHCenter
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        Layout.fillWidth: true

        y: parent.parent.height - (height* (2/3))
        x: parent.parent.x - (width* (3/4))
    }

    DataSource {
        id: timeSource
        engine: "time"
        connectedSources: ["Local"]
        interval: 1000
    }
}