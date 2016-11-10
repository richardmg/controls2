/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the Qt Quick Controls 2 module of the Qt Toolkit.
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

import QtQuick 2.8
import QtQuick.Templates 2.1 as T
import QtQuick.Controls.macOS 2.1

T.Button {
    id: control

    implicitWidth: nsControl.implicitSize.width
    implicitHeight: nsControl.implicitSize.height

//    Text {
//       id: foo
//       font.family: "verdana"
//       font.pointSize: 30
//       visible: false
//    }

//    font: foo.font

    contentItem: Text {
        id: text
        x: nsControl.contentRect.x
        y: nsControl.contentRect.y
        width: nsControl.contentRect.width
        height: nsControl.contentRect.height

        text: control.text
        font: control.font
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        opacity: enabled ? 1.0 : 0.2
        color: "black"
    }

    background: BorderImage {
        source: nsControl.url
        width: nsControl.size.width
        height: nsControl.size.height
        border.left: sourceSize.width / 2
        border.right: sourceSize.width / 2
        border.top: sourceSize.height / 2
        border.bottom: sourceSize.height / 2
        horizontalTileMode: BorderImage.Stretch
        verticalTileMode: BorderImage.Stretch
    }

    NSControl {
        id: nsControl
        type: NSControl.Button
        preferredWidth: control.width
        preferredHeight: control.height
        pressed: control.pressed
        bezelStyle: NSControl.RoundedBezelStyle
        text: text
    }
}
