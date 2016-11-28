#include <AppKit/AppKit.h>

#include <QtGui/qpixmap.h>
#include <QtGui/qpainter.h>

#include <QtGui/private/qcoregraphics_p.h>

#include "qquickcontrols2nsview.h"

QT_BEGIN_NAMESPACE

QQuickControls2NSControl::QQuickControls2NSControl(QQuickItem *parent)
    : QQuickPaintedItem(parent)
    , m_type(Button)
    , m_pressed(false)
    , m_contentRect(QRectF())
    , m_snapshotFailed(false)
    , m_text(Q_NULLPTR)
    , m_control(Q_NULLPTR)
{
    setFlag(ItemHasContents);
}

QQuickControls2NSControl::~QQuickControls2NSControl()
{
    [m_control release];
}

QQuickControls2NSControl::Type QQuickControls2NSControl::type() const
{
   return m_type;
}

void QQuickControls2NSControl::setType(QQuickControls2NSControl::Type type)
{
   m_type = type;
}

bool QQuickControls2NSControl::pressed() const
{
    return m_pressed;
}

void QQuickControls2NSControl::setPressed(bool pressed)
{
    m_pressed = pressed;
}

QRectF QQuickControls2NSControl::contentRect() const
{
    return m_contentRect;
}

bool QQuickControls2NSControl::snapshotFailed() const
{
    return m_snapshotFailed;
}

QQuickText *QQuickControls2NSControl::text() const
{
   return m_text;
}

void QQuickControls2NSControl::setText(QQuickText *text)
{
    qDebug() << Q_FUNC_INFO << "setting text:" << text->text();
   m_text = text;
}

void QQuickControls2NSControl::paint(QPainter *painter)
{
    painter->drawPixmap(0, 0, createPixmap());
}

void QQuickControls2NSControl::componentComplete()
{
    updateControl();
    QQuickPaintedItem::componentComplete();
}

QPixmap QQuickControls2NSControl::createPixmap()
{
    // todo: copy all pixmaps into atlas FBO?
    QPixmap pixmap(QSizeF::fromCGSize(m_control.bounds.size).toSize());
    pixmap.fill(Qt::transparent);
    QMacCGContext ctx(&pixmap);

    m_control.wantsLayer = YES;
    [m_control.layer drawInContext:ctx];
    return pixmap;
}

void QQuickControls2NSControl::setContentRect(const QRectF &rect)
{
    if (rect == m_contentRect)
        return;

    m_contentRect = rect;
    emit contentRectChanged();
}

void QQuickControls2NSControl::setControlSize(NSControl *control, bool hasFixedWidth, bool hasFixedHeight)
{
    [control sizeToFit];
    NSRect bounds = control.bounds;

    qDebug() << Q_FUNC_INFO << "implicit size:" << bounds.size.width << bounds.size.height;
    setImplicitSize(bounds.size.width, bounds.size.height);

    if (!hasFixedWidth)
        bounds.size.width = width();
    if (!hasFixedHeight)
        bounds.size.height = height();

    control.bounds = bounds;
}

void QQuickControls2NSControl::setText(NSControl *control)
{
    if (!m_text)
        return;

    control.stringValue = m_text->text().toNSString();
    NSString *family = m_text->font().family().toNSString();
    int pointSize = m_text->font().pointSize();
    control.font = [NSFont fontWithName:family size:pointSize];
}

void QQuickControls2NSControl::updateControl()
{
    [m_control release];
    m_control = Q_NULLPTR;

    switch(m_type) {
    case Button:
    case CheckBox:
        createButton();
        break;
    case ComboBox:
        createComboBox();
        break;
    default: {
        Q_UNREACHABLE(); }
    }

    Q_ASSERT(m_control);
}

void QQuickControls2NSControl::createButton()
{
    NSButton *button = [[NSButton alloc] initWithFrame:NSZeroRect];

    if (m_text)
        button.title = m_text->text().toNSString();
    setText(button);
    setControlSize(button, false, false);

    switch(m_type) {
    case CheckBox:
        button.buttonType = NSSwitchButton;
        break;
    default:
        break;
    }

    setContentRect(QRectF::fromCGRect(button.bounds));
    m_control = button;
}

void QQuickControls2NSControl::createComboBox()
{
    NSComboBox *combobox = [[NSComboBox alloc] initWithFrame:NSZeroRect];
    setControlSize(combobox, false, true);

    setContentRect(QRectF::fromCGRect(combobox.bounds));
    m_control = combobox;
}

#include "moc_qquickcontrols2nsview.cpp"

QT_END_NAMESPACE
