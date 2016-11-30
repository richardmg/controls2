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
//    implicitWidth: background.implicitWidth
//    implicitHeight: background.implicitHeight

    Text {
       id: foo
       font.family: "verdana"
       font.pointSize: 12
    }

    //font: foo.font

    contentItem: Item {
        implicitWidth: text.implicitWidth
        implicitHeight: text.implicitHeight
        Text {
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

            //enabled: false
            //visible: false

            opacity: enabled ? 1.0 : 0.2
            color: "red"
            //onImplicitWidthChanged: print("impl text width:", implicitWidth)
            //onImplicitHeightChanged: print("impl text height:", implicitHeight)
        }
    }

    background: BorderImage {
        //source: "/Users/richard/tmp/ButtonSnap.png"
        source: nsControl.url
        border.left: 10
        border.right: 10
        border.top: 10
        border.bottom: 10
        horizontalTileMode: BorderImage.Stretch
        verticalTileMode: BorderImage.Stretch
    }

    NSControl {
        id: nsControl
        type: NSControl.Button
        pressed: control.pressed
        text: text
        onImplicitSizeChanged: print("implicit size:", implicitWidth, implicitHeight)
    }
}
