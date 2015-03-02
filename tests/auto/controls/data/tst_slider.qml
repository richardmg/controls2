/****************************************************************************
**
** Copyright (C) 2015 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the test suite of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL3$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see http://www.qt.io/terms-conditions. For further
** information use the contact form at http://www.qt.io/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 3 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPLv3 included in the
** packaging of this file. Please review the following information to
** ensure the GNU Lesser General Public License version 3 requirements
** will be met: https://www.gnu.org/licenses/lgpl.html.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 2.0 or later as published by the Free
** Software Foundation and appearing in the file LICENSE.GPL included in
** the packaging of this file. Please review the following information to
** ensure the GNU General Public License version 2.0 requirements will be
** met: http://www.gnu.org/licenses/gpl-2.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.2
import QtTest 1.0
import QtQuick.Controls 2.0

TestCase {
    id: testCase
    width: 400
    height: 400
    visible: true
    when: windowShown
    name: "Slider"

    SignalSpy{
        id: pressedSpy
        signalName: "pressedChanged"
    }

    Component {
        id: slider
        Slider { }
    }

    function init() {
        verify(!pressedSpy.target)
        compare(pressedSpy.count, 0)
    }

    function cleanup() {
        pressedSpy.target = null
        pressedSpy.clear()
    }

    function test_defaults() {
        var control = slider.createObject(testCase)
        verify(control)
        verify(control.handle)
        verify(control.track)
        compare(control.value, 0)
        compare(control.position, 0)
        compare(control.visualPosition, 0)
        compare(control.stepSize, 0)
        compare(control.snapMode, AbstractSlider.NoSnap)
        compare(control.pressed, false)
        compare(control.orientation, Qt.Horizontal)
        compare(control.layoutDirection, Qt.LeftToRight)
        compare(control.effectiveLayoutDirection, Qt.LeftToRight)
        control.destroy()
    }

    function test_layoutDirection() {
        var control = slider.createObject(testCase)

        verify(!control.LayoutMirroring.enabled)
        compare(control.layoutDirection, Qt.LeftToRight)
        compare(control.effectiveLayoutDirection, Qt.LeftToRight)

        control.layoutDirection = Qt.RightToLeft
        compare(control.layoutDirection, Qt.RightToLeft)
        compare(control.effectiveLayoutDirection, Qt.RightToLeft)

        control.LayoutMirroring.enabled = true
        compare(control.layoutDirection, Qt.RightToLeft)
        compare(control.effectiveLayoutDirection, Qt.LeftToRight)

        control.layoutDirection = Qt.LeftToRight
        compare(control.layoutDirection, Qt.LeftToRight)
        compare(control.effectiveLayoutDirection, Qt.RightToLeft)

        control.LayoutMirroring.enabled = false
        compare(control.layoutDirection, Qt.LeftToRight)
        compare(control.effectiveLayoutDirection, Qt.LeftToRight)

        control.destroy()
    }

    function test_visualPosition() {
        var control = slider.createObject(testCase, {value: 0.25})
        compare(control.value, 0.25)
        compare(control.visualPosition, 0.25)

        control.layoutDirection = Qt.RightToLeft
        compare(control.visualPosition, 0.75)

        control.LayoutMirroring.enabled = true
        compare(control.visualPosition, 0.25)

        control.layoutDirection = Qt.LeftToRight
        compare(control.visualPosition, 0.75)

        control.LayoutMirroring.enabled = false
        compare(control.visualPosition, 0.25)

        control.destroy()
    }

    function test_orientation() {
        var control = slider.createObject(testCase)
        compare(control.orientation, Qt.Horizontal)
        verify(control.width > control.height)
        control.orientation = Qt.Vertical
        compare(control.orientation, Qt.Vertical)
        verify(control.width < control.height)
        control.destroy()
    }

    function test_mouse_data() {
        return [
            { tag: "horizontal", orientation: Qt.Horizontal },
            { tag: "vertical", orientation: Qt.Vertical }
        ]
    }

    function test_mouse(data) {
        var control = slider.createObject(testCase, {orientation: data.orientation})

        pressedSpy.target = control
        verify(pressedSpy.valid)

        mousePress(control, 0, 0, Qt.LeftButton)
        compare(pressedSpy.count, 1)
        compare(control.pressed, true)
        compare(control.value, 0.0)
        compare(control.position, 0.0)

        mouseMove(control, -control.width, -control.height, 0, Qt.LeftButton)
        compare(pressedSpy.count, 1)
        compare(control.pressed, true)
        compare(control.value, 0.0)
        compare(control.position, 0.0)

        mouseMove(control, control.width * 0.5, control.height * 0.5, 0, Qt.LeftButton)
        compare(pressedSpy.count, 1)
        compare(control.pressed, true)
        compare(control.value, 0.0)
        verify(control.position, 0.5)

        mouseRelease(control, control.width * 0.5, control.height * 0.5, Qt.LeftButton)
        compare(pressedSpy.count, 2)
        compare(control.pressed, false)
        compare(control.value, 0.5)
        compare(control.position, 0.5)

        mousePress(control, control.width, control.height, Qt.LeftButton)
        compare(pressedSpy.count, 3)
        compare(control.pressed, true)
        compare(control.value, 0.5)
        compare(control.position, 0.5)

        mouseMove(control, control.width * 2, control.height * 2, 0, Qt.LeftButton)
        compare(pressedSpy.count, 3)
        compare(control.pressed, true)
        compare(control.value, 0.5)
        compare(control.position, 1.0)

        mouseMove(control, control.width * 0.75, control.height * 0.75, 0, Qt.LeftButton)
        compare(pressedSpy.count, 3)
        compare(control.pressed, true)
        compare(control.value, 0.5)
        verify(control.position >= 0.75)

        mouseRelease(control, control.width * 0.25, control.height * 0.25, Qt.LeftButton)
        compare(pressedSpy.count, 4)
        compare(control.pressed, false)
        compare(control.value, control.position)
        verify(control.value <= 0.25 && control.value >= 0.0)
        verify(control.position <= 0.25 && control.position >= 0.0)

        control.destroy()
    }

    function test_keys_data() {
        return [
            { tag: "horizontal", orientation: Qt.Horizontal, decrease: Qt.Key_Left, increase: Qt.Key_Right },
            { tag: "vertical", orientation: Qt.Vertical, decrease: Qt.Key_Down, increase: Qt.Key_Up }
        ]
    }

    function test_keys(data) {
        var control = slider.createObject(testCase, {orientation: data.orientation})

        var pressedCount = 0

        pressedSpy.target = control
        verify(pressedSpy.valid)

        control.forceActiveFocus()
        verify(control.activeFocus)

        control.value = 0.5

        for (var d1 = 1; d1 <= 10; ++d1) {
            keyPress(data.decrease)
            compare(control.pressed, true)
            compare(pressedSpy.count, ++pressedCount)

            compare(control.value, Math.max(0.0, 0.5 - d1 * 0.1))
            compare(control.value, control.position)

            keyRelease(data.decrease)
            compare(control.pressed, false)
            compare(pressedSpy.count, ++pressedCount)
        }

        for (var i1 = 1; i1 <= 20; ++i1) {
            keyPress(data.increase)
            compare(control.pressed, true)
            compare(pressedSpy.count, ++pressedCount)

            compare(control.value, Math.min(1.0, 0.0 + i1 * 0.1))
            compare(control.value, control.position)

            keyRelease(data.increase)
            compare(control.pressed, false)
            compare(pressedSpy.count, ++pressedCount)
        }

        control.stepSize = 0.25

        for (var d2 = 1; d2 <= 10; ++d2) {
            keyPress(data.decrease)
            compare(control.pressed, true)
            compare(pressedSpy.count, ++pressedCount)

            compare(control.value, Math.max(0.0, 1.0 - d2 * 0.25))
            compare(control.value, control.position)

            keyRelease(data.decrease)
            compare(control.pressed, false)
            compare(pressedSpy.count, ++pressedCount)
        }

        for (var i2 = 1; i2 <= 10; ++i2) {
            keyPress(data.increase)
            compare(control.pressed, true)
            compare(pressedSpy.count, ++pressedCount)

            compare(control.value, Math.min(1.0, 0.0 + i2 * 0.25))
            compare(control.value, control.position)

            keyRelease(data.increase)
            compare(control.pressed, false)
            compare(pressedSpy.count, ++pressedCount)
        }

        control.destroy()
    }
}