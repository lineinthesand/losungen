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

import QtQuick 2.0
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.1
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.4
import QtQuick.XmlListModel 2.0 
import QtQuick.Window 2.2
import "../code/functions.js" as Fn

Rectangle {
    id: root;
        anchors {
            fill: parent
		}
    Layout.minimumWidth: units.iconSizes.medium
    Layout.minimumHeight: units.iconSizes.medium
    Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground
    gradient: Gradient {
        GradientStop { position: 0 ; color: plasmoid.configuration.backgroundColor1  }
        GradientStop { position: 1 ; color: plasmoid.configuration.backgroundColor2  }
    }

    // default size
    width: 250;
    height: 300;

    ColumnLayout {
        id: column
        anchors {
            fill: parent
            leftMargin: 5
            rightMargin: 5
            topMargin: 5
            bottomMargin: 5
        }

        //spacing: units.gridUnit
        Label {
            id: dateLabel
        }

        /* Losung text area */
        TextArea {
            id: losungsText;

            Layout.fillHeight: true
            Layout.fillWidth: true

            // get font and text color from user settings
            font: plasmoid.configuration.textFont;
            textColor: plasmoid.configuration.textColor;

            text: ""
            backgroundVisible: false; // no background above the image

            readOnly: true
            textFormat: Text.RichText
            wrapMode: Text.WordWrap

            // hide scrollbar if the plasmoid is not focused on creation
            verticalScrollBarPolicy:
                (activeFocus ? Qt.ScrollBarAsNeeded : Qt.ScrollBarAlwaysOff);

            onLinkActivated: Qt.openUrlExternally(link)
        }
        /* day selector */
        ToolBar {
            id: daySelector
            visible: plasmoid.configuration.showDaySelector;
            Layout.fillWidth: true
            Layout.minimumWidth: 100
            RowLayout {
                anchors.fill: parent
 
                /* go to previous day's Losung button */
                PlasmaComponents.ToolButton {
                    id: previousDay
                    onClicked: losungen.previous()
                    iconSource: "arrow-left"
                    //text: " ◂ ";
                    //anchors { left: parent.left }
                    //Layout.alignment: Qt.AlignLeft
                }
                /* go to today's Losung button */
                PlasmaComponents.ToolButton {
                    onClicked: losungen.today()
                    iconSource: "go-jump-today"
                    anchors { right: nextDay.left }
                    anchors { left: previousDay.right }
                    Layout.alignment: Qt.AlignCenter
                }
                /* go to next day's Losung button */
                PlasmaComponents.ToolButton {
                    id: nextDay
                    onClicked: losungen.next()
                    iconSource: "arrow-right"
                    anchors { right: info.left }
                }
                PlasmaComponents.ToolButton {
                    id: info
                    onClicked: popup.visible = true
                    iconSource: "dialog-information"
                    Layout.alignment: Qt.AlignRight
                }
            }
        }

    }

    MessageDialog {
       id: popup
       text: "<p>Losungstext: © Evangelische Brüder-Unität – Herrnhuter Brüdergemeine: <a href=\"www.herrnhuter.de\">www.herrnhuter.de</a><br />" +
             "Weitere Informationen finden sie hier: <a href=\"www.losungen.de\">www.losungen.de</a></p>" +
             "<p>Implementierung des Plasma 5 Widgets: Thomas Mitterfellner <a href=\"mailto:thomas.mitterfellner@gmail.com\">&lt;thomas.mitterfellner@gmail.com&gt;</a></p>"
    }

    /* initialize the plasmoid with the current day's Losung */
    function init() {
        var conf = plasmoid.configuration;
        if (conf.backgroundColor1 == "") conf.backgroundColor1 = theme.backgroundColor;
        if (conf.backgroundColor2 == "") conf.backgroundColor2 = theme.backgroundColor;
        if (conf.textFont == "") conf.textFont = theme.defaultFont;
        if (conf.textColor == "") conf.textColor = theme.textColor;
        losungen.today();
    }

    /* Convert the date string from the xml file to a localized date string */
    function getLosungDate(dateString_raw) {
        var dateString = dateString_raw.slice(0,-9);
        var date = new Date(dateString)
        return date 
    }

    /* update the widget (text, date etc.) with the data from the current day's Losung */
    function setLosung() {
        var losung_ = losungen.get(losungen.currentDay);
        if (typeof(losung_) != 'undefined') {
            var text = Fn.formatLosung(losung_);
            var date = getLosungDate(losung_.date);
            dateLabel.text = date.toLocaleDateString(Locale, Locale.ShortFormat);

            losungsText.text = text;
        } else {
            var year = new Date().getFullYear();
            var xmlZipFile = "Losung_" + year + "_XML.zip";
            var downloadUrl = "https://www.losungen.de/digital/daten/";
            var fileDownloadUrl = "https://www.losungen.de/fileadmin/media-losungen/download/";
            var dataFileLocation = "~/.local/share/plasma/plasmoids/org.kde.losungen/contents/data/";
            var message = qsTr(  "Data file \"%1\" not found. You can a get it from <a href=\"%2\">%2</a>. "
                               + "Download the <a href=\"%3\">Losungen XML zip</a>, unzip the contained "
                               + "xml file to the installation directory's data folder, e.g.: \"%4\".<br/>"
                               + "Note that you might need to remove the widget and re-add it, or log "
                               + "out and in again for the new file to be recognized.");
            losungsText.text = message.arg(losungen.dataFileName).arg(downloadUrl).arg(fileDownloadUrl + xmlZipFile).arg(dataFileLocation);
        }
    }

    /* data object
     * here, the structure of the data in the xml file is defined
     * xml file should be put in ../data 
     * the data file can be retrieved from http://www.losungen.de/download/
     * if the structure of the xml file provided here should ever change, the data
     * model must be adapted
     * */
    XmlListModel {
        id: losungen
        property string dataFileName: "Losungen Free " + new Date().getFullYear() + ".xml";
     
        property int currentDay: 0; 
        source: "../data/" + this.dataFileName;  // contains XML content
     
        query: "/FreeXml/Losungen"
     
        XmlRole { name: "date";     query: "Datum/string()" }
        XmlRole { name: "weekday";  query: "Wtag/string()" }
        XmlRole { name: "ot_text";  query: "Losungstext/string()" }
        XmlRole { name: "ot_verse"; query: "Losungsvers/string()" }
        XmlRole { name: "nt_text";  query: "Lehrtext/string()" }
        XmlRole { name: "nt_verse"; query: "Lehrtextvers/string()" }

        function getLosung(d) {
            var doy = Fn.getDOY(d);
            return this.get(doy);

        }

        function previous() {
            if (this.currentDay > 1) this.currentDay--;
            setLosung(this.currentDay);
        }

        function next() {
            if (this.currentDay < Fn.getDaysInYear()) this.currentDay++;
            setLosung(this.currentDay);
        }

        function today() {
            var date = new Date();
            this.currentDay = Fn.getDOY(date) - 1;
            setLosung(this.currentDay);
        }
        Component.onCompleted: { init();}
        onCountChanged: init()
    }
}
