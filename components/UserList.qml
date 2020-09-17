import QtQuick 2.5

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras

ListView {
    id: view
    readonly property string selectedUser: currentItem ? currentItem.userName : ""
    readonly property real userItemWidth: inner_login_box.width/2 + inner_login_box.width/4 
    readonly property real userItemHeight: userbox.height

    property font font: root.kyzenFont
    activeFocusOnTab : true
    
    implicitHeight: userItemHeight

    displayMarginBeginning:userItemWidth/2
    displayMarginEnd:displayMarginBeginning
    
    anchors.centerIn: parent

    signal userSelected;

    orientation: ListView.Horizontal
    highlightRangeMode: ListView.StrictlyEnforceRange

    preferredHighlightBegin: width/2 - userItemWidth/2
    preferredHighlightEnd: preferredHighlightBegin

    delegate: UserDelegate {
        avatarPath: model.icon || ""

        name: {
            var displayName = model.realName || model.name

            if (model.vtNumber === undefined || model.vtNumber < 0) {
                return displayName
            }

            if (!model.session) {
                return i18ndc("plasma_lookandfeel_org.kde.lookandfeel", "Nobody logged in on that session", "Unused")
            }

            var location = ""
            if (model.isTty) {
                location = i18ndc("plasma_lookandfeel_org.kde.lookandfeel", "User logged in on console number", "TTY %1", model.vtNumber)
            } else if (model.displayNumber) {
                location = i18ndc("plasma_lookandfeel_org.kde.lookandfeel", "User logged in on console (X display number)", "on TTY %1 (Display %2)", model.vtNumber, model.displayNumber)
            }

            if (location) {
                return i18ndc("plasma_lookandfeel_org.kde.lookandfeel", "Username (location)", "%1 (%2)", displayName, location)
            }

            return displayName
        }

        userName: model.name
        backgroundId : model.name || "default"

        width: userItemWidth
        // height: parent.height
        height: userbox.height
        homeDir: model.homeDir

        //if we only have one delegate, we don't need to clip the text as it won't be overlapping with anything
        constrainText: ListView.view.count > 1

        isCurrent: ListView.isCurrentItem

        font: ListView.view.font

        onClicked: {
            ListView.view.currentIndex = index;
            ListView.view.userSelected();
        }
    }

    Keys.onEscapePressed: view.userSelected()
    Keys.onEnterPressed: view.userSelected()
    Keys.onReturnPressed: view.userSelected()

    ListModel {
        id: userBackgroundCache
    }
}