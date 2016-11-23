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
    , m_pixmap(QPixmap())
{
    setFlag(ItemHasContents);
    createPixmap();
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

void QQuickControls2NSControl::paint(QPainter *painter)
{
    painter->drawPixmap(0, 0, m_pixmap);
}

void QQuickControls2NSControl::createPixmap()
{
    NSControl *control = createControl();

    // todo: copy all pixmaps into atlas FBO?
    m_pixmap = QPixmap(QSizeF::fromCGSize(control.bounds.size).toSize());
    m_pixmap.fill(Qt::transparent);
    QMacCGContext ctx(&m_pixmap);

    control.wantsLayer = YES;
    [control.layer drawInContext:ctx];
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
    setImplicitSize(bounds.size.width, bounds.size.height);

    if (!hasFixedWidth)
        bounds.size.width = width();
    if (!hasFixedHeight)
        bounds.size.height = height();

    control.bounds = bounds;
}

NSControl *QQuickControls2NSControl::createControl()
{
    NSControl *control = Q_NULLPTR;

    switch(m_type) {
    case Button:
    case CheckBox:
        control = createButton();
        break;
    case ComboBox:
        control = createComboBox();
        break;
    default: {
        Q_UNREACHABLE(); }
    }

    Q_ASSERT(control);
    return control;
}

NSControl *QQuickControls2NSControl::createButton()
{
    NSButton *button = [[[NSButton alloc] initWithFrame:NSZeroRect] autorelease];
    setControlSize(button, false, false);
    button.title = @"";

    switch(m_type) {
    case CheckBox:
        button.buttonType = NSSwitchButton;
        break;
    default:
        break;
    }

    setContentRect(QRectF::fromCGRect(button.bounds));
    return button;
}

NSControl *QQuickControls2NSControl::createComboBox()
{
    NSComboBox *combobox = [[[NSComboBox alloc] initWithFrame:NSZeroRect] autorelease];
    setControlSize(combobox, false, true);

    setContentRect(QRectF::fromCGRect(combobox.bounds));
    return combobox;
}

#include "moc_qquickcontrols2nsview.cpp"

QT_END_NAMESPACE
