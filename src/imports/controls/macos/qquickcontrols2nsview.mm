#include <AppKit/AppKit.h>

#include <QtGui/qpixmap.h>
#include <QtGui/qpainter.h>

#include <QtGui/private/qcoregraphics_p.h>

#include "qquickcontrols2nsview.h"

QT_BEGIN_NAMESPACE

QQuickControls2NSView::QQuickControls2NSView(QQuickItem *parent)
    : QQuickPaintedItem(parent)
    , m_className(QStringLiteral("NSButton"))
    , m_pressed(false)
{
    setFlag(ItemHasContents);
}

QString QQuickControls2NSView::className() const
{
    return m_className;
}

void QQuickControls2NSView::setClassName(const QString &className)
{
    m_className = className;
}

bool QQuickControls2NSView::pressed() const
{
    return m_pressed;
}

void QQuickControls2NSView::setPressed(bool pressed)
{
    m_pressed = pressed;
}

void QQuickControls2NSView::paint(QPainter *painter)
{
    NSControl *m_nsControl = [[NSButton alloc] initWithFrame:NSMakeRect(0, 0, width(), height())];
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

    //[m_nsView performSelector:@selector(setButtonType:) withObject:[NSNumber numberWithInt:NSSwitchButton]];
    //[m_nsView performSelectorOnMainThread:@selector(setButtonType:) withObject:[NSNumber numberWithInt:NSSwitchButton] waitUntilDone:YES];
    //[m_nsView setButtonType:NSSwitchButton];

    int w = int(m_nsControl.bounds.size.width);
    int h = int(m_nsControl.bounds.size.height);
    QPixmap pix(w, h);
    pix.fill(Qt::transparent);
    QMacCGContext ctx(&pix);

    [m_nsControl.layer drawInContext:ctx];
    painter->drawPixmap(0, 0, pix);

    // todo: copy all pixmaps into atlas FBO
}

void QQuickControls2NSView::updateSnapshot()
{
    // To avoid updating the snapshot several times if the user changes
    // several properties, he will need to call this function explicit.
}

#include "moc_qquickcontrols2nsview.cpp"

QT_END_NAMESPACE
