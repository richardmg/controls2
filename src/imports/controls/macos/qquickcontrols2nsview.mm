#include <AppKit/AppKit.h>

#include <QtGui/qpixmap.h>
#include <QtGui/qpainter.h>

#include <QtGui/private/qcoregraphics_p.h>

#include "qquickcontrols2nsview.h"

QT_BEGIN_NAMESPACE

QQuickControls2NSControl::QQuickControls2NSControl(QQuickItem *parent)
    : QObject(parent)
    , m_type(Button)
    , m_pressed(false)
    , m_contentRect(QRectF())
    , m_implicitSize(QSize())
    , m_text(Q_NULLPTR)
    , m_url(QUrl())
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

void QQuickControls2NSControl::updateImplicitSize(NSControl *control)
{
    [control sizeToFit];
    QSizeF size = QSizeF::fromCGSize(control.bounds.size);

    if (size == m_implicitSize)
        return;

    m_implicitSize = size;
    emit implicitSizeChanged();
}

void QQuickControls2NSControl::updateFont(NSControl *control)
{
    if (!m_text)
        return;

    NSString *family = m_text->font().family().toNSString();
    int pointSize = m_text->font().pointSize();
    control.font = [NSFont fontWithName:family size:pointSize];
}

void QQuickControls2NSControl::updateUrl()
{
    QString urlString = QString::number(int(m_type));
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
    // Create on setType, and cast here?
    NSButton *button = [[[NSButton alloc] initWithFrame:NSZeroRect] autorelease];

    switch(m_type) {
    case CheckBox:
        button.buttonType = NSSwitchButton;
        break;
    default:
        break;
    }

    if (m_text) {
        updateFont(button);
        button.title = m_text->text().toNSString();
    }

    QMargins contentRectMargins;

    if (m_pressed) {
        button.highlighted = YES;
        contentRectMargins += QMargins(-1, 4, 0, 0);
    } else {
        contentRectMargins += QMargins(-1, 1, 0, 0);
    }

    button.bezelStyle = NSRoundedBezelStyle;

    updateImplicitSize(button);
    updateContentRect(button.bounds, contentRectMargins);
}

void QQuickControls2NSControl::updateComboBox()
{
    NSComboBox *combobox = [[[NSComboBox alloc] initWithFrame:NSZeroRect] autorelease];

    updateImplicitSize(combobox);
    updateContentRect(combobox.bounds);
}

#include "moc_qquickcontrols2nsview.cpp"

QT_END_NAMESPACE
