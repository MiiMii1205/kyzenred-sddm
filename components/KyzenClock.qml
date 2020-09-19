import QtQuick 2.8
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.5

import org.kde.plasma.core 2.0
import org.kde.plasma.components 2.0 as PlasmaComponents

ColumnLayout {
    spacing: 5

    property real basePointSize : 48
    property font font
    
    PlasmaComponents.Label  {
        id:clockTime
        KyzenColorFade on color {}
        text: Qt.formatTime(timeSource.data["Local"]["DateTime"])
        color: root.kyzenButtonHoverColor
        font.pointSize: login_container.pointHeight * basePointSize / 810
        Layout.maximumHeight: ( clockTime.fontInfo.pointSize *  10  / 10 ) 
        font.weight: Font.Black
        font.family: parent.font.family
        Layout.alignment: Qt.AlignHCenter
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignBottom
        maximumLineCount:1
        Layout.fillWidth: true
        elide: Text.ElideRight
        height: Math.floor(Math.max(theme.mSize(font).height, implicitHeight))
    }

    PlasmaComponents.Label {
        id:clockDate
        KyzenColorFade on color {}  
        text: Qt.formatDate(timeSource.data["Local"]["DateTime"], Qt.DefaultLocaleLongDate)
        Layout.maximumHeight: ( clockDate.fontInfo.pointSize *  10  / 10 ) 
        color: root.kyzenButtonHoverColor
        font.pointSize: clockTime.font.pointSize/2
        Layout.alignment: Qt.AlignHCenter
        font.family: clockTime.font.family
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignBottom
        maximumLineCount:1
        Layout.fillWidth: true
        elide: Text.ElideRight
        height: Math.floor(Math.max(theme.mSize(font).height, implicitHeight))
    }

    DataSource {
        id: timeSource
        engine: "time"
        connectedSources: ["Local"]
        interval: 1000
    }
}