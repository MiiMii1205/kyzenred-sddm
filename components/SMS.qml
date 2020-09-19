import QtQuick 2.2

import QtQuick.Layouts 1.1
import QtQuick.Controls 1.1

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

Item {
    id: sms_root

    /*
     * Any message to be displayed to the user, visible above the text fields
     */
    property alias notificationMessage: notificationsLabel.text
    // property alias actionItems: actionItemsLayout.children
    property alias userListModel: user_list_view.model
    property alias currentUser: user_list_view.currentItem
    property alias currentSession: session_switcher.currentIndex

    property alias userListCurrentIndex: user_list_view.currentIndex
    property var userListCurrentModelData: user_list_view.currentItem === null ? [] : user_list_view.currentItem.m
    property bool showUserList: true

    property alias userList: user_list_view

    property font font: root.kyzenFont

    property alias fontSize: sms_root.font.pointSize
    property string fontFamily:  sms_root.font.family

    property real promptsPointHeight: (prompts.height * 1 / 0.75) 
    property real usernameHeight: { currentUser === null ? 0 : user_list_view.currentItem.usernameLabelHeight }
    fontSize: Math.max(promptsPointHeight * root.kyzenFont.pointSize / 810, 0.0001) 

    default property alias _children: innerLayout.children

    UserList {
        id:  user_list_view
        visible: sms_root.showUserList
        model: userModel
        font: sms_root.font
        anchors.fill: sms_root

        anchors.topMargin: login_tile.height+notificationsLabel.height
    }

    ColumnLayout {
        id: prompts
        anchors {
           fill: sms_root
           margins: 7
        }

        // spacing:  units.largeSpacing

        PlasmaComponents.Label {
            id: login_tile
            font.pointSize: promptsPointHeight * ( root.kyzenFont.pointSize * 64 / 10 ) / 810
            font.family: sms_root.font.family 
            font.weight: Font.Black
            Layout.maximumWidth: prompts.width
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            color: root.kyzenButtonHoverColor
            text:sddm.hostName || "KYZEN"
            font.capitalization: Font.AllUppercase
            KyzenColorFade on color {}

            fontSizeMode: Text.HorizontalFit
        }

        PlasmaComponents.Label {
            id: notificationsLabel
            font.pointSize: sms_root.font.pointSize + 2
            font.family: sms_root.font.family 
            Layout.maximumWidth: prompts.width
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            color: root.kyzenButtonHoverColor
            text: ""
            visible: notificationsLabel.text != ""
            KyzenColorFade on color {}
        } 

        ColumnLayout {
            Layout.maximumHeight: implicitHeight
            // Layout.maximumHeight: implicitHeight
            Layout.maximumWidth: prompts.width
            Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

            Item {
                id: userbox
                Layout.minimumHeight: ((login_container.calculatedWidth * 128) / 480) + usernameHeight +  units.largeSpacing
                Layout.maximumHeight: (login_container.calculatedHeight /2)
                Layout.fillWidth: true
            }
            
            ColumnLayout {
                id: innerLayout
                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing:0
            }

        }

        Item {
            Layout.fillHeight: true
        }

        KyzenSessionManager {
            id: session_switcher
            Layout.fillWidth: true

            arrowSvgPath: "m 7.0006681,9.0009671 -3.0723263,-3.072326 0.928234,-0.928234 h 4.2882229 l 0.9282333,0.928234 z"
            svgWidth: 14.001
            svgHeight: 14.001
            font: sms_root.font

            model: sessionModel
            currentIndex: sessionModel.lastIndex
        }

        KyzenKeyboardManager {
            id: keyboard_manager
            Layout.fillWidth: true

            arrowSvgPath: "m 7.0006681,9.0009671 -3.0723263,-3.072326 0.928234,-0.928234 h 4.2882229 l 0.9282333,0.928234 z"
            svgWidth: 14.001
            svgHeight: 14.001
            font: sms_root.font

            model: keyboard.layouts
            currentIndex: keyboard.currentLayout
        }

    }


}