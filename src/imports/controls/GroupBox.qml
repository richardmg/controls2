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

AbstractGroupBox {
    id: control

    default property alias data: content.data

    implicitWidth: Math.max(background ? background.implicitWidth : 0,
                            contentWidth + padding.left + padding.right)
    implicitHeight: Math.max(background ? background.implicitHeight : 0,
                             contentHeight + padding.top + padding.bottom)

    contentWidth: content.children.length === 1 ? content.children[0].implicitWidth : 0
    contentHeight: content.children.length === 1 ? content.children[0].implicitHeight : 0

    padding {
        top: style.padding + (label && title ? label.implicitHeight + style.spacing : 0)
        left: style.padding
        right: style.padding
        bottom: style.padding
    }

    contentItem: Item {
        id: content
        x: padding.left
        y: padding.top
        width: parent.width - padding.left - padding.right
        height: parent.height - padding.top - padding.bottom
    }

    label: Text {
        x: padding.left
        width: parent.width - padding.left - padding.right

        text: control.title
        color: control.style.textColor
        elide: Text.ElideRight
        opacity: enabled ? 1.0 : control.style.disabledOpacity
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
    }

    frame: Rectangle {
        y: padding.top - style.padding
        width: parent.width
        height: parent.height - padding.top + style.padding

        color: "transparent"
        radius: style.roundness
        border.color: style.frameColor
    }
}