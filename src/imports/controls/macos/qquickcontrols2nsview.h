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

    void updateContentRect(const CGRect &cgRect, const QMargins &margins = QMargins());
    void updateContentRect(const QRectF &rect);
    void updateImplicitSize(NSControl *control);
    void updateFont(NSControl *control);
    void updateUrl();

    void update();
    void updateButton();
    void updateComboBox();
};

QT_END_NAMESPACE

QML_DECLARE_TYPE(QQuickControls2NSControl)

#endif // QQUICKCONTROLS2NSVIEW_H
