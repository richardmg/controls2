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

#include "qqc2nscontrol.h"

QT_BEGIN_NAMESPACE

NSButton *QQC2NSControl::s_nsButton = 0;
NSComboBox *QQC2NSControl::s_nsComboBox = 0;

static const QChar separator(QLatin1Char(','));

QQC2NSControl::QQC2NSControl(QQuickItem *parent)
    : QObject(parent)
    , m_type(Button)
    , m_bezelStyle(RoundedBezelStyle)
    , m_pressed(false)
    , m_contentRect(QRectF())
    , m_width(0)
    , m_height(0)
    , m_preferredWidth(0)
    , m_preferredHeight(0)
    , m_text(nullptr)
    , m_url(QUrl())
    , m_control(nullptr)
    , m_componentComplete(false)
{
}

QQC2NSControl::~QQC2NSControl()
{
}

QQC2NSControl::Type QQC2NSControl::type() const
{
   return m_type;
}

void QQC2NSControl::setType(QQC2NSControl::Type type)
{
    if (m_type == type)
        return;

   m_type = type;
   update();
}

QQC2NSControl::BezelStyle QQC2NSControl::bezelStyle() const
{
    return m_bezelStyle;
}

void QQC2NSControl::setBezelStyle(QQC2NSControl::BezelStyle bezelStyle)
{
    if (m_bezelStyle == bezelStyle)
        return;

   m_bezelStyle = bezelStyle;
   update();
}

bool QQC2NSControl::pressed() const
{
    return m_pressed;
}

void QQC2NSControl::setPressed(bool pressed)
{
    if (m_pressed == pressed)
        return;

    m_pressed = pressed;
    update();
}

QRectF QQC2NSControl::contentRect() const
{
    return m_contentRect;
}

QQuickText *QQC2NSControl::text() const
{
   return m_text;
}

void QQC2NSControl::setText(QQuickText *text)
{
    if (m_text == text)
        return;

   m_text = text;
   update();
}

void QQC2NSControl::setPreferredWidth(qreal preferredWidth)
{
    // m_preferredWidth and m_preferredHeight are, together with
    // m_text, used to calculate implicitSize.
    if (m_preferredWidth == preferredWidth)
        return;

   m_preferredWidth = preferredWidth;
   update();
}

qreal QQC2NSControl::preferredWidth() const
{
    return m_preferredWidth;
}

void QQC2NSControl::setPreferredHeight(qreal preferredHeight)
{
    // m_preferredWidth and m_preferredHeight are, together with
    // m_text, used to calculate implicitSize.
    if (m_preferredHeight == preferredHeight)
        return;

   m_preferredHeight = preferredHeight;
   update();
}

qreal QQC2NSControl::preferredHeight() const
{
    return m_preferredHeight;
}

qreal QQC2NSControl::width() const
{
    return m_width;
}

qreal QQC2NSControl::height() const
{
    return m_height;
}

QUrl QQC2NSControl::url() const
{
    return m_url;
}

void QQC2NSControl::componentComplete()
{
    m_componentComplete = true;
    update();
}

QPixmap QQC2NSControl::takeSnapshot()
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

void QQC2NSControl::updateContentRect(const CGRect &cgRect, const QMargins &margins)
{
    updateContentRect(QRectF::fromCGRect(cgRect).adjusted(margins.left(), margins.top(), margins.right(), margins.bottom()));
}

void QQC2NSControl::updateContentRect(const QRectF &rect)
{
    if (rect == m_contentRect)
        return;

    m_contentRect = rect;
    emit contentRectChanged();
}

void QQC2NSControl::updateSize(const CGSize &size)
{
   updateSize(size.width, size.height);
}

void QQC2NSControl::updateSize(qreal width, qreal height)
{
    if (width != m_width) {
        m_width = width;
        emit widthChanged();
    }

    if (height != m_height) {
        m_height = height;
        emit heightChanged();
    }
}

void QQC2NSControl::updateFont()
{
    if (!m_text)
        return;

    NSString *family = m_text->font().family().toNSString();
    int pointSize = m_text->font().pointSize();
    m_control.font = [NSFont fontWithName:family size:pointSize];
}

QString QQC2NSControl::toStringID()
{
    return QString::number(int(m_type))
            + separator + QString::number(int(m_pressed))
            + separator + QString::number(m_bezelStyle);
}

void QQC2NSControl::configureFromStringID(const QString &id)
{
    int i = 0;
    QStringList args = id.split(separator);

    m_type = Type(args[i++].toInt());
    m_pressed = bool(args[i++].toInt());
    m_bezelStyle = BezelStyle(args[i++].toInt());

    m_componentComplete = true;
    update();
}

void QQC2NSControl::updateUrl()
{
    QUrl url(QStringLiteral("image://nscontrol/") + toStringID());

    if (url == m_url)
        return;

    m_url = url;
    emit urlChanged();
}

void QQC2NSControl::update()
{
    if (!m_componentComplete)
        return;

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

void QQC2NSControl::updateButton()
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
    s_nsButton.bezelStyle = NSBezelStyle(m_bezelStyle);

    [m_control sizeToFit];
    CGRect bounds = m_control.bounds;
    bounds.size.width = qMax(bounds.size.width, m_preferredWidth);
    updateSize(bounds.size);
    updateContentRect(bounds, QMargins(0, 0, 0, 0));
}

void QQC2NSControl::updateComboBox()
{
    if (!s_nsComboBox) {
        // [NSControl sizeToFit] fails and calculates a too small rect. So we need
        // some manual adjustments to get the correct height, while at the same
        // time, ensure that the combo is wide enough to not truncate the button on the right.
        s_nsComboBox = [[NSComboBox alloc] initWithFrame:NSMakeRect(0, 0, 70, 30)];
        NSSize size = [s_nsComboBox sizeThatFits:NSMakeSize(70, 30)];
        s_nsComboBox.bounds = NSMakeRect(0, 0, 70, size.height);
    }
    m_control = s_nsComboBox;

    //updateFont();
    //s_nsComboBox.title = m_text ? m_text->text().toNSString() : @"";
    //s_nsComboBox.highlighted = m_pressed;

    CGRect bounds = m_control.bounds;
    updateSize(qMax(m_preferredWidth, bounds.size.width), bounds.size.height);
    updateContentRect(QRectF(0, 0, m_width, m_height));
}

#include "moc_qqc2nscontrol.cpp"

QT_END_NAMESPACE
