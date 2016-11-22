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
    , m_useDefaultWidth(true)
    , m_useDefaultHeight(true)
    , m_control(Q_NULLPTR)
{
    setFlag(ItemHasContents);
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

void QQuickControls2NSControl::paint(QPainter *painter)
{
    configureControl();
    m_control.wantsLayer = YES;

    if (!m_useDefaultWidth || !m_useDefaultHeight) {
        [m_control sizeToFit];
        NSRect bounds = m_control.bounds;
        if (m_useDefaultWidth)
            bounds.size.width = width();
        if (m_useDefaultHeight)
            bounds.size.height = height();
        m_control.bounds = bounds;
    }

    int w = int(m_control.bounds.size.width);
    int h = int(m_control.bounds.size.height);
    QPixmap pix(w, h);
    pix.fill(Qt::transparent);
    QMacCGContext ctx(&pix);

    [m_control.layer drawInContext:ctx];
    painter->drawPixmap(0, 0, pix);

    // todo: copy all pixmaps into atlas FBO
}

void QQuickControls2NSControl::configureControl()
{
    switch(m_type) {
    case Button:
    case CheckBox:
        configureButton();
        break;
    case ComboBox:
        configureComboBox();
        break;
    default: {
        Q_UNREACHABLE(); }
    }

    Q_ASSERT(m_control);
}

void QQuickControls2NSControl::configureButton()
{
    NSButton *button = [[[NSButton alloc] initWithFrame:NSMakeRect(0, 0, width(), height())] autorelease];
    button.title = @"";

    switch(m_type) {
    case CheckBox:
        button.buttonType = NSSwitchButton;
        break;
    default:
        break;
    }

    m_control = button;
}

void QQuickControls2NSControl::configureComboBox()
{
    m_useDefaultHeight = false;
    NSComboBox *combobox = [[[NSComboBox alloc] initWithFrame:NSMakeRect(0, 0, width(), height())] autorelease];
    m_control = combobox;
}

#include "moc_qquickcontrols2nsview.cpp"

QT_END_NAMESPACE
