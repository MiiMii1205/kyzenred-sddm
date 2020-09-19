
import QtQuick 2.8

import QtQuick.Layouts 1.1
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0

import QtQuick.Shapes 1.5
import SddmComponents 2.0

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras

import "components"

PlasmaCore.ColorScope {
    id: root
    colorGroup: PlasmaCore.Theme.NormalColorGroup

    width: 1920
    height: 1080

    readonly property bool softwareRendering: GraphicsInfo.api === GraphicsInfo.Software
    LayoutMirroring.enabled: Qt.application.layoutDirection === Qt.RightToLeft

    property string notificationMessage
    
    property double shadowOpacity : 0.05
    property double baseAnimationTime :  config.baseAnimationSpeed || units.longDuration*2
    property double smallAnimationTime : config.baseAnimationSpeed * 0.75|| units.shortDuration

    property font kyzenFont
    
    kyzenFont.family: config.font || "Noto Sans" || theme.defaultFont.family 
    kyzenFont.pointSize: config.fontSize || 10 || theme.defaultFont.pointSize
    kyzenFont.bold: theme.defaultFont.bold
    kyzenFont.italic: theme.defaultFont.italic
    kyzenFont.underline: theme.defaultFont.underline
    kyzenFont.weight: theme.defaultFont.weight
    kyzenFont.overline: theme.defaultFont.overline
    kyzenFont.strikeout: theme.defaultFont.strikeout
    kyzenFont.capitalization: theme.defaultFont.capitalization
    kyzenFont.letterSpacing: theme.defaultFont.letterSpacing
    kyzenFont.wordSpacing: theme.defaultFont.wordSpacing
    kyzenFont.kerning: theme.defaultFont.kerning
    kyzenFont.preferShaping: theme.defaultFont.preferShaping
    kyzenFont.hintingPreference: theme.defaultFont.hintingPreference

    property color kyzenDefaultButtonHoverColor: "#942228" || theme.buttonHoverColor
    property color kyzenDefaultButtonFocusColor: "#c91e3c" || theme.buttonFocusColor
    property color kyzenDefaultButtonTextColor: "#e9f5f3" || theme.buttonTextColor
    property color kyzenDefaultButtonBackgroundColor: "#1c0408" || theme.buttonBackgroundColor
    property color kyzenDefaultBackgroundColor: "#031b16" || theme.backgroundColor
    property color kyzenDefaultHighlightColor: "#e51b42" || theme.highlightColor
    property color kyzenDefaultHighlightTextColor: "#001b16" || theme.highlightedTextColor
    property color kyzenDefaultTextColor: "#fae9e8" || theme.textColor
    property color kyzenDefaultViewBackgroundColor: "##010d0a" || theme.viewBackgroundColor

    property color kyzenButtonHoverColor: root.kyzenDefaultButtonHoverColor
    property color kyzenButtonFocusColor: root.kyzenDefaultButtonFocusColor
    property color kyzenButtonTextColor: root.kyzenDefaultButtonTextColor
    property color kyzenButtonBackgroundColor: root.kyzenDefaultButtonBackgroundColor
    property color kyzenBackgroundColor: root.kyzenDefaultBackgroundColor
    property color kyzenHighlightColor: root.kyzenDefaultHighlightColor
    property color kyzenHighlightTextColor: root.kyzenDefaultHighlightTextColor
    property color kyzenTextColor: root.kyzenDefaultTextColor
    property color kyzenViewBackgroundColor: root.kyzenDefaultViewBackgroundColor

    property color userBackgroundColor: theme.backgroundColor

    property string userBackgroundPath: "";
    property string kyzenPasswordFieldCharacter: config.passwordFieldCharacter == "" ? "◆" : config.passwordFieldCharacter

    property bool useBlur: config.blur === "true"
    property bool useBigClock: config.backgroundClock === "true"
    property bool useDefaultWallpaper: config.useDefaultWallpaper === "true"
    property string defaultWallpaper: config.background || ""

    PlasmaCore.DataSource {
        id: keystateSource
        engine: "keystate"
        connectedSources: "Caps Lock"
    }

    MouseArea {
        id: login_root
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
        anchors.fill: parent

        property bool uiVisible: true
        property bool blockUI: login_stack.depth > 1 || userListComponent.mainPasswordBox.text.length > 0 || config.type !== "image"
        // property bool blockUI: login_stack.depth > 1 || userListComponent.mainPasswordBox.text.length > 0 || inputPanel.keyboardActive || config.type !== "image"
        
        
        hoverEnabled: true
        drag.filterChildren: true
        onPressed: uiVisible = true;
        onPositionChanged: uiVisible = true;
        onUiVisibleChanged: {
            if (blockUI) {
                fadeoutTimer.running = false;
            } else if (uiVisible) {
                fadeoutTimer.restart();
            }
        }

        onBlockUIChanged: {
            if (blockUI) {
                fadeoutTimer.running = false;
                uiVisible = true;
            } else {
                fadeoutTimer.restart();
            }
        }

        Keys.onPressed: {
            uiVisible = true;
            event.accepted = false;
        }

        Timer {
            id: fadeoutTimer
            running: true
            interval: 60000
            onTriggered: {
                if (!login_root.blockUI) {
                    login_root.uiVisible = false;
                }
            }
        }

        Rectangle {
            id: background_container 
            color: root.kyzenBackgroundColor

            anchors.fill: parent

            KyzenColorFade on color {}

            Item {
                opacity: 0.5
                anchors.fill: parent

                visible: root.useDefaultWallpaper && defautlBackgroundImage.source !== ""

                Image {
                    id: defautlBackgroundImage
                    source: root.defaultWallpaper
                    fillMode: Image.PreserveAspectCrop
                    anchors.fill: parent
                    visible: root.softwareRendering || !root.useBlur
                    opacity: 1
                }

                FastBlur {
                    id: default_image_blur
                    anchors.fill: defautlBackgroundImage
                    source: defautlBackgroundImage
                    radius: 64
                    visible: !root.softwareRendering && root.useBlur
                    KyzenPropertyFade on radius {}
                }

            }
         

            Rectangle {
                anchors.fill: parent
                color: root.kyzenBackgroundColor
                opacity: login_stack.userPromptComponentActive ? 0 : 1

                KyzenPropertyFade on opacity {}

                KyzenColorFade on color {}

                Item {
                    id: loginBackgroundList
                    // color: root.kyzenBackgroundColor
                    anchors.fill: parent
                    opacity: 0.5

                    property string users: ""
                }

            }
        
        }

        Item {


            state: login_root.uiVisible ? "on" : "off"

            states: [
                State {
                    name: "on"
                    PropertyChanges {
                        target: loginScreen
                        opacity: 1
                    }
                  
                },
                State {
                    name: "off"
                    PropertyChanges {
                        target: loginScreen
                        opacity: 0
                    }                    
                  
                }
            ]

            transitions: [
                Transition {
                    from: "off"
                    to: "on"
                    //Note: can't use animators as they don't play well with parallelanimations
                    NumberAnimation {
                        targets: [loginScreen]
                        property: "opacity"
                        duration: units.longDuration
                        easing.type: Easing.InOutQuad
                    }
                },
                Transition {
                    from: "on"
                    to: "off"
                    NumberAnimation {
                        targets: [loginScreen ]
                        property: "opacity"
                        duration: 500
                        easing.type: Easing.InOutQuad
                    }
                }
            ]


        }
   


        PlasmaCore.ColorScope {
            id: loginScreen
            colorGroup: PlasmaCore.Theme.ButtonColorGroup
            anchors.rightMargin: 0
            anchors.bottomMargin: 0
            anchors.leftMargin: 0
            anchors.topMargin: 0
            anchors.fill: parent
            opacity: 1
            transformOrigin: Item.Center


            // We simply make a simple element

            Item  {
                anchors.fill: parent

                layer.enabled: true
                layer.samples: 12

                clip:true
                
                opacity: root.shadowOpacity*4

                KyzenBackClock {
                    id:backClock
                    basePointSize:884
                    visible: !backClockShadow.visible && root.useBigClock
                    font: root.kyzenFont
                    opacity:1
                }

                DropShadow {
                    id: backClockShadow
                    anchors.fill: backClock
                    source: backClock
                    visible: !root.softwareRendering && root.useBigClock
                    horizontalOffset: 0
                    verticalOffset: loginScreen.height * ( (backClock.basePointSize * 1.333) * 8 / 64) / 1080
                    radius: 3
                    samples: 14
                    spread: 0
                    color:Qt.rgba(0, 0, 0, root.shadowOpacity)  // black matches Breeze window decoration and desktopcontainment
                    KyzenPropertyFade on opacity {}
                    
                }

                layer.effect: FastBlur {
                    id: blur
                    anchors.fill: parent
                    radius: 32
                    visible: !root.softwareRendering && root.useBlur
                    KyzenPropertyFade on radius {}
                }    

            }


            Item {
                id: login_container

                property real calculatedWidth: root.height/3
                property real calculatedHeight: calculatedWidth * 1.618033988749895
                property real kyzenBracketMargin: (calculatedWidth * 55.704) / 384
                property real heightWeight: 0
                property real pointHeight : (height*1/0.75)

                opacity: (login_container.enabled ? 1 : 0.5)
                KyzenPropertyFade on opacity {}

                anchors {
                    // margins: parent.kyzenBracketMargin
                    verticalCenter: parent.verticalCenter
                    left:parent.left
                    right:parent.right
                }

                // KyzenPropertyFade on height {}

                clip: true

                // Golden ratio
                height: calculatedHeight * heightWeight

                

                // Item{
                //     id:  login_backdrop
                //     width: parent.width
                //     height: parent.height 

                //     anchors.centerIn: parent
                // }

                Item {
                    id: inner_login_box
                    width: parent.calculatedWidth

                    anchors {
                        // margins: parent.kyzenBracketMargin
                        horizontalCenter: parent.horizontalCenter
                        top:login_container.top
                        bottom:login_container.bottom
                    }

                    DropShadow {
                        id: backdrop_frame_shadow
                        anchors.fill: backdrop_frame
                        source: backdrop_frame
                        visible: !softwareRendering
                        verticalOffset: 0
                        radius: 6
                        samples: 14
                        opacity:1
                        spread: 0
                        color: Qt.rgba(0, 0, 0, root.shadowOpacity) // matches Breeze window decoration and desktopcontainment
                        KyzenPropertyFade on opacity {}
                    }

                    KyzenBorderedFrame {
                        id:backdrop_frame
                        visible: !backdrop_frame_shadow.visible 
                  
                
                        anchors.fill: inner_login_box

                        // frameColor: root.kyzenViewBackgroundColor
                        buttonBackdropColor: "transparent"
                        buttonBackgroundColor:applyBackColor(root.kyzenViewBackgroundColor)
                        buttonBorderColor:root.kyzenButtonHoverColor 
                        flatButtonBackgoundOpacity:1
                    }

                    DropShadow {
                        id: top_right_bracket_shadow
                        anchors.fill: top_right_bracket
                        source: top_right_bracket
                        visible: !softwareRendering
                        verticalOffset: 6
                        radius: 6
                        transformOrigin: top_right_bracket.transformOrigin
                        scale:top_right_bracket.scale
                        samples: 14
                        spread: 0.3
                        color: Qt.rgba(0, 0, 0, root.shadowOpacity) // matches Breeze window decoration and desktopcontainment
                        KyzenPropertyFade on opacity {}
                    }

                    Shape {
                        id:top_right_bracket
                        width:384
                        height:384
                        visible: !top_right_bracket_shadow.visible

                        scale:((parent.width - login_container.kyzenBracketMargin) / width)
                        transformOrigin: Item.Top

                        anchors.topMargin: login_container.kyzenBracketMargin/2
                        anchors.top:parent.top
                        anchors.horizontalCenter:parent.horizontalCenter

                        ShapePath {
                            fillColor: root.kyzenButtonFocusColor
                            strokeWidth:-1
                            startX: 128; startY: 128

                            PathSvg  {
                                path: "m328.34 136.31 55.69 55.676 0.01438-191.97-192 5.9079e-4 55.755 55.755h80.542z"
                            }

                            KyzenColorFade on fillColor {}

                        }

                    } 

                    StackView {
                        id: login_stack

                        anchors.rightMargin: login_container.kyzenBracketMargin + (login_container.kyzenBracketMargin/2)
                        anchors.bottomMargin: login_container.kyzenBracketMargin+ (login_container.kyzenBracketMargin/2)
                        anchors.leftMargin: login_container.kyzenBracketMargin+ (login_container.kyzenBracketMargin/2)
                        anchors.topMargin: login_container.kyzenBracketMargin+ (login_container.kyzenBracketMargin/2)
                        
                        focus: true

                        anchors.fill: parent

                        clip:false

                        property bool userPromptComponentActive: false
                        onUserPromptComponentActiveChanged: {
                            if(!userPromptComponentActive) {
                                userListComponent.currentUser.refreshUser()
                            } 
                        }

                        initialItem : LoginPrompt {
                            id: userListComponent
                            userListModel: userModel
                            font: root.kyzenFont
                            
                            bottomTextMessage: {
                                var text = ""
                                if (keystateSource.data["Caps Lock"]["Locked"]) {
                                    text += i18nd("plasma_lookandfeel_org.kde.lookandfeel","Caps Lock is on")
                                }
                                return text
                            } 
                            
                            notificationMessage: {
                                var text = ""
                                text += root.notificationMessage
                                return text
                            }

                            onLoginRequest: {
                                root.notificationMessage = ""
                                sddm.login(username, password, currentSession)
                            }
                        }


                        pushEnter: Transition {
                            PropertyAnimation {
                                property: "opacity"
                                from: 0
                                to:1
                                duration: root.baseAnimationTime
                            }
                        }
                        pushExit: Transition {
                            PropertyAnimation {
                                property: "opacity"
                                from: 1
                                to:0
                                duration: root.baseAnimationTime
                            }
                        }
                        popEnter: Transition {
                            PropertyAnimation {
                                property: "opacity"
                                from: 0
                                to:1
                                duration: root.baseAnimationTime
                            }
                        }
                        popExit: Transition {

                            PropertyAnimation {
                                property: "opacity"
                                from: 1
                                to:0
                                duration: root.baseAnimationTime
                            }
                        }
                    }

                    DropShadow {
                        id: bottom_left_bracket_shadow
                        anchors.fill: bottom_left_bracket
                        source: bottom_left_bracket
                        visible: top_right_bracket_shadow.visible
                        horizontalOffset: top_right_bracket_shadow.horizontalOffset
                        verticalOffset: top_right_bracket_shadow.verticalOffset
                        transformOrigin: bottom_left_bracket.transformOrigin
                        scale:bottom_left_bracket.scale
                        radius: top_right_bracket_shadow.radius
                        samples: top_right_bracket_shadow.samples
                        spread: top_right_bracket_shadow.spread
                        opacity: top_right_bracket_shadow.opacity
                        color: top_right_bracket_shadow.color
                        KyzenPropertyFade on opacity {}
                    }

                    Shape {
                        id:bottom_left_bracket
                        width:384
                        height:384

                        scale:((parent.width - login_container.kyzenBracketMargin) / width)

                        anchors.horizontalCenter:parent.horizontalCenter
                        anchors.bottom:parent.bottom
                        anchors.bottomMargin: login_container.kyzenBracketMargin/2
                        transformOrigin: Item.Bottom
                        visible: !bottom_left_bracket_shadow.visible

                        ShapePath {
                            fillColor: root.kyzenButtonFocusColor
                            strokeWidth:-1
                            startX: 128; startY: 128

                            PathSvg  {
                                path: "M 55.704209,247.70278 0.01438,192.02673 0,384 192.00084,383.99941 136.24602,328.24459 H 55.703619 Z"
                            }

                            KyzenColorFade on fillColor {}

                        }

                    }

                }

                Loader {
                    id: login_input_panel
                    state: "hidden"
                    property bool isActive: item ? item.active : false
                    onIsActiveChanged: { state= isActive ? "visible" : "hidden" }
                    source: "components/KyzenVirtualKeyboard.qml"

                    anchors{
                        left: parent.left
                        right: parent.right
                    }

                    function toggle() {
                        state = state == "hidden" ? "visible" : "hidden" 
                    }

                    states: [
                        State {
                            name: "visible"
                            PropertyChanges { 
                                target: login_stack
                                y: Math.min(0, root.height - login_input_panel.height - userListComponent.visibleBoundary)
                            }
                            PropertyChanges { 
                                target: login_input_panel
                                y: root.height - login_input_panel.height
                            opacity: 1
                            }
                        },   
                         State {
                            name: "hidden"
                            PropertyChanges { 
                                target: login_stack
                                y: 0
                            }
                            PropertyChanges { 
                                target: login_input_panel
                                y: root.height - root.height/4
                                opacity: 0
                            }
                        }
                    ]

                    transitions: [
                        Transition {
                            from: "hidden"
                            to: "visible"
                            SequentialAnimation {
                                ScriptAction {
                                    script: {
                                        login_input_panel.item.activated = true;
                                        Qt.inputMethod.show();
                                    }
                                }
                                ParallelAnimation {
                                    NumberAnimation {
                                        target: login_stack
                                        property: "y"
                                        duration: root.baseAnimationTime
                                        easing.type: Easing.InOutCirc
                                    }
                                    NumberAnimation {
                                        target: login_input_panel
                                        property: "y"
                                        duration: root.baseAnimationTime
                                        easing.type: Easing.OutCirc
                                    }
                                    OpacityAnimator {
                                        target: login_input_panel
                                        duration: root.baseAnimationTime
                                        easing.type: Easing.OutCirc
                                    }
                                }
                            }
                        },
                        Transition {
                            from: "visible"
                            to: "hidden"
                            SequentialAnimation {
                                ParallelAnimation {
                                    NumberAnimation {
                                        target: login_stack
                                        property: "y"
                                        duration: root.baseAnimationTime
                                        easing.type: Easing.InOutCirc
                                    }
                                    NumberAnimation {
                                        target: login_input_panel
                                        property: "y"
                                        duration: root.baseAnimationTime
                                        easing.type: Easing.InCirc
                                    }
                                    OpacityAnimator {
                                        target: login_input_panel
                                        duration: root.baseAnimationTime
                                        easing.type: Easing.InCirc
                                    }
                                }
                                ScriptAction {
                                    script: {
                                        Qt.inputMethod.hide();
                                    }
                                }
                            }
                        }
                    ]
                }

                Component {
                    id: userPromptComponent
                    LoginPrompt {
                        showUsernamePrompt: true

                        font: root.kyzenFont

                        bottomTextMessage: {
                            var text = ""
                            if (keystateSource.data["Caps Lock"]["Locked"]) {
                                text += i18nd("plasma_lookandfeel_org.kde.lookandfeel","Caps Lock is on")
                            }
                            return text
                        } 

                        notificationMessage: {
                            var text = ""
                            text += root.notificationMessage
                            return text
                        }

                        // using a model rather than a QObject list to avoid QTBUG-75900
                        userListModel: ListModel {
                            ListElement {
                                name: ""
                                iconSource: ""
                                homeDir:""
                            }
                            Component.onCompleted: {
                                // as we can't bind inside ListElement
                                setProperty(0, "name", i18nd("plasma_lookandfeel_org.kde.lookandfeel", "Type in Username and Password"));
                            }
                        }

                        onLoginRequest: {
                            root.notificationMessage = ""
                            sddm.login(username, password, currentSession)
                        }
                    }
                }

            }

            

              RowLayout {
                    id: action_layout
                    // width:login_container.calculatedWidth
                    spacing: login_container.kyzenBracketMargin/2
                    anchors{
                        top: login_container.bottom
                        horizontalCenter: login_container.horizontalCenter
                        topMargin: spacing * 2
                        alignWhenCentered:true
                    }
                    KyzenActionButton {
                        iconSvgPath: "M 14.01954,-3.8299561e-7 H 18.6875 V 2.0702996 l -2.83789,2.8379 h 2.83789 v 1.0722 l -0.92773,0.9278 H 13.0918 v -2.0703 l 2.83789,-2.8379 H 13.0918 V 0.92769962 Z M 0.92773,3.2733996 h 4.66798 v 2.0703 l -2.8379,2.8379 h 2.8379 v 1.0723 L 4.66797,10.1816 H 0 V 8.1112996 l 2.83789,-2.8379 H 0 v -1.0723 z M 10.7461,11.455 h 4.66797 v 2.0704 l -2.83789,2.8378 h 2.83789 v 1.0723 l -0.92774,0.9277 H 9.81836 V 16.2929 L 12.65625,13.455 H 9.81836 v -1.0722 z"
                        svgWidth:18.688
                        svgHeight:18.363
                        font: root.kyzenFont
                 
                        onClicked: sddm.suspend()
                        enabled: sddm.canSuspend
                        implicitWidth: implicitHeight

                        KyzenToolTip {
                            text: i18ndc("plasma_lookandfeel_org.kde.lookandfeel","Suspend to RAM","Sleep")
                        }
                    }
                       
                    KyzenActionButton {
                        iconSvgPath: "m 7.90039,-4.4e-7 3.9414,3.93749994 1.51953,-1.5195 h 1.40235 v 5.2968 H 9.75 v -1.6855 l 1.09179,-1.0898 -2.9414,-2.9395 -6.14453,6.1445 V 9.8535004 L 7.90039,16 12.33398,11.5664 h 2.00195 L 7.90039,18 -1.6174317e-8,10.0977 V 7.9003995 Z"
                        svgWidth:14.764
                        svgHeight:18
                        onClicked: sddm.reboot()
                        enabled: sddm.canReboot
                        implicitWidth: implicitHeight
                        font: root.kyzenFont

                        KyzenToolTip {
                            text: i18nd("plasma_lookandfeel_org.kde.lookandfeel","Restart")
                        }
                    }
                    KyzenActionButton {
                        iconSvgPath: "M 7.9023441,-3.6044383e-7 15.800782,7.9003996 V 10.1016 L 7.9003909,18 -1.2463013e-7,10.0996 V 7.9022996 Z m 0,1.99999996044383 -6.1464842,6.1465 v 1.709 L 7.9003909,16 14.044922,9.8573996 v -1.7129 z m -0.07422,3 H 8.90039 V 12.0723 L 7.972656,13 H 6.900391 V 5.9276996 Z"

                        svgWidth:15.801
                        svgHeight:18
                        onClicked: sddm.powerOff()
                        enabled: sddm.canPowerOff
                        implicitWidth: implicitHeight
                        font: root.kyzenFont

                        KyzenToolTip {
                            text: i18nd("plasma_lookandfeel_org.kde.lookandfeel","Shut Down")
                        }
                    }
                    KyzenActionButton {
                        iconSvgPath:login_stack.userPromptComponentActive ? 
                        "M 0.92773,-1e-7 H 9 v 1.072266 L 8.07226,2.0000001 H 0 V 0.9277339 Z m 0,3.0000002 H 9 v 1.072266 L 8.07226,5.0000001 H 0 v -1.072266 z m 0,3 H 9 v 1.072266 L 8.07226,8.0000001 H 0 v -1.072266 z" :
                        "M 10.53125,0 0,10.53125 v 2.9375 L 10.53125,24 21.0625,13.46875 v -2.9375 z m 0,5 2.63281,2.63281 V 8.36718 L 10.53125,11 7.89844,8.36718 V 7.63281 Z m 0,8 4.86523,2.13476 L 10.53125,20 5.66601,15.13476 Z" 
                        // "M 3.11718,1.9066575e-7 H 4.1875 V 14.000001 h 1.37695 l 0.8105497,0.8125 L 3.1875,18.000001 0,14.812501 l 0.8125,-0.8125 h 1.375 L 2.1895,0.92770019 Z m 7.44532,0 L 13.75,3.1874999 l -0.81055,0.8125 H 11.5625 V 17.072301 l -0.92774,0.9277 H 9.5624997 V 3.9999999 h -1.375 l -0.8125,-0.8125 z"
                        svgWidth:  login_stack.userPromptComponentActive ?  9 : 21.062
                        svgHeight: login_stack.userPromptComponentActive ? 8 : 24
                        font: root.kyzenFont
                        onClicked: {
                            if(login_stack.userPromptComponentActive) {
                                login_stack.pop()
                                login_stack.userPromptComponentActive = false
                            } else {
                                login_stack.push(userPromptComponent)
                                login_stack.userPromptComponentActive = true
                                }
                            }

                        KyzenToolTip {
                            text:  login_stack.userPromptComponentActive ? i18nd("plasma_lookandfeel_org.kde.lookandfeel","List Users") : i18ndc("plasma_lookandfeel_org.kde.lookandfeel", "For switching to a username and password prompt", "Other...")
                        }
                        enabled: true
                        implicitWidth: implicitHeight
                    }
                }
        
        }

    }
    SequentialAnimation {

        ParallelAnimation {
            NumberAnimation {
            property: "heightWeight"
            target: login_container
            from:0
            to: 1
            duration: root.baseAnimationTime
            easing.type: Easing.InOutQuint
            easing.overshoot: 0
        }
            NumberAnimation {
                property: "opacity"
                target: loginScreen
                from:0
                to: 1
                duration: root.baseAnimationTime
                easing.type: Easing.InOutQuint
                easing.overshoot: 0
            }
        }
        

        running: true
    }

    SequentialAnimation {
        id: close_greeter
        ParallelAnimation {
            NumberAnimation {
            property: "heightWeight"
            target: login_container
            from:1
            to: 0
            duration: root.baseAnimationTime
            easing.type: Easing.InOutQuint
            easing.overshoot: 0
        }
            NumberAnimation {
                property: "opacity"
                target: loginScreen
                from:1
                to: 0
                duration: root.baseAnimationTime
                easing.type: Easing.InOutQuint
                easing.overshoot: 0
            }
        }
        

        running: false
    }


    Connections {
        target: sddm
        onLoginFailed: {
            notificationMessage = i18nd("plasma_lookandfeel_org.kde.lookandfeel", "Login Failed")
            login_container.enabled = action_layout.enabled = true
        }
        onLoginSucceeded: {
            //note SDDM will kill the greeter at some random point after this
            //there is no certainty any transition will finish, it depends on the time it
            //takes to complete the init
            close_greeter.running = true
        }
    }
    

    onNotificationMessageChanged: {
        if (notificationMessage) {
            notificationResetTimer.start();
        }
    }

    Timer {
        id: notificationResetTimer
        interval: 3000
        onTriggered: notificationMessage = ""
    }
    

}

