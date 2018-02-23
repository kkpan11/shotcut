/*
 * Copyright (c) 2016 Meltytech, LLC
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.1
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.0
import Shotcut.Controls 1.0

Item {
    width: 200
    height: 50
    
    Component.onCompleted: {
        if (filter.isNew) {
            // Set default parameter values
            filter.set("level", 1.0);
        }
        brightnessSlider.value = filter.getDouble("level") * 100.0
    }

    Connections {
        target: filter
        onInChanged: updateFilter()
        onOutChanged: updateFilter()
        onAnimateInChanged: updateFilter()
        onAnimateOutChanged: updateFilter()
    }

    function updateFilter() {
        var value = brightnessSlider.value / 100.0
        var filterDuration = filter.out - filter.in + 1
        if (filter.animateIn > 0 && filter.animateOut > 1) {
            filter.set('level', '0=0; %2=%1; %3=%1; %4=0'
                       .arg(value)
                       .arg(filter.animateIn - 1)
                       .arg(filterDuration - filter.animateOut)
                       .arg(filterDuration - 1))
        } else if (filter.animateIn > 0) {
            filter.set('level', '0=0; %2=%1'
                       .arg(value)
                       .arg(filter.animateIn - 1))
        } else if (filter.animateOut > 0) {
            filter.set('level', '%2=%1; %3=0'
                       .arg(value)
                       .arg(filterDuration - filter.animateOut)
                       .arg(filterDuration - 1))
        } else {
            filter.set('level', value)
        }
    }

    GridLayout {
        columns: 3
        anchors.fill: parent
        anchors.margins: 8

        Label {
            text: qsTr('Brightness')
            Layout.alignment: Qt.AlignRight
        }
        SliderSpinner {
            id: brightnessSlider
            minimumValue: 0.0
            maximumValue: 200.0
            decimals: 1
            suffix: ' %'
            onValueChanged: updateFilter()
        }
        UndoButton {
            onClicked: brightnessSlider.value = 100
        }

        Item {
            Layout.fillHeight: true
        }
    }
}
