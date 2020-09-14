import QtQuick 2.8
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.5

import org.kde.plasma.core 2.0
import org.kde.plasma.components 2.0 as PlasmaComponents

ColumnLayout {
    spacing: 0 

    property real basePointSize : 48

    PlasmaComponents.Label  {
        KyzenColorFade on color {}
        text: Qt.formatTime(timeSource.data["Local"]["DateTime"])
        color: root.kyzenButtonHoverColor
        font.pointSize: login_container.height * basePointSize / 810
        font.weight: Font.Black
        Layout.alignment: Qt.AlignHCenter
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignBottom
        Layout.fillWidth: true
    }

    PlasmaComponents.Label {
        KyzenColorFade on color {}  
        text: Qt.formatDate(timeSource.data["Local"]["DateTime"], Qt.DefaultLocaleLongDate)
        color: root.kyzenButtonHoverColor
        font.pointSize: login_container.height * (basePointSize/2) / 810
        Layout.alignment: Qt.AlignHCenter
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignBottom
        Layout.fillWidth: true
    }

    DataSource {
        id: timeSource
        engine: "time"
        connectedSources: ["Local"]
        interval: 1000
    }
}