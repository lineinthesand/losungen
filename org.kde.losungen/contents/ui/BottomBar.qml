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
import QtQuick.Dialogs
import org.kde.plasma.components


Rectangle {
    //height: previousDay.height+15
    implicitHeight: previousDay.height + 0.5 * marginFrame

    color: "#40ffffff"
    bottomLeftRadius: radiusFrame
    bottomRightRadius: radiusFrame
    //border.color: "#000"

    RowLayout {
        id: daySelector
        anchors.fill: parent
        //anchors.left: parent.left
        //anchors.right: parent.right
        //anchors.bottom: undefined
        //anchors.top: parent.top
        //anchors.topMargin: 10
    
        ToolButton {
            id: previousDay
            onClicked: losungenData.previous()
            icon.name: "arrow-left"
            Layout.leftMargin: marginFrame
        }
    
        /* go to today's Losung button */
        ToolButton {
            id: toToday
            onClicked: losungenData.today()
            icon.name: "go-jump-today"
            Layout.fillWidth: true
        }
    
        ToolButton {
            id: nextDay
            onClicked: losungenData.next()
            icon.name: "arrow-right"
        }
    
        ToolButton {
            id: info
            onClicked: infoDialog.open()
            icon.name: "dialog-information"
            Layout.rightMargin: marginFrame
        }
    
        MessageDialog {
           id: infoDialog
           text: "<h1>Die Losungen</h1>"
           informativeText: "<p>Losungstext: © Evangelische Brüder-Unität – Herrnhuter Brüdergemeine: <a href=\"www.herrnhuter.de\">www.herrnhuter.de</a><br />" +
                 "Weitere Informationen finden sie hier: <a href=\"www.losungen.de\">www.losungen.de</a></p>" +
                 "<p>Implementierung des Plasma 6 Widgets: Thomas Mitterfellner <a href=\"mailto:thomas.mitterfellner@gmail.com\">&lt;thomas.mitterfellner@gmail.com&gt;</a></p>"
        }
    }
}
