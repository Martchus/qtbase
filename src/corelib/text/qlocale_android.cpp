// Copyright (C) 2026 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR LGPL-3.0-only OR GPL-2.0-only OR GPL-3.0-only
// Qt-Security score:significant reason:default

#include "qlocale_p.h"

#include <QDateTime>
#include <QJniObject>
#include <QReadWriteLock>
#include <QStringList>
#include <QVariant>

#include <QtCore/private/qjnihelpers_p.h>

QT_BEGIN_NAMESPACE

#ifndef QT_NO_SYSTEMLOCALE

Q_DECLARE_JNI_CLASS(Locale, "java/util/Locale")
Q_DECLARE_JNI_CLASS(Resources, "android/content/res/Resources")
Q_DECLARE_JNI_CLASS(Configuration, "android/content/res/Configuration")
Q_DECLARE_JNI_CLASS(LocaleList, "android/os/LocaleList")
Q_DECLARE_JNI_CLASS(DateFormat, "android/text/format/DateFormat")

namespace {

using namespace QtJniTypes;

struct QSystemLocaleData
{
    QSystemLocaleData() : locale(QLocale::C) {}

    void readLocaleFromJava();

    QReadWriteLock lock;
    QLocale locale;
    bool is24HourFormat = false;
};

void QSystemLocaleData::readLocaleFromJava()
{
    const Locale javaLocaleObject = []{
        const QJniObject javaContext = QtAndroidPrivate::context();
        if (javaContext.isValid()) {
            const QJniObject resources = javaContext.callMethod<Resources>("getResources");
            const QJniObject configuration = resources.callMethod<Configuration>("getConfiguration");
            return configuration.getField<Locale>("locale");
        }
        return Locale::callStaticMethod<Locale>("getDefault");
    }();

    const QString languageCode = javaLocaleObject.callMethod<QString>("getLanguage");
    const QString extraCodes[3] = {
        javaLocaleObject.callMethod<QString>("getScript"),
        javaLocaleObject.callMethod<QString>("getCountry"),
        javaLocaleObject.callMethod<QString>("getVariant"),
    };
    QString fullName = languageCode;
    for (const QString &code : extraCodes) {
        if (code.isEmpty())
            continue;
        if (!fullName.isEmpty())
            fullName += u'_';
        fullName += code;
    }

    const bool is24Hour = DateFormat::callStaticMethod<bool>("is24HourFormat",
                                                             QtAndroidPrivate::context());

    QWriteLocker locker(&lock);
    locale = QLocale(fullName);
    is24HourFormat = is24Hour;
}

Q_GLOBAL_STATIC(QSystemLocaleData, qSystemLocaleData)

QString convertTo24hFormat(const QString &format)
{
    QString format24(format);
    bool inQuoted = false;
    for (qsizetype i = 0; i < format24.size(); ++i) {
        if (format24[i] == u'\'') {
            inQuoted = !inQuoted;
            continue;
        }
        if (inQuoted)
            continue;

        // Strip AM/PM markers from the format string.
        const auto c = format24[i].toUpper();
        if (c == u'A' || c == u'P')
            format24.remove(i--, 1);
    }
    return format24.trimmed();
}

} // unnamed namespace

QLocale QSystemLocale::fallbackLocale() const
{
    QSystemLocaleData *d = qSystemLocaleData();
    if (!d)
        return QLocale(QLocale::C);

    QReadLocker locker(&d->lock);
    return d->locale;
}

QVariant QSystemLocale::query(QueryType type, QVariant &&in) const
{
    QSystemLocaleData *d = qSystemLocaleData();
    if (!d)
        return QVariant();

    if (type == LocaleChanged) {
        d->readLocaleFromJava();
        return QVariant();
    }

    QReadLocker locker(&d->lock);
    const QLocale &locale = d->locale;
    const bool is24h = d->is24HourFormat;

    auto timeFormat = [&](QLocale::FormatType fmt) {
        const QString format = locale.timeFormat(fmt);
        return is24h ? convertTo24hFormat(format) : format;
    };
    auto dateTimeFormat = [&](QLocale::FormatType fmt) {
        const QString format = locale.dateTimeFormat(fmt);
        return is24h ? convertTo24hFormat(format) : format;
    };

    switch (type) {
    case DecimalPoint:
        return locale.decimalPoint();
    case Grouping:
        return QVariant::fromValue(locale.d->m_data->groupSizes());
    case GroupSeparator:
        return locale.groupSeparator();
    case ZeroDigit:
        return locale.zeroDigit();
    case NegativeSign:
        return locale.negativeSign();
    case DateFormatLong:
        return locale.dateFormat(QLocale::LongFormat);
    case DateFormatShort:
        return locale.dateFormat(QLocale::ShortFormat);
    case TimeFormatLong:
        return timeFormat(QLocale::LongFormat);
    case TimeFormatShort:
        return timeFormat(QLocale::ShortFormat);
    case DayNameLong:
        return locale.dayName(in.toInt(), QLocale::LongFormat);
    case DayNameShort:
        return locale.dayName(in.toInt(), QLocale::ShortFormat);
    case DayNameNarrow:
        return locale.dayName(in.toInt(), QLocale::NarrowFormat);
    case StandaloneDayNameLong:
        return locale.standaloneDayName(in.toInt(), QLocale::LongFormat);
    case StandaloneDayNameShort:
        return locale.standaloneDayName(in.toInt(), QLocale::ShortFormat);
    case StandaloneDayNameNarrow:
        return locale.standaloneDayName(in.toInt(), QLocale::NarrowFormat);
    case MonthNameLong:
        return locale.monthName(in.toInt(), QLocale::LongFormat);
    case MonthNameShort:
        return locale.monthName(in.toInt(), QLocale::ShortFormat);
    case MonthNameNarrow:
        return locale.monthName(in.toInt(), QLocale::NarrowFormat);
    case StandaloneMonthNameLong:
        return locale.standaloneMonthName(in.toInt(), QLocale::LongFormat);
    case StandaloneMonthNameShort:
        return locale.standaloneMonthName(in.toInt(), QLocale::ShortFormat);
    case StandaloneMonthNameNarrow:
        return locale.standaloneMonthName(in.toInt(), QLocale::NarrowFormat);
    case DateToStringLong:
        return locale.toString(in.toDate(), QLocale::LongFormat);
    case DateToStringShort:
        return locale.toString(in.toDate(), QLocale::ShortFormat);
    case TimeToStringLong:
        return locale.toString(in.toTime(), timeFormat(QLocale::LongFormat));
    case TimeToStringShort:
        return locale.toString(in.toTime(), timeFormat(QLocale::ShortFormat));
    case DateTimeFormatLong:
        return dateTimeFormat(QLocale::LongFormat);
    case DateTimeFormatShort:
        return dateTimeFormat(QLocale::ShortFormat);
    case DateTimeToStringLong:
        return locale.toString(in.toDateTime(), dateTimeFormat(QLocale::LongFormat));
    case DateTimeToStringShort:
        return locale.toString(in.toDateTime(), dateTimeFormat(QLocale::ShortFormat));
    case PositiveSign:
        return locale.positiveSign();
    case AMText:
        return locale.amText();
    case PMText:
        return locale.pmText();
    case FirstDayOfWeek:
        return locale.firstDayOfWeek();
    case CurrencySymbol:
        return locale.currencySymbol(QLocale::CurrencySymbolFormat(in.toUInt()));
    case CurrencyToString: {
        switch (in.metaType().id()) {
        case QMetaType::Int:
            return locale.toCurrencyString(in.toInt());
        case QMetaType::UInt:
            return locale.toCurrencyString(in.toUInt());
        case QMetaType::Double:
            return locale.toCurrencyString(in.toDouble());
        case QMetaType::LongLong:
            return locale.toCurrencyString(in.toLongLong());
        case QMetaType::ULongLong:
            return locale.toCurrencyString(in.toULongLong());
        default:
            break;
        }
        return QString();
    }
    case StringToStandardQuotation:
        return locale.quoteString(in.value<QStringView>());
    case StringToAlternateQuotation:
        return locale.quoteString(in.value<QStringView>(), QLocale::AlternateQuotation);
    case ListToSeparatedString:
        return locale.createSeparatedList(in.value<QStringList>());
    case UILanguages: {
        if (QtAndroidPrivate::androidSdkVersion() >= 24) {
            const LocaleList localeListObject =
                    LocaleList::callStaticMethod<LocaleList>("getDefault");
            if (localeListObject.isValid()) {
                QString lang = localeListObject.callMethod<QString>("toLanguageTags");
                // Some devices wrap the list in [] - strip those if present.
                if (lang.startsWith(u'[') && lang.endsWith(u']'))
                    lang = lang.mid(1, lang.length() - 2);
                return lang.split(u',');
            }
        }
        return QVariant();
    }
    case LocaleChanged:
        Q_UNREACHABLE();
    default:
        break;
    }
    return QVariant();
}

#endif // QT_NO_SYSTEMLOCALE

QT_END_NAMESPACE
