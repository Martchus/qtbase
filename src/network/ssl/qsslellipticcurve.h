/****************************************************************************
**
** Copyright (C) 2014 Governikus GmbH & Co. KG.
** Contact: http://www.qt-project.org/legal
**
** This file is part of the QtNetwork module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and Digia.  For licensing terms and
** conditions see http://qt.digia.com/licensing.  For further information
** use the contact form at http://qt.digia.com/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 2.1 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** In addition, as a special exception, Digia gives you certain additional
** rights.  These rights are described in the Digia Qt LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3.0 as published by the Free Software
** Foundation and appearing in the file LICENSE.GPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU General Public License version 3.0 requirements will be
** met: http://www.gnu.org/copyleft/gpl.html.
**
**
** $QT_END_LICENSE$
**
****************************************************************************/

#ifndef QSSLELLIPTICCURVE_H
#define QSSLELLIPTICCURVE_H

#include <QtCore/QtGlobal>
#include <QtCore/QString>
#include <QtCore/QStringList>
#include <QtCore/QMetaType>
#include <QtCore/QVector>
#include <QtCore/QHash>

QT_BEGIN_NAMESPACE

class QSslEllipticCurve;
// qHash is a friend, but we can't use default arguments for friends (§8.3.6.4)
Q_DECL_CONSTEXPR uint qHash(QSslEllipticCurve curve, uint seed = 0) Q_DECL_NOTHROW;

class QSslEllipticCurve {
public:
    Q_DECL_CONSTEXPR QSslEllipticCurve()
        : id(0)
    {
    }

    Q_NETWORK_EXPORT static QSslEllipticCurve fromShortName(const QString &name);

    Q_NETWORK_EXPORT QString shortName() const Q_REQUIRED_RESULT;
    Q_NETWORK_EXPORT QString longName() const Q_REQUIRED_RESULT;

    Q_DECL_CONSTEXPR bool isValid() const
    {
        return id != 0;
    }

    Q_NETWORK_EXPORT bool isTlsNamedCurve() const;

private:
    int id;

    friend Q_DECL_CONSTEXPR bool operator==(QSslEllipticCurve lhs, QSslEllipticCurve rhs) Q_DECL_NOTHROW
    { return lhs.id == rhs.id; }
    friend Q_DECL_CONSTEXPR uint qHash(QSslEllipticCurve curve, uint seed) Q_DECL_NOTHROW
    { return qHash(curve.id, seed); }

    friend class QSslSocketPrivate;
    friend class QSslSocketBackendPrivate;
};

Q_DECLARE_TYPEINFO(QSslEllipticCurve, Q_PRIMITIVE_TYPE);

Q_DECL_CONSTEXPR inline bool operator!=(QSslEllipticCurve lhs, QSslEllipticCurve rhs) Q_DECL_NOTHROW
{ return !operator==(lhs, rhs); }

#ifndef QT_NO_DEBUG_STREAM
class QDebug;
Q_NETWORK_EXPORT QDebug operator<<(QDebug debug, QSslEllipticCurve curve);
#endif

QT_END_NAMESPACE

Q_DECLARE_METATYPE(QSslEllipticCurve)

#endif // QSSLELLIPTICCURVE_H
