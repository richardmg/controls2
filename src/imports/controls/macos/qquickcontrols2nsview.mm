#include <AppKit/AppKit.h>

#include <QtGui/qpixmap.h>
#include <QtGui/qpainter.h>

#include <QtGui/private/qcoregraphics_p.h>

#include "qquickcontrols2nsview.h"

QT_BEGIN_NAMESPACE

QQuickControls2NSControl::QQuickControls2NSControl(QQuickItem *parent)
    : QQuickPaintedItem(parent)
    , m_pressed(false)
{
    setFlag(ItemHasContents);
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
    NSControl *m_nsControl = createControl();
    m_nsControl.wantsLayer = YES;

    bool supportCustomWidth = true;
    bool supportCustomHeight = false;

    if (!supportCustomWidth || !supportCustomHeight) {
        [m_nsControl sizeToFit];
        NSRect bounds = m_nsControl.bounds;
        if (supportCustomWidth)
            bounds.size.width = width();
        if (supportCustomHeight)
            bounds.size.height = height();
        m_nsControl.bounds = bounds;
    }

    int w = int(m_nsControl.bounds.size.width);
    int h = int(m_nsControl.bounds.size.height);
    QPixmap pix(w, h);
    pix.fill(Qt::transparent);
    QMacCGContext ctx(&pix);

    [m_nsControl.layer drawInContext:ctx];
    painter->drawPixmap(0, 0, pix);

    // todo: copy all pixmaps into atlas FBO
}

// ---------------------------------------------------

NSControl* QQuickControls2NSButton::createControl()
{
    NSButton *nsButton = [[[NSButton alloc] initWithFrame:NSMakeRect(0, 0, width(), height())] autorelease];
    return nsButton;
}


#include "moc_qquickcontrols2nsview.cpp"

QT_END_NAMESPACE
