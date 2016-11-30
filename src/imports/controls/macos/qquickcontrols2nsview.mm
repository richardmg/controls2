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

#include <AppKit/AppKit.h>

#include <QtGui/qpixmap.h>
#include <QtGui/qpainter.h>

#include <QtGui/private/qcoregraphics_p.h>

#include "qquickcontrols2nsview.h"

QT_BEGIN_NAMESPACE

NSButton *QQuickControls2NSControl::s_nsButton = 0;
NSComboBox *QQuickControls2NSControl::s_nsComboBox = 0;

QQuickControls2NSControl::QQuickControls2NSControl(QQuickItem *parent)
    : QObject(parent)
    , m_type(Button)
    , m_pressed(false)
    , m_contentRect(QRectF())
    , m_implicitSize(QSize())
    , m_text(nullptr)
    , m_url(QUrl())
    , m_control(nullptr)
{
}

QQuickControls2NSControl::~QQuickControls2NSControl()
{
}

QQuickControls2NSControl::Type QQuickControls2NSControl::type() const
{
   return m_type;
}

void QQuickControls2NSControl::setType(QQuickControls2NSControl::Type type)
{
    if (m_type == type)
        return;

   m_type = type;
   update();
}

bool QQuickControls2NSControl::pressed() const
{
    return m_pressed;
}

void QQuickControls2NSControl::setPressed(bool pressed)
{
    if (m_pressed == pressed)
        return;

    m_pressed = pressed;
    update();
}

QRectF QQuickControls2NSControl::contentRect() const
{
    return m_contentRect;
}

QSizeF QQuickControls2NSControl::implicitSize() const
{
    return m_implicitSize;
}

QQuickText *QQuickControls2NSControl::text() const
{
   return m_text;
}

void QQuickControls2NSControl::setText(QQuickText *text)
{
    if (m_text == text)
        return;

   m_text = text;
   update();
}

QUrl QQuickControls2NSControl::url() const
{
    return m_url;
}

void QQuickControls2NSControl::componentComplete()
{
    update();
}

QPixmap QQuickControls2NSControl::takeSnapshot()
{
    // m_control points to a shared control, so ensure
    // we update it to mirror this instance before the snapshot
    update();

    QPixmap pixmap(QSizeF::fromCGSize(m_control.bounds.size).toSize());
    pixmap.fill(Qt::transparent);
    QMacCGContext ctx(&pixmap);

    m_control.wantsLayer = YES;
    [m_control.layer drawInContext:ctx];

    return pixmap;
}

void QQuickControls2NSControl::updateContentRect(const CGRect &cgRect, const QMargins &margins)
{
    updateContentRect(QRectF::fromCGRect(cgRect).adjusted(margins.left(), margins.top(), margins.right(), margins.bottom()));
}

void QQuickControls2NSControl::updateContentRect(const QRectF &rect)
{
    if (rect == m_contentRect)
        return;

    m_contentRect = rect;
    emit contentRectChanged();
}

void QQuickControls2NSControl::updateImplicitSize()
{
    [m_control sizeToFit];
    QSizeF size = QSizeF::fromCGSize(m_control.bounds.size);


    if (size == m_implicitSize)
        return;

    m_implicitSize = size;
    emit implicitSizeChanged();
}

void QQuickControls2NSControl::updateFont()
{
    if (!m_text)
        return;

    NSString *family = m_text->font().family().toNSString();
    int pointSize = m_text->font().pointSize();
    m_control.font = [NSFont fontWithName:family size:pointSize];
}

void QQuickControls2NSControl::updateUrl()
{
    QString urlString = QStringLiteral("image://nscontrol/")
            + QString::number(int(m_type))
            + QStringLiteral(",")
            + QString::number(int(m_pressed));

    QUrl url(urlString);

    if (url == m_url)
        return;

    m_url = url;
    emit urlChanged();
}

void QQuickControls2NSControl::update()
{
    switch(m_type) {
    case Button:
    case CheckBox:
        updateButton();
        break;
    case ComboBox:
        updateComboBox();
        break;
    default:
        Q_UNREACHABLE();
    }

    updateUrl();
}

void QQuickControls2NSControl::updateButton()
{
    if (!s_nsButton)
        s_nsButton = [[NSButton alloc] initWithFrame:NSZeroRect];
    m_control = s_nsButton;

    switch(m_type) {
    case CheckBox:
        s_nsButton.buttonType = NSSwitchButton;
        break;
    default:
        break;
    }

    updateFont();
    s_nsButton.title = m_text ? m_text->text().toNSString() : @"";
    s_nsButton.highlighted = m_pressed;
    s_nsButton.bezelStyle = NSRoundedBezelStyle;

    QMargins contentRectMargins = m_pressed ? QMargins(-1, 4, 0, 0) : QMargins(-1, 1, 0, 0);

    updateImplicitSize();
    updateContentRect(s_nsButton.bounds, contentRectMargins);
}

void QQuickControls2NSControl::updateComboBox()
{
    if (!s_nsComboBox)
        s_nsComboBox = [[NSComboBox alloc] initWithFrame:NSZeroRect];
    m_control = s_nsComboBox;

    updateImplicitSize();
    updateContentRect(s_nsComboBox.bounds);
}

#include "moc_qquickcontrols2nsview.cpp"

QT_END_NAMESPACE
