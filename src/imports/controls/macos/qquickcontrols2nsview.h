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

class QQuickControls2NSView : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(QString className READ className WRITE setClassName FINAL)
    Q_PROPERTY(bool pressed READ pressed WRITE setPressed FINAL)

public:
    explicit QQuickControls2NSView(QQuickItem *parent = nullptr);

    QString className() const;
    void setClassName(const QString &className);

    bool pressed() const;
    void setPressed(bool pressed);

    void paint(QPainter *painter);

    Q_INVOKABLE void updateSnapshot();

private:
    QString m_className;
    bool m_pressed;
};

QT_END_NAMESPACE

QML_DECLARE_TYPE(QQuickControls2NSView)

#endif // QQUICKCONTROLS2NSVIEW_H
