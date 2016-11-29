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
    if (m_type == type)
        return;

   m_type = type;
   updateControl();
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
    updateControl();
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
    if (m_text == text)
        return;

   m_text = text;
   updateControl();
}

void QQuickControls2NSControl::paint(QPainter *painter)
{
    painter->drawPixmap(0, 0, createPixmap());
}

void QQuickControls2NSControl::componentComplete()
{
    QQuickPaintedItem::componentComplete();
    updateControl();
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

void QQuickControls2NSControl::setContentRect(const CGRect &cgRect, const QMargins &margins)
{
    setContentRect(QRectF::fromCGRect(cgRect).adjusted(margins.left(), margins.top(), margins.right(), margins.bottom()));
}

void QQuickControls2NSControl::setContentRect(const QRectF &rect)
{
    if (rect == m_contentRect)
        return;

    m_contentRect = rect;
    emit contentRectChanged();
}

void QQuickControls2NSControl::calculateAndSetImplicitSize(NSControl *control)
{
    [control sizeToFit];
    NSRect bounds = control.bounds;
    setImplicitSize(bounds.size.width, bounds.size.height);
}

void QQuickControls2NSControl::syncControlSizeWithItemSize(NSControl *control, bool hasFixedWidth, bool hasFixedHeight)
{
    NSRect bounds = control.bounds;

    if (!hasFixedWidth)
        bounds.size.width = width();
    if (!hasFixedHeight)
        bounds.size.height = height();

    control.bounds = bounds;
}

void QQuickControls2NSControl::setFont(NSControl *control)
{
    if (!m_text)
        return;

    NSString *family = m_text->font().family().toNSString();
    int pointSize = m_text->font().pointSize();
    control.font = [NSFont fontWithName:family size:pointSize];
}

void QQuickControls2NSControl::updateControl()
{
    if (!isComponentComplete())
        return;

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

    // Update pixmap
    update();
}

void QQuickControls2NSControl::createButton()
{
    NSButton *button = [[NSButton alloc] initWithFrame:NSZeroRect];

    switch(m_type) {
    case CheckBox:
        button.buttonType = NSSwitchButton;
        break;
    default:
        break;
    }

    if (m_text) {
        setFont(button);
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

    calculateAndSetImplicitSize(button);
    syncControlSizeWithItemSize(button, false, false);
    setContentRect(button.bounds, contentRectMargins);


    // Remove title before taking snapshot
    //button.title = @"";

    m_control = button;
}

void QQuickControls2NSControl::createComboBox()
{
    NSComboBox *combobox = [[NSComboBox alloc] initWithFrame:NSZeroRect];

    calculateAndSetImplicitSize(combobox);
    syncControlSizeWithItemSize(combobox, false, true);
    setContentRect(combobox.bounds);

    m_control = combobox;
}

#include "moc_qquickcontrols2nsview.cpp"

QT_END_NAMESPACE
