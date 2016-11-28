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
#include <QtQuick/qquickpainteditem.h>
#include <QtQuick/private/qquicktext_p.h>

QT_BEGIN_NAMESPACE

Q_FORWARD_DECLARE_OBJC_CLASS(NSControl);

class QQuickControls2NSControl : public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(bool pressed READ pressed WRITE setPressed FINAL)
    Q_PROPERTY(Type type READ type WRITE setType FINAL)
    Q_PROPERTY(QRectF contentRect READ contentRect NOTIFY contentRectChanged FINAL)
    Q_PROPERTY(QQuickText *text READ text WRITE setText FINAL)
    Q_PROPERTY(bool snapshotFailed READ snapshotFailed NOTIFY snapshotFailedChanged FINAL)

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
    bool snapshotFailed() const;
    QQuickText *text() const;
    void setText(QQuickText *text);

    virtual void paint(QPainter *painter) override;
    virtual void componentComplete() override;

    Q_INVOKABLE void updateControl();

Q_SIGNALS:
    void contentRectChanged();
    void snapshotFailedChanged(bool snapshotFailed);

private:
    Type m_type;
    bool m_pressed;
    QRectF m_contentRect;
    bool m_snapshotFailed;
    QQuickText *m_text;
    NSControl *m_control;

    QPixmap createPixmap();
    void syncControlSizeWithItemSize(NSControl *control, bool hasFixedWidth, bool hasFixedHeight);
    void setContentRect(const CGRect &cgRect, const QMargins &margins = QMargins());
    void setContentRect(const QRectF &rect);
    void calculateAndSetImplicitSize(NSControl *control);
    void setFont(NSControl *control);

    void createButton();
    void createComboBox();
};

QT_END_NAMESPACE

QML_DECLARE_TYPE(QQuickControls2NSControl)

#endif // QQUICKCONTROLS2NSVIEW_H
