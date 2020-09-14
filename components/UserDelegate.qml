import QtQuick 2.5
import QtQuick.Shapes 1.5
import QtGraphicalEffects 1.0

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras

import "../assets/kdefetchconfig.js" as Utils

Item {
    id: wrapper

    property bool isCurrent: true

    readonly property var m: model
    property string name
    property string userName
    property string avatarPath
    property string backgroundId
    property string homeDir
    property bool constrainText: true
    property alias nameFontSize: usernameDelegate.font.pointSize
    property int fontSize: config.fontSize
    signal clicked()

    property real faceSize: (login_container.calculatedWidth * 128) / 480

    opacity: isCurrent ? 1.0 : 0.5

    KyzenPropertyFade on opacity {}

    // Behavior on isCurrent {
    //     SequentialAnimation{

    //         PropertyAction{}

    //         ScriptAction {
    //             script:  Utils.updateCurrentUserState()
    //         }
    //     }
    // }

    onIsCurrentChanged: Utils.updateCurrentUserState()

    
    Item {
        id: imageSource
        layer.enabled: true
        layer.samples: 12

        KyzenBorderedFrame {
            anchors.centerIn: parent
            width: parent.width // Subtract to prevent fringing
            height:  width 
            visible: !(face.status == Image.Error || face.status == Image.Null)
        }

        anchors {
            top: parent.top
            bottomMargin: units.largeSpacing
            topMargin: isCurrent ? 0 : units.largeSpacing  
            horizontalCenter: parent.horizontalCenter
        }

        width: isCurrent ? faceSize : faceSize - units.largeSpacing
        height: width

        Item {
            id: user_profile_face
            anchors.fill: parent
            visible: root.softwareRendering
            layer.samples: 12
            layer.enabled: true

            KyzenFrame {
                id: mask_frame
                anchors.fill: parent
                anchors.margins: 2
                frameColor: "black"
                visible: false
            }

            layer.effect:OpacityMask {
                anchors.fill: parent
                source: user_profile_face
                maskSource: mask_frame
                visible: !root.softwareRendering
            }
            

            Image {
                id: face
                source: wrapper.avatarPath
                sourceSize: Qt.size(faceSize, faceSize)
                fillMode: Image.PreserveAspectCrop
                anchors.fill: parent
                anchors.margins: 2
            }

            Item {

                id: faceIcon

                anchors.fill: parent
                anchors.margins: units.gridUnit * 0.5 // because mockup says so...
                visible: (face.status == Image.Error || face.status == Image.Null)

                Shape {
                    id: icon
                    width: 21.062
                    height: 24.000

                    transformOrigin: Item.Center
                    anchors.centerIn:parent
                
                    scale: width > height ? ((parent.width) / width) : ((parent.height) / height)

                    ShapePath {
                        id: icon_path
                        fillColor: root.kyzenHighlightColor
                        strokeWidth: -1
                        startX: 128; startY: 128
                        PathSvg {
                            path: "M 10.531249,-1.3897705e-7 2.05e-7,10.531251 V 13.46875 L 10.531249,24.000006 21.0625,13.468751 v -2.937499 z m 0,5.00000003897705 2.632813,2.632812 v 0.734375 L 10.531249,11.000002 7.8984372,8.3671869 v -0.734375 z m 0,8.0000011 4.865235,2.134765 -4.865235,4.86524 -4.8652338,-4.86524 z"
                        }
                    }
                }

            }

        }

    }

    PlasmaComponents.Label {
        id: usernameDelegate
        font.pointSize: Math.max(fontSize + 2,theme.defaultFont.pointSize + 2)
        // anchors.centerIn: parent

        anchors.top: imageSource.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        //  anchors.topMargin: faceSize + units.largeSpacing + login_tile.height + notificationsLabel.height

        height: implicitHeight // work around stupid bug in Plasma Components that sets the height
        width: parent.width
        text: wrapper.name
        color: wrapper.activeFocus ? root.kyzenButtonFocusColor : root.kyzenTextColor
        style: Text.Normal
        styleColor: PlasmaCore.ColorScope.backgroundColor //no outline, doesn't matter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignHCenter
        KyzenColorFade on color {}
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onClicked: wrapper.clicked();
    }

    Accessible.name: name
    Accessible.role: Accessible.Button
    property var userBackground: null

    Component.onCompleted: Utils.loadUsersWallpaper();

    function accessiblePressAction() { wrapper.clicked() }
    function refreshUser() { Utils.updateCurrentUserState() }

}