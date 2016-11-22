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
    Q_PROPERTY(Type type READ type WRITE setType FINAL)

public:
    enum Type {
        Button,
        ComboBox,
    };

    Q_ENUM(Type)

    explicit QQuickControls2NSControl(QQuickItem *parent = nullptr);

    Type type() const;
    void setType(Type type);

    bool pressed() const;
    void setPressed(bool pressed);

    void paint(QPainter *painter);

private:
    Type m_type;
    bool m_pressed;
    bool m_useDefaultWidth;
    bool m_useDefaultHeight;
    NSControl *m_control;

    void configureControl();
    void configureButton();
    void configureComboBox();
};

QT_END_NAMESPACE

QML_DECLARE_TYPE(QQuickControls2NSControl)

#endif // QQUICKCONTROLS2NSVIEW_H
