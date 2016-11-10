#include "qquickcontrols2nsview.h"

QT_BEGIN_NAMESPACE

QQuickControls2NSView::QQuickControls2NSView(QQuickItem *parent)
    : QQuickItem(parent)
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
}

void QQuickControls2NSView::itemChange(QQuickItem::ItemChange change, const QQuickItem::ItemChangeData &data)
{
    Q_UNUSED(change)
    Q_UNUSED(data)
}

QSGNode *QQuickControls2NSView::updatePaintNode(QSGNode *oldNode, QQuickItem::UpdatePaintNodeData *)
{

}

#include "moc_qquickcontrols2nsview.cpp"

QT_END_NAMESPACE
