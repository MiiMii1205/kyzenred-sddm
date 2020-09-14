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
    property int fontSize: prompts.height * config.fontSize / 810

    default property alias _children: innerLayout.children

    UserList {
        id:  user_list_view
        visible: parent.showUserList
        model: userModel
        fontSize: parent.fontSize
        anchors.fill: parent

        anchors.topMargin: login_tile.height+notificationsLabel.height
    }

    ColumnLayout {
        id: prompts
        anchors {
           fill: parent
           margins: 7
        }


        PlasmaComponents.Label {
            id: login_tile
            font.pointSize: prompts.height * 64 / 810
            Layout.maximumWidth: prompts.width
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            font.weight: Font.Black
            color: root.kyzenButtonHoverColor
            text:sddm.hostName || "KYZEN"
            KyzenColorFade on color {}
        }

        PlasmaComponents.Label {
            id: notificationsLabel
            font.pointSize: fontSize + 2
            Layout.maximumWidth: prompts.width
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            color: root.kyzenButtonHoverColor
            text: "KYZEN"
            KyzenColorFade on color {}
        }

        ColumnLayout {
            Layout.minimumHeight: implicitHeight
            Layout.maximumHeight: prompts.height
            Layout.maximumWidth: prompts.width
            Layout.alignment: Qt.AlignHCenter

            spacing:  units.largeSpacing
            
            Item {
                id: userbox
                Layout.minimumHeight: ((login_container.calculatedWidth * 128) / 480) + notificationsLabel.height + units.largeSpacing
                Layout.maximumHeight: units.gridUnit * 10
                Layout.fillWidth: true
            }
            
            ColumnLayout {
                id: innerLayout
                Layout.alignment: Qt.AlignHCenter
                Layout.fillWidth: true
            }

            Item {
                Layout.fillHeight: true
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

            model: sessionModel
            currentIndex: sessionModel.lastIndex
        }

        KyzenKeyboardManager {
            id: keyboard_manager
            Layout.fillWidth: true

            arrowSvgPath: "m 7.0006681,9.0009671 -3.0723263,-3.072326 0.928234,-0.928234 h 4.2882229 l 0.9282333,0.928234 z"
            svgWidth: 14.001
            svgHeight: 14.001

            model: keyboard.layouts
            currentIndex: keyboard.currentLayout
        }

    }


}