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
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components
import org.kde.plasma.plasmoid
import QtQuick.Layouts
import org.kde.kirigami as Kirigami

PlasmoidItem {
    id: root
    preferredRepresentation: fullRepresentation
    fullRepresentation: MainWidget {}

    width: 15 * Kirigami.Units.gridUnit
    height: 15 * Kirigami.Units.gridUnit
    anchors.fill: parent

    Component.onCompleted: init()

    /* initialize the plasmoid config defaults */
    function init() {
        var conf = plasmoid.configuration;

        if (conf.backgroundColor1 == "") conf.backgroundColor1 = Kirigami.Theme.backgroundColor;
        if (conf.backgroundColor2 == "") conf.backgroundColor2 = Kirigami.Theme.backgroundColor;
        if (conf.textFont == "") conf.textFont = Kirigami.Theme.defaultFont;
        if (conf.textColor == "") conf.textColor = Kirigami.Theme.textColor;
    }

}
