package com.ayjs.mxzg.common.util.time;

import java.time.Clock;
import java.time.DayOfWeek;
import java.time.Instant;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.ZoneId;
import java.time.ZoneOffset;
import java.time.ZonedDateTime;
import java.time.temporal.ChronoUnit;
import java.time.temporal.WeekFields;
import java.util.Date;
import java.util.Objects;

/**
 * 时间处理工具类
 */
public class LocalDateTimeUtil {
    /**
     * 第一天为周一，第一周最少一天
     */
    private static WeekFields WEEK_FIELDS = WeekFields.of(DayOfWeek.MONDAY, 1);

    private static final ZoneOffset ZONE_OFFSET;

    static {
        Clock clock = Clock.systemDefaultZone();
        ZONE_OFFSET = clock.getZone().getRules().getOffset(clock.instant());
    }

    /**
     * 根据时间戳构建 {@code LocalDateTime}
     *
     * @param epochSecond
     * @return
     */
    public static LocalDateTime ofEpochSecond(int epochSecond) {
        return LocalDateTime.ofEpochSecond(epochSecond, 0, ZONE_OFFSET);
    }

    public static LocalDateTime ofEpochMilli(long milli) {
        Instant instant = Instant.ofEpochMilli(milli);
        return LocalDateTime.ofInstant(instant, ZONE_OFFSET);
    }

    /**
     * 转换为时间戳
     *
     */
    public static long toEpochMilli(LocalDateTime dateTime) {
        if (Objects.isNull(dateTime)) {
            return 0L;
        }
        ZonedDateTime zonedDateTime = dateTime.atZone(ZoneOffset.systemDefault());
        Instant instant = zonedDateTime.toInstant();
        return instant.toEpochMilli();
    }

    public static int toEpochSecond(LocalDateTime dateTime) {
        ZonedDateTime zonedDateTime = dateTime.atZone(ZoneOffset.systemDefault());
        Instant instant = zonedDateTime.toInstant();
        return (int) (instant.toEpochMilli() / 1000);
    }

    public static long toEpochMilli(LocalDate date) {
        if (Objects.isNull(date)) {
            return 0L;
        }
        return toEpochMilli(LocalDateTime.of(date, LocalTime.of(0, 0, 0)));
    }

    public static int toEpochSecond(LocalDate date) {
        return (int) (toEpochMilli(date) / 1000);
    }

    /**
     * 是否是同一天
     *
     * @param dateTime1
     * @param dateTime2
     * @return
     */
    public static boolean isSameDay(LocalDateTime dateTime1, LocalDateTime dateTime2) {
        return dateTime1.toLocalDate().isEqual(dateTime2.toLocalDate());
    }

    /**
     * 相隔天数
     *
     * @param begin
     * @param end
     * @return
     */
    public static long daysUntil(LocalDate begin, LocalDate end) {
        return ChronoUnit.DAYS.between(begin, end);
    }

    public static LocalDateTime date2LocalDateTime(Date date) {
        return date.toInstant().atZone(ZoneId.systemDefault()).toLocalDateTime();
    }

    public static Date localDateTime2Date(LocalDateTime localDateTime) {
        return Date.from(localDateTime.atZone(ZoneId.systemDefault()).toInstant());
    }

    public static boolean isSameWeek(LocalDate date1, LocalDate date2) {
        int week1 = date1.get(WEEK_FIELDS.weekOfWeekBasedYear());
        int week2 = date2.get(WEEK_FIELDS.weekOfWeekBasedYear());
        return date1.getYear() == date2.getYear()
                && date1.getMonth() == date2.getMonth()
                && week1 == week2;
    }
}
