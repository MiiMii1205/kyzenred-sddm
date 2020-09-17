import QtQuick 2.2

import QtQuick.Layouts 1.1
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.4

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.kconfig 1.0

import SddmComponents 2.0

SMS {
    id: login_prompt_root

    property Item mainPasswordBox: passwordBox
    
    property bool showUsernamePrompt: !showUserList

    property string usernameFontColor
    property string lastUserName
    property bool loginScreenUiVisible: false
    property bool hidePasswordRevealIcon: config.hidePasswordRevealIcon == "false"

    property alias bottomTextMessage: passwordBox.bottomText

    property int visibleBoundary: mapFromItem(loginButton, 0, 0).y
    onHeightChanged: visibleBoundary = mapFromItem(loginButton, 0, 0).y + loginButton.height + units.smallSpacing

    signal loginRequest(string username, string password)

    onShowUsernamePromptChanged: {
        if (!showUsernamePrompt) {
            lastUserName = ""
        }
    }

    function startLogin() {
        var username = showUsernamePrompt ? userNameInput.text : userList.selectedUser
        var password = passwordBox.text

        action_layout.enabled = login_container.enabled = false

        loginButton.forceActiveFocus();
        loginRequest(username, password);
    }

    KyzenTextField {
        id: userNameInput
        Layout.fillWidth: true
        Layout.minimumHeight: 32
        implicitHeight: login_prompt_root.font.pointSize * 2.85 + (topPadding + bottomPadding)
        font: login_prompt_root.font
        text: lastUserName
        visible: showUsernamePrompt
        focus: showUsernamePrompt && !lastUserName
        placeholderText: i18nd("plasma_lookandfeel_org.kde.lookandfeel", "Username")
        Layout.bottomMargin:  units.largeSpacing

        onAccepted:
            if (login_root.uiVisible) {
                passwordBox.forceActiveFocus()
            }
        
    }

    RowLayout {
        Layout.minimumHeight: implicitHeight

            KyzenTextField {
            id: passwordBox

            Layout.fillWidth: true

            property bool showPassword: false
            property bool clearButtonShown: true
            property bool showPasswordButtonShown: hidePasswordRevealIcon
            readonly property bool __effectiveRevealPasswordButtonShown:  KAuthorized.authorize("lineedit_reveal_password")

            implicitHeight: login_prompt_root.font.pointSize * 2.85 + (topPadding + bottomPadding)
            font: login_prompt_root.font

            placeholderText: config.passwordFieldPlaceholderText == "Password" ? i18nd("plasma_lookandfeel_org.kde.lookandfeel", "Password") : config.passwordFieldPlaceholderText
            focus: !login_prompt_root.showUsernamePrompt || lastUserName
            echoMode: showPassword ? TextInput.Normal : TextInput.Password 

            // revealPasswordButtonShown: true
            onAccepted: {
                if (login_root.uiVisible) {
                    startLogin();
                }
            }

            passwordCharacter: root.kyzenPasswordFieldCharacter 
  
            Keys.onEscapePressed: {
                login_stack.currentItem.forceActiveFocus();
            }

            Keys.onPressed: {
                if (event.key == Qt.Key_Left && !text) {
                    user_list_view.decrementCurrentIndex();
                    event.accepted = true
                }
                if (event.key == Qt.Key_Right && !text) {
                    user_list_view.incrementCurrentIndex();
                    event.accepted = true
                }
            }

            Keys.onReleased: {
                if (!loginButton.enabled && length > 0) {
                    showPasswordButtton.enabled = loginButton.enabled = true
                }
                if (loginButton.enabled && length == 0) {
                    showPasswordButtton.enabled = loginButton.enabled = false
                }
            }

            Connections {
                target: sddm
                onLoginFailed: {
                    passwordBox.selectAll()
                    passwordBox.forceActiveFocus()
                }
            }

            controlOffsets: controlRow.width

            Row {
                id: controlRow
                height:parent.height

                anchors {
                    right: passwordBox.right
                    rightMargin: 0
                    verticalCenter: passwordBox.verticalCenter
                }

                KyzenFlatSvgButton {
                    id: showPasswordButtton
                    iconSvgPath: passwordBox.showPassword ? "m 4.3866495,4.3831424 -1.00976,0.082 -0.53711,0.63086 4.50195,3.82813 -4.5039,4.5038996 v 3 h 1.39062 l 1.39258,-1.39258 v -1.39059 l 3.34375,-3.34375 0.57031,0.48633 -2.16211,2.16211 3.4785205,3.47851 h 0.9707 l 1.99805,-1.99804 3.83203,3.25781 1.01172,-0.082 0.53515,-0.63086 z m 5.54493,1.95117 -0.39649,0.39649 2.6308605,2.23633 h 0.21289 l 1.19141,1.1933496 0.01,0.01 6.25782,5.31836 v -2.0625 l -7.0918,-7.0917996 z m 0.5410105,5.2499996 2.41016,2.04883 -1.27344,1.27149 h -0.54492 l -1.9570305,-1.95508 z m 9.36524,4.63867 -0.17383,0.20508 h 0.17383 z" : 
                        "M 9.931681,6.2910028 2.8378295,13.384854 v 3.000043 h 1.39064 l 1.3926,-1.3926 v -1.39064 L 10.298866,8.9238598 h 2.080109 l 4.673895,4.6758472 v 1.39259 l 1.392601,1.3926 h 1.392599 v -3.001993 l -7.0919,-7.0919012 z m 0.919933,3.134814 -3.47857,3.4805192 3.47857,3.478561 h 0.970713 l 3.478569,-3.478561 -3.478569,-3.4805192 z m 0.212893,1.5215022 h 0.544927 l 1.957057,1.959017 -1.957057,1.955109 H 11.064507 L 9.107449,12.906336 Z"
                    svgWidth: 22.676
                    svgHeight: 22.676
                    
                    onClicked: {
                        passwordBox.showPassword = !passwordBox.showPassword
                        passwordBox.forceActiveFocus()
                    }
                    enabled: passwordBox.enabled && passwordBox.showPasswordButtonShown && passwordBox.__effectiveRevealPasswordButtonShown && (passwordBox.showPassword || passwordBox.text.length > 0) 
                    
                    implicitHeight: passwordBox.height
                    implicitWidth: implicitHeight
                    // implicitHeight:parent.implicitHeight
                    // implicitWidth:parent.implicitHeight

                    opacity: enabled ? 1 : 0
                    visible: opacity > 0

                }

                KyzenFlatSvgButton {
                    id: clearButtton
                    iconSvgPath: "m 2.0023585,2.0001755 h 2.1083779 l 3.8892652,3.890512 3.8905114,-3.890512 h 2.107129 v 2.158377 l -3.864889,3.864877 3.864889,3.8648915 v 2.111503 H 11.84364 L 8.0000001,10.156187 4.1563635,13.999824 h -2.154005 l 3e-6,-2.111503 3.8648907,-3.8648915 -3.8648937,-3.818798 z"
                    svgWidth: 16.0
                    svgHeight: 16.0
                    font: login_prompt_root.font
                    
                    onClicked: {
                        passwordBox.text = ""; 
                        passwordBox.forceActiveFocus()
                    }
                    enabled: (passwordBox.text.length > 0 && passwordBox.clearButtonShown && passwordBox.enabled)
                    
                    implicitHeight: passwordBox.height
                    implicitWidth: implicitHeight

                    opacity: enabled ? 1 : 0

                    visible: opacity > 0

                }



            }

        }

        KyzenSvgButton {
            iconSvgPath: "M 12.2125,5.056375 7.1603698,2.6702881e-8 h -1.51012 L 4.9121498,0.73809603 8.1444998,3.970442 h -7.05857 L -1.9073486e-7,5.056375 1.0859298,6.142308 h 7.05857 l -3.23235,3.232345 0.7381,0.738097 h 1.51012 z"
            svgWidth: 12.213
            svgHeight: 10.113
            
            id: loginButton
            enabled: false
            Accessible.name: i18nd("plasma_lookandfeel_org.kde.lookandfeel", "Log In")
            // Layout.preferredWidth: height

            implicitHeight: passwordBox.height
            implicitWidth: implicitHeight
            onClicked: startLogin();
            font: login_prompt_root.font
        }

    }

}