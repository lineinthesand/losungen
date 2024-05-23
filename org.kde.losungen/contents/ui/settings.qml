/*
 * Copyright (C) Thomas Mitterfellner <thomas.mitterfellner@gmail.com>, 2024
 *
 * This file is part of the Plasma 6 widget "Die Losungen".
 * "Die Losungen" is free software: you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation, either version 3 of the License, or (at your option)
 * any later version.
 *
 * "Die Losungen" is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
 * or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along with
 * "Die Losungen". If not, see <https://www.gnu.org/licenses/>.
 */

import QtQuick
import QtQuick.Dialogs
import org.kde.kirigami as Kirigami
import org.kde.kcmutils as KCM
import QtQuick.Controls
import QtQuick.Layouts


KCM.SimpleKCM {
    property alias cfg_textColor: textColorDialog.selectedColor
    property alias cfg_backgroundColor1: backgroundColor1Dialog.selectedColor
    property alias cfg_backgroundColor2: backgroundColor2Dialog.selectedColor
    property alias cfg_textFont: textFontDialog.selectedFont;
    property alias cfg_bibleServerURL: bibleServerURL.text;
    property alias cfg_showDaySelector: showDaySelector.checked;
    property alias cfg_showWidgetBorder: showWidgetBorder.checked;


    Kirigami.FormLayout {
        id: appearance

        Kirigami.Separator {
            Kirigami.FormData.label: qsTr("Style")
            Kirigami.FormData.isSection: true
        }

        /* button to show/hide color picker */
        Button {
            id: textColor

            Kirigami.FormData.label: qsTr("Text color") + ": "
            onClicked: textColorDialog.open()

            background: Rectangle {
                implicitHeight: Kirigami.Units.gridUnit
                implicitWidth: Kirigami.Units.gridUnit
                /* provide a sample of the current color */
                color: cfg_textColor;
                border.width: 1;
            }
        }

        /* button to show/hide color picker */
        Button {
            id: backgroundColor1

            Kirigami.FormData.label: ("Background color 1") + ": "
            onClicked: backgroundColor1Dialog.open()

            background: Rectangle {
                implicitHeight: Kirigami.Units.gridUnit
                implicitWidth: Kirigami.Units.gridUnit
                /* provide a sample of the current color */
                color: cfg_backgroundColor1;
                border.width: 1;
            }
        }

        /* button to show/hide color picker */
        Button {
            id: backgroundColor2

            Kirigami.FormData.label: qsTr("Background color 2") + ": "
            onClicked: backgroundColor2Dialog.open()

            background: Rectangle {
                implicitHeight: Kirigami.Units.gridUnit
                implicitWidth: Kirigami.Units.gridUnit
                /* provide a sample of the current color */
                color: cfg_backgroundColor2;
                border.width: 1;
            }
        }

        /* button to show/hide font picker */
        Button {
            id: textFont

            Kirigami.FormData.label: qsTr("Font") + ": "
            onClicked: textFontDialog.open()

            /* sample of the current font */
            text: cfg_textFont.family + " "
                + cfg_textFont.pointSize + "pt";
            font: cfg_textFont;
        }

        /* color/font pickers */
        ColorDialog {
            id: textColorDialog;

            title: qsTr("Select text color")
            selectedColor: cfg_textColor
        }

        ColorDialog {
            id: backgroundColor1Dialog;

            title: qsTr("Select background color 1");
        }

        ColorDialog {
            id: backgroundColor2Dialog;

            title: qsTr("Select background color 2");
        }

        FontDialog {
            id: textFontDialog;

            title: qsTr("Select font");
            visible: false;
        }

        Kirigami.Separator {
            Kirigami.FormData.label: "Miscellaneous"
            Kirigami.FormData.isSection: true
        }

        Row {
            spacing: 5
            Kirigami.FormData.label: qsTr("Bibleserver search URL") + ": "
            TextField {
                id: bibleServerURL

                implicitWidth: parent.width * 0.79;

                color: Kirigami.Theme.textColor;
                background: Rectangle {
                    border.width: 1
                }
            }
            Button {
                anchors.verticalCenter: bibleServerURL.verticalCenter
                text: qsTr("Reset")
                onClicked: bibleServerURL.text = plasmoid.configuration.bibleServerURL;
            }
        }

        /* day selector check box */
        CheckBox {
            id: showDaySelector
            Kirigami.FormData.label: qsTr("Show date selector")
            checked: cfg_showDaySelector 
        }

        /* day selector check box */
        CheckBox {
            id: showWidgetBorder
            Kirigami.FormData.label: qsTr("Show widget border")
            checked: cfg_showWidgetBorder 
        }
    }
}

