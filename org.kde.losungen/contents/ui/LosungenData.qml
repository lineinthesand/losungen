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
import QtQml.XmlListModel
import "../code/functions.js" as Fn

/* data object
 * here, the structure of the data in the xml file is defined
 * xml file should be put in ../data 
 * the data file can be retrieved from https://www.losungen.de/download/
 * if the structure of the xml file provided here should ever change, the data
 * model must be adapted
 */
Item {
    property int currentDay: 0; 
    property alias status: l.status
    property alias count: l.count
    property alias dataFileName: l.dataFileName

    XmlListModel {
        id: l
        property string dataFileName: "Losungen Free " + new Date().getFullYear() + ".xml";
     
        source: "../data/" + this.dataFileName;  // contains XML content
     
        query: "/FreeXml/Losungen"
     
        XmlListModelRole { name: "date";     elementName: "Datum" }
        XmlListModelRole { name: "weekday";  elementName: "Wtag" }
        XmlListModelRole { name: "ot_text";  elementName: "Losungstext" }
        XmlListModelRole { name: "ot_verse"; elementName: "Losungsvers" }
        XmlListModelRole { name: "nt_text";  elementName: "Lehrtext" }
        XmlListModelRole { name: "nt_verse"; elementName: "Lehrtextvers" }
    
        onCountChanged: today()
    }

    /* get method not available in qt6; replacement code from
     * https://forum.qt.io/post/710953 
     * Get the i'th <Losungen> xml element (defined in the query above) and
     * return a dictionary with the keys defined in the XmlListModelRoles above
     * and the corresponding values of that day's Losung */
    function get(i) {
        var o = {}
        var roles = l.roles

        for (var j = 0; j < roles.length; ++j) {
            o[roles[j].name] = l.data(l.index(i,0), Qt.UserRole + j)  
        }  
        return o 
    }

    function previous() {
        if (this.currentDay > 1) this.currentDay--;
    }

    function next() {
        if (this.currentDay < Fn.getDaysInYear()) this.currentDay++;
    }

    function today() {
        var date = new Date();

        this.currentDay = Fn.getDOY(date) - 1;
    }
    
}
