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
import QtQuick.Controls
import QtQml.XmlListModel
import org.kde.plasma.components
import org.kde.kirigami as Kirigami
import "../code/functions.js" as Fn


Rectangle {
    id: backdrop

    border.width: plasmoid.configuration.showWidgetBorder ? 1 : 0

    readonly property int radiusFrame: 0.6 * Kirigami.Units.gridUnit
    readonly property int marginFrame: 0.75 * Kirigami.Units.gridUnit

    gradient: Gradient {
        GradientStop { position: 0 ; color: plasmoid.configuration.backgroundColor1  }
        GradientStop { position: 1 ; color: plasmoid.configuration.backgroundColor2  }
    }
    radius: radiusFrame

    ColumnLayout {
        id: mainColumn
        spacing: 0

        anchors.fill: parent

        Label { 
            id: dateLabel 
            Layout.margins: marginFrame
            Layout.bottomMargin: 0
        }
        LosungDisplay { 
            id: losungsText 
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.margins: marginFrame
            Layout.bottomMargin: 0
        } 
        BottomBar { 
            id: bar 
            Layout.fillWidth: true
            visible: plasmoid.configuration.showDaySelector
        }

        LosungenData { id: losungenData }
        Connections {
            target: losungenData
            function onCurrentDayChanged() {
                mainColumn.setLosung(losungenData.currentDay)
            }

            function onStatusChanged() {
                if (   losungenData.status == XmlListModel.Ready 
                    && losungenData.count == 0) {
                    mainColumn.setLosung(-1)
                }
            }
        }
    
        /* Convert the date string from the xml file to a localized date string */
        function getLosungDate(dateString_raw) {
            var dateString = dateString_raw.slice(0,-9);
            var date = new Date(dateString)
            return date 
        }
    
        /* update the widget (text, date etc.) with the data from the current day's Losung */
        function setLosung(currentDay: int) {
    
            if (currentDay >= 0) {
               var losung_ = losungenData.get(currentDay);
                var text = Fn.formatLosung(losung_);
                var date = getLosungDate(losung_.date);
                dateLabel.text = date.toLocaleDateString(Locale, Locale.ShortFormat);
    
                losungsText.text = text;
            } 
            else {
                var year = new Date().getFullYear();
                var xmlZipFile = "Losung_" + year + "_XML.zip";
                var downloadUrl = "https://www.losungen.de/download/";
                var fileDownloadUrl = "https://www.losungen.de/fileadmin/media-losungen/download/";
                var dataFileLocation = "~/.local/share/plasma/plasmoids/org.kde.losungen/contents/data/";
                var message = qsTr(  "Data file \"%1\" not found. You can a get it from <a href=\"%2\">%2</a>. "
                                   + "Download the <a href=\"%3\">Losungen XML zip</a>, unzip the contained "
                                   + "xml file to the installation directory's data folder, e.g.: \"%4\".<br/>"
                                   + "Note that you might need to remove the widget and re-add it, or log "
                                   + "out and in again for the new file to be recognized.");
console.log("dataFileName"+ JSON.stringify(mainColumn.losungenData))
                losungsText.text = message.arg(losungenData.dataFileName).arg(downloadUrl).arg(fileDownloadUrl + xmlZipFile).arg(dataFileLocation);
            }
        }
    
        function getLosung(d) {
            var doy = Fn.getDOY(d);
            return losungenData.get(doy);
    
        }
    
    }
}
