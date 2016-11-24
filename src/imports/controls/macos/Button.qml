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

    implicitWidth: background.implicitWidth
    implicitHeight: background.implicitHeight

    /*
    implicitWidth: Math.max(background ? background.implicitWidth : 0,
                            contentItem.implicitWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(background ? background.implicitHeight : 0,
                             contentItem.implicitHeight + topPadding + bottomPadding)
    */
//    baselineOffset: contentItem.y + contentItem.baselineOffset

//    padding: 8
//    topPadding: padding - 4
//    bottomPadding: padding - 4

    contentItem: Item {
        implicitWidth: text.implicitWidth
        implicitHeight: text.implicitHeight
        Text {
            id: text
//            x: background.contentRect.x
//            y: background.contentRect.y
//            width: background.contentRect.width
//            height: background.contentRect.height
            text: control.text
            font: control.font
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter

            opacity: enabled ? 1.0 : 0.2
            color: "black"
            onImplicitWidthChanged: print("impl text width:", implicitWidth)
            onImplicitHeightChanged: print("impl text height:", implicitHeight)
        }
    }

    background: NSControl {
        type: NSControl.Button
        pressed: false
        text: text
        
        //width: 100//text.width
        //height: 100//text.height

        // Problemet er at nscontrol ikke har noen label, og dermed vil den calculere
        // en alt for liten knapp i sizeToFit.
        // 1. enten gi med en text, selv om dette blir unøyaktig
        // 2. skriv om slik at text blir førende for størrelsen i horisontal retning
        //  - høres mest fornuftig ut
        //  - kanskje sende med text.width og text.height som ønsket content size?

        onSnapshotFailedChanged: {
            print("Snapshot failed, fall back to draw the control, or use default style")
            // or add 'fallback:' prop that points to a component that gets instanciated automatically
        }
        onWidthChanged: print("new nscontrol width:" + width)
        onHeightChanged: print("new nscontrol :" + width)
    }
}
