/****************************************************************************
**
** Copyright (C) 2015 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the Qt Quick Controls module of the Qt Toolkit.
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

import QtQuick 2.4
import QtQuick.Controls 2.0

AbstractTextField {
    id: control

    implicitWidth: Math.max(background ? background.implicitWidth : 0,
                            Math.max(input ? input.implicitWidth : 0,
                                     placeholder ? placeholder.implicitWidth : 0) + padding.left + padding.right)
    implicitHeight: Math.max(background ? background.implicitHeight : 0,
                             Math.max(input ? input.implicitHeight : 0,
                                      placeholder ? placeholder.implicitHeight : 0) + padding.top + padding.bottom)

    Accessible.name: text
    Accessible.role: Accessible.EditableText
    Accessible.readOnly: !input || input.readOnly
    Accessible.description: placeholder ? placeholder.text : ""
    Accessible.passwordEdit: !!input && (input.echoMode == TextInput.Password ||
                                         input.echoMode === TextInput.PasswordEchoOnEdit)

    padding { top: style.padding; left: style.padding; right: style.padding; bottom: style.padding }

    input: TextInput {
        x: padding.left
        y: padding.top
        width: parent.width - padding.left - padding.right
        height: parent.height - padding.top - padding.bottom

        color: style.textColor
        selectionColor: style.selectionColor
        selectedTextColor: style.selectedTextColor
        verticalAlignment: TextInput.AlignVCenter
        Keys.forwardTo: control
    }

    placeholder: Text {
        x: padding.left
        y: padding.top
        width: parent.width - padding.left - padding.right
        height: parent.height - padding.top - padding.bottom

        color: control.style.textColor
        opacity: control.style.disabledOpacity
        visible: input ? !input.displayText : !control.text
    }

    background: Rectangle {
        implicitWidth: 120 // TODO
        radius: style.roundness
        border.width: control.activeFocus ? 2 : 1
        border.color: control.activeFocus ? style.focusColor : style.frameColor
        opacity: enabled ? 1.0 : style.disabledOpacity
    }
}