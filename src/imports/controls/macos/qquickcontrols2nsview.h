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

#include <QtQuick/qquickitem.h>
#include <QtQuick/qquickpainteditem.h>

QT_BEGIN_NAMESPACE

Q_FORWARD_DECLARE_OBJC_CLASS(NSControl);

class QQuickControls2NSControl : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(bool pressed READ pressed WRITE setPressed FINAL)

public:
    explicit QQuickControls2NSControl(QQuickItem *parent = nullptr);

    bool pressed() const;
    void setPressed(bool pressed);

    void paint(QPainter *painter);

    virtual NSControl* createControl() = 0;

private:
    bool m_pressed;
};

// ---------------------------------------------------

class QQuickControls2NSButton : public QQuickControls2NSControl
{
    Q_OBJECT

public:
    NSControl* createControl();
};

QT_END_NAMESPACE

QML_DECLARE_TYPE(QQuickControls2NSButton)

#endif // QQUICKCONTROLS2NSVIEW_H
