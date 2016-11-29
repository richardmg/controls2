#ifndef FPS_H
#define FPS_H

#include <QtCore/QTime>
#include <QtQuick/qquickwindow.h>
#include <QtQuick/qquickitem.h>

QT_BEGIN_NAMESPACE

class FPS : public QQuickItem
{
    Q_OBJECT
    Q_PROPERTY(qreal fps READ fps NOTIFY fpsChanged FINAL)
public:
    FPS(QQuickItem *parent = nullptr)
        : QQuickItem(parent)
        , m_fps(0)
        , m_frameCount(0)
    {}

    virtual void componentComplete() override
    {
        connect(window(), SIGNAL(frameSwapped()), this, SLOT(frameSwapped()));
        m_time.start();
    }

public:
    Q_SLOT void frameSwapped()
    {
        m_frameCount++;
        window()->update();

        if (m_time.elapsed() > 500) {
            m_fps = (m_frameCount * 500 / m_time.elapsed()) * 2;
            m_frameCount = 0;
            m_time.start();
            emit fpsChanged();
        }
    }

    qreal fps() const
    {
        return m_fps;
    }

signals:
    void fpsChanged();

private:
    qreal m_fps;
    int m_frameCount;
    QTime m_time;
};

QT_END_NAMESPACE

QML_DECLARE_TYPE(FPS)

#endif // FPS_H
