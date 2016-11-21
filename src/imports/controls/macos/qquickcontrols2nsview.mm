#include "qquickcontrols2nsview.h"
#include <QtGui/qopenglframebufferobject.h>

QT_BEGIN_NAMESPACE

class NSViewToFboRenderer : public QQuickFramebufferObject::Renderer
{
public:
    NSViewToFboRenderer()
    {
        // create NSView etc already here?
    }

    void updateSnapshot()
    {
        QQuickFramebufferObject::Renderer::update();
    }

    void render() override
    {
        // my NSView code goes here!
    }

    QOpenGLFramebufferObject *createFramebufferObject(const QSize &size) override
    {
        QOpenGLFramebufferObjectFormat format;
        format.setAttachment(QOpenGLFramebufferObject::CombinedDepthStencil);
        format.setSamples(4);
        return new QOpenGLFramebufferObject(size, format);
    }
};

// -----------------------------------------------------------

QQuickControls2NSView::QQuickControls2NSView(QQuickItem *parent)
    : QQuickFramebufferObject(parent)
    , m_renderer(new NSViewToFboRenderer())
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

void QQuickControls2NSView::updateSnapshot()
{
    // To avoid updating the snapshot several times if the user changes
    // several properties, he will need to call this function explicit.
    m_renderer->updateSnapshot();
}

QQuickFramebufferObject::Renderer *QQuickControls2NSView::createRenderer() const
{
    return m_renderer;
}

#include "moc_qquickcontrols2nsview.cpp"

QT_END_NAMESPACE
