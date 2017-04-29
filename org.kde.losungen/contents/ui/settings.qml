/*
 * This file is part of Sticky Notes.
 *
 * Sticky Notes is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Sticky Notes is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Sticky Notes. If not, see <http://www.gnu.org/licenses/>.
 *
 * Based on Sticky Notes plasmoid:
 * Copyright (C) Martino Pilia <martino.pilia@gmail.com>, 2015
 *
 * Modifications for Losungen plasmoid:
 * Copyright (C) Thomas Mitterfellner <thomas.mitterfellner@gmail.com>, 2017
 */

/* Content of plasmoid's settings dialog */
import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.2
import org.kde.plasma.components 2.0 as PlasmaComponents

Item {
    id: generalPage;

    width: childrenRect.width;
    height: childrenRect.height;

    property alias cfg_textColor: textColorDialog.color;
    property alias cfg_textFont: textFontDialog.font;
    property alias cfg_showDaySelector: showDaySelector.checked;

    ColumnLayout {
        /* text color */
        RowLayout {
            PlasmaComponents.Label {
                text: i18n("Text color") + ": ";
            }

            /* button to show/hide color picker */
            Button {
                onClicked: textColorDialog.visible = !textColorDialog.visible;

                text: "      "; // placeholder to give some size
                style: ButtonStyle {
                    background: Rectangle {
                        /* provide a sample of the current color */
                        color: cfg_textColor;
                    }
                }
            }

            /* color picker */
            ColorDialog {
                id: textColorDialog;

                title: i18n("Select text color");
                visible: false;
            }
        }

        /* text font */
        RowLayout {
            PlasmaComponents.Label {
                text: i18n("Font") + ": ";
            }

            /* button to show/hide font picker */
            Button {
                onClicked: textFontDialog.visible = !textFontDialog.visible;

                /* sample of the current font */
                style: ButtonStyle {
                    label: Label {
                        text: cfg_textFont.family + " "
                              + cfg_textFont.pointSize + "pt";
                        font: cfg_textFont;
                    }
                }
            }

            /* font picker */
            FontDialog {
                id: textFontDialog;

                title: i18n("Select font");
                visible: false;
            }
        }
        /* day selector check box */
        RowLayout {
            PlasmaComponents.CheckBox {
                id: showDaySelector
                checked: cfg_showDaySelector 
            }
            PlasmaComponents.Label {
                text: i18n("Show date selector");
            }

        }
    }
}
