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
import org.kde.plasma.plasmoid 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.4
import QtQuick.XmlListModel 2.0 
import "../code/functions.js" as Fn

Image {
    id: root;

    // default size
    width: 250;
    height: 300;

    ColumnLayout {
        anchors {
            fill: parent
        }

        spacing: units.gridUnit

        /* day selector */
        RowLayout {
            id: daySelector
            property int buttonSize: 30
            visible: plasmoid.configuration.showDaySelector;

            Layout.alignment: Qt.AlignHCenter
            Label {
                id: dateLabel
            }
 
            /* go to previous day's Losung button */
            Button {
                onClicked: losungen.previous()
                text: " ◂ "; // placeholder to give some size
                style: ButtonStyle {
                    background: Rectangle {
                       implicitWidth: daySelector.buttonSize
                       implicitHeight: daySelector.buttonSize
                       border.width: control.activeFocus ? 2 : 1
                       border.color: "#888"
                       radius: 4
                       gradient: Gradient {
                           GradientStop { position: 0 ; color: control.pressed ? "#ccc" : "#eee" }
                           GradientStop { position: 1 ; color: control.pressed ? "#aaa" : "#ccc" }
                       }
                    }
                }
            }
            /* go to today's Losung button */
            Button {
                onClicked: losungen.today()
                text: " = ";
                style: ButtonStyle {
                    background: Rectangle {
                       implicitWidth: daySelector.buttonSize
                       implicitHeight: daySelector.buttonSize
                       border.width: control.activeFocus ? 2 : 1
                       border.color: "#888"
                       radius: 4
                       gradient: Gradient {
                           GradientStop { position: 0 ; color: control.pressed ? "#ccc" : "#eee" }
                           GradientStop { position: 1 ; color: control.pressed ? "#aaa" : "#ccc" }
                       }
                    }
                }
            }
            /* go to next day's Losung button */
            Button {
                onClicked: losungen.next()
                text: " ▸ ";
                style: ButtonStyle {
                    background: Rectangle {
                       implicitWidth: daySelector.buttonSize
                       implicitHeight: daySelector.buttonSize
                       border.width: control.activeFocus ? 2 : 1
                       border.color: "#888"
                       radius: 4
                       gradient: Gradient {
                           GradientStop { position: 0 ; color: control.pressed ? "#ccc" : "#eee" }
                           GradientStop { position: 1 ; color: control.pressed ? "#aaa" : "#ccc" }
                       }
                    }
                }
            }
        }

        /* Losung text area */
        TextArea {
            id: losungsText;

            Layout.fillHeight: true

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

        }
    }

    /* initialize the plasmoid with the current day's Losung */
    function init() {
        losungen.today()
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
            
            losungsText.text = i18n("Data file ") + losungen.dataFileName 
                             + i18n(" not found. You can a get it from ")
                             + "<a href=\"http://www.losungen.de/download/\">http://www.losungen.de/download/</a>."
                             + i18n("Download the Losungen XML zip, unzip the contained xml file to the installation directory's data folder, e.g.: ")
                             + "~/.local/share/plasma/plasmoids/org.kde.losungen/contents/data";
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
        Component.onCompleted: init()
        onCountChanged: init()
    }
}
