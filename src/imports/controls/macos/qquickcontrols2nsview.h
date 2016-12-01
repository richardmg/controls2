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

#ifndef QQUICKCONTROLS2NSVIEW_H
#define QQUICKCONTROLS2NSVIEW_H

//
//  W A R N I N G
//  -------------
//
// This file is not part of the Qt API.  It exists purely as an
// implementation detail.  This header file may change from version to
// version without notice, or even be removed.
//
// We mean it.
//

#include <QtGui/qpixmap.h>
#include <QtQuick/qquickitem.h>
#include <QtQuick/private/qquicktext_p.h>

QT_BEGIN_NAMESPACE

Q_FORWARD_DECLARE_OBJC_CLASS(NSControl);
Q_FORWARD_DECLARE_OBJC_CLASS(NSButton);
Q_FORWARD_DECLARE_OBJC_CLASS(NSComboBox);

class QQuickControls2NSControl : public QObject, public QQmlParserStatus
{
    Q_OBJECT
    Q_PROPERTY(bool pressed READ pressed WRITE setPressed FINAL)
    Q_PROPERTY(Type type READ type WRITE setType FINAL)
    Q_PROPERTY(QRectF contentRect READ contentRect NOTIFY contentRectChanged FINAL)
    Q_PROPERTY(QSizeF implicitSize READ implicitSize NOTIFY implicitSizeChanged FINAL)
    Q_PROPERTY(QQuickText *text READ text WRITE setText FINAL)
    Q_PROPERTY(QUrl url READ url NOTIFY urlChanged FINAL)

    Q_INTERFACES(QQmlParserStatus)

public:
    enum Type {
        Button,
        CheckBox,
        ComboBox,
    };

    Q_ENUM(Type)

    explicit QQuickControls2NSControl(QQuickItem *parent = nullptr);
    ~QQuickControls2NSControl();

    Type type() const;
    void setType(Type type);

    bool pressed() const;
    void setPressed(bool pressed);
    QRectF contentRect() const;
    QSizeF implicitSize() const;
    bool snapshotFailed() const;
    QQuickText *text() const;
    void setText(QQuickText *text);
    QUrl url() const;

    QPixmap takeSnapshot();
    QString toStringID();
    void configureFromStringID(const QString &id);

    virtual void classBegin() override {};
    virtual void componentComplete() override;

Q_SIGNALS:
    void contentRectChanged();
    void implicitSizeChanged();
    void urlChanged();

private:
    Type m_type;
    bool m_pressed;
    QRectF m_contentRect;
    QSizeF m_implicitSize;
    QQuickText *m_text;
    QUrl m_url;
    NSControl *m_control;

    void updateContentRect(const CGRect &cgRect, const QMargins &margins = QMargins());
    void updateContentRect(const QRectF &rect);
    void updateImplicitSize();
    void updateFont();
    void updateUrl();

    void update();
    void updateButton();
    void updateComboBox();

    static NSButton *s_nsButton;
    static NSComboBox *s_nsComboBox;
};

QT_END_NAMESPACE

QML_DECLARE_TYPE(QQuickControls2NSControl)

#endif // QQUICKCONTROLS2NSVIEW_H
