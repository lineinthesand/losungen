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
import QtQuick.Layouts
import org.kde.plasma.components

/* Text area where the Losung is displayed */
Item {
    property alias text: losungsText.text
    
    ScrollView {
        anchors.fill: parent

        contentWidth: availableWidth
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
        
        TextArea {
            id: losungsText;
    
            leftPadding: 0
            // get font and text color from user settings
            font: plasmoid.configuration.textFont;
            color: plasmoid.configuration.textColor
    
            text: ""
            readOnly: true
            textFormat: Text.RichText
            wrapMode: Text.WordWrap
    
            background: Rectangle {
                color: "transparent"
            }

            onLinkActivated: Qt.openUrlExternally(link)
            HoverHandler {
                enabled: parent.hoveredLink
                cursorShape: Qt.PointingHandCursor
            }
        }
    }
}
