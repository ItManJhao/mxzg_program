package com.ayjs.mxzg.common.util.time;

import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.concurrent.ConcurrentHashMap;

public class DateTimeUtil {

    // 当天零点时间戳
    private static volatile int dayBreak = 0;
    // 明天零点时间戳
    private static volatile int tomorrowBreak = 0;
    // 昨天零点时间戳
    private static volatile int yesterdayBreak = 0;

    private static final ThreadLocal<ConcurrentHashMap<String, SimpleDateFormat>> formatLocal = ThreadLocal.withInitial(ConcurrentHashMap::new);

    private static SimpleDateFormat getFormat(String format) {
        return formatLocal.get().computeIfAbsent(format, DateTimeUtil::makeSimpleDateFormat);
    }

    private static SimpleDateFormat makeSimpleDateFormat(String format) {
        SimpleDateFormat sdf = new SimpleDateFormat(format);
        sdf.getCalendar().setFirstDayOfWeek(Calendar.SUNDAY);
        return sdf;
    }

    private static synchronized void resetBreak() {
        Calendar cal = Calendar.getInstance();
        cal.set(Calendar.HOUR_OF_DAY, 0);
        cal.set(Calendar.MINUTE, 0);
        cal.set(Calendar.SECOND, 0);
        cal.set(Calendar.MILLISECOND, 0);
        int tempDayBreak = (int) (cal.getTime().getTime() / TimeConstants.ONE_SECOND_MILLIS);

        dayBreak = tempDayBreak;
        tomorrowBreak = tempDayBreak + TimeConstants.ONE_DAY_SECOND;
        yesterdayBreak = tempDayBreak - TimeConstants.ONE_DAY_SECOND;
    }

    /**
     * 获取系统当前时间戳
     *
     * @return int
     */
    public static int currentSecond() {
        return (int) (System.currentTimeMillis() / TimeConstants.ONE_SECOND_MILLIS);
    }

    /**
     * 获取系统当前时间
     *
     * @return long
     */
    public static long millisTime() {
        return System.currentTimeMillis();
    }

    /**
     * 把当前时间格式化成yyyy-MM-dd HH:mm:ss
     *
     * @return String
     */
    public static String date() {
        return date(DateFormatConstants.FORMAT_NORMAL);
    }

    /**
     * 把当前时间格式化
     *
     * @param format
     * @return String
     */
    public static String date(String format) {
        return date(format, System.currentTimeMillis());
    }

    /**
     * 把时间戳（秒）格式化成yyyy-MM-dd HH:mm:ss
     *
     * @param timestamp
     * @return String
     */
    public static String date(int timestamp) {
        return date(DateFormatConstants.FORMAT_NORMAL, timestamp);
    }

    /**
     * 把时间戳（毫秒）格式化成yyyy-MM-dd HH:mm:ss
     *
     * @param timestamp
     * @return String
     */
    public static String date(long timestamp) {
        return date(DateFormatConstants.FORMAT_NORMAL, timestamp);
    }

    /**
     * 把时间戳格式化
     *
     * @param format
     * @param timestamp 秒
     * @return String
     */
    public static String date(String format, int timestamp) {
        long l = timestamp * TimeConstants.ONE_SECOND_MILLIS;
        return date(format, l);
    }

    /**
     * 把时间戳格式化
     *
     * @param format
     * @param timestamp 毫秒
     * @return String
     */
    public static String date(String format, long timestamp) {
        return getFormat(format).format(timestamp);
    }

    /**
     * 时间转化成时间戳
     *
     * @param time
     * @return int
     */
    public static int strToTime(String time) {
        return strToTime(time, DateFormatConstants.FORMAT_NORMAL);
    }

    /**
     * 时间转化成时间戳
     *
     * @param time
     * @param format
     * @return int
     */
    public static int strToTime(String time, String format) {
        Date date = str2Date(time, format);
        return (int) (date.getTime() / TimeConstants.ONE_SECOND_MILLIS);
    }

    /**
     * 时间转化成时间戳（整日期）
     *
     * @param time
     */
    public static int strToTimeDate(String time) {
        return DateTimeUtil.strToTime(time, DateFormatConstants.FORMAT_YYYYMMDD);
    }

    /**
     * 字符串转换成日期 如果转换格式为空，则利用默认格式进行转换操作
     *
     * @param str    字符串
     * @param format 日期格式
     * @return 日期
     */
    public static Date str2Date(String str, String format) {
        if (null == str || "".equals(str)) {
            return new Date();
        }
        // 如果没有指定字符串转换的格式，则用默认格式进行转换
        if (null == format || "".equals(format)) {
            format = DateFormatConstants.FORMAT_NORMAL;
        }
        SimpleDateFormat sdf = getFormat(format);
        try {
            return sdf.parse(str);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return new Date();
    }

    /**
     * 获得今天凌晨时间戳
     *
     * @return int
     */
    public static int dayBreak() {
        // 当前时间戳大于记录的明天零点时间戳时重置零点时间戳
        int time = currentSecond();
        if (time >= tomorrowBreak || dayBreak == 0) {
            resetBreak();
        }
        return dayBreak;
    }

    /**
     * 获得当天凌晨
     *
     * @return int
     */
    public static int theDayBreak(int time) {
        Calendar cal = Calendar.getInstance();
        Date date = new Date(time * TimeConstants.ONE_SECOND_MILLIS);
        cal.setTime(date);
        cal.set(Calendar.HOUR_OF_DAY, 0);
        cal.set(Calendar.MINUTE, 0);
        cal.set(Calendar.SECOND, 0);
        return (int) (cal.getTime().getTime() / TimeConstants.ONE_SECOND_MILLIS);
    }

    /**
     * 获得昨天凌晨00:00:00 时间戳
     *
     * @return
     */
    public static int yesterdayBreak() {
        // 当前时间戳大于记录的明天零点时间戳时重置零点时间戳
        if (currentSecond() >= tomorrowBreak || yesterdayBreak == 0) {
            resetBreak();
        }
        return yesterdayBreak;
    }

    /**
     * 获得明天凌晨00:00:00 时间戳
     *
     * @return
     */
    public static int tomorrowBreak() {
        // 当前时间戳大于记录的明天零点时间戳时重置零点时间戳
        if (currentSecond() >= tomorrowBreak || tomorrowBreak == 0) {
            resetBreak();
        }
        return tomorrowBreak;
    }

    /**
     * 字符串转时间戳
     *
     * @param str         字符串
     * @param isMicrotime 是否输出毫秒
     */
    public static long str2time(String str, boolean isMicrotime) {
        return str2time(str, DateFormatConstants.FORMAT_NORMAL, isMicrotime);
    }

    /**
     * 字符串转时间戳
     *
     * @param str         字符串
     * @param format      时间格式
     * @param isMicrotime 是否输出毫秒
     */
    public static long str2time(String str, String format, boolean isMicrotime) {
        if (str == null || "".equals(str)) {
            return -1;
        }
        try {
            if (isMicrotime) {
                return getFormat(format).parse(str).getTime();
            }
            return getFormat(format).parse(str).getTime() / TimeConstants.ONE_SECOND_MILLIS;
        } catch (Exception e) {
            return -1;
        }
    }

    /**
     * 字符串转时间戳
     *
     * @param str 字符串
     */
    public static int str2time(String str) {
        return (int) str2time(str, DateFormatConstants.FORMAT_NORMAL, false);
    }

    /**
     * 字符串转时间戳
     *
     * @param str    字符串
     * @param format 时间格式
     */
    public static int str2time(String str, String format) {
        return (int) str2time(str, format, false);
    }

    /**
     * 今天某个时间点
     *
     * @param clock
     * @return int
     */
    public static int getTimeByClock(String clock) {
        String time = DateTimeUtil.date(DateFormatConstants.FORMAT_YYYY__MM__DD) + " " + clock;
        return DateTimeUtil.strToTime(time);
    }

    /**
     * 获取今天星期几,星期日返回 0
     *
     * @return int
     */
    public static int getDayOfWeek() {
        Calendar calendar = Calendar.getInstance();
        return calendar.get(Calendar.DAY_OF_WEEK) - 1;
    }

    /**
     * 获取今天星期几
     *
     * @param time
     * @return int
     */
    public static int getDayOfWeek(int time) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTimeInMillis(time * TimeConstants.ONE_SECOND_MILLIS);
        return calendar.get(Calendar.DAY_OF_WEEK) - 1;
    }

    /**
     * 获取当前整点时间戳
     *
     * @param date
     * @return
     */
    public static int getHour(Date date) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        return dayBreak() + calendar.get(Calendar.HOUR_OF_DAY) * TimeConstants.ONE_HOUR_SECOND;
    }

    /**
     * 获取下一个0点或者12点的时间戳
     *
     * @return
     */
    public static int getZeroHour() {
        int time = currentSecond();
        if (time < (dayBreak() + 43200)) {
            return dayBreak() + 43200;
        } else {
            return tomorrowBreak();
        }
    }

    /**
     * 获取输入的时间戳是当年的第几周 2012-3-13
     *
     * @param timestamp 时间戳
     * @return weekOfYear
     * @author ruan
     */
    public static int getWeekOfYear(int timestamp) {
//		int week = Integer.parseInt(date("ww", timestamp));
//		int year = Integer.parseInt(date("yyyy", timestamp));
//		int tmp = Integer.parseInt(date("MM", timestamp));
//		if (week >= 5 && tmp <= 1) {
//			year -= 1;
//		}
//		if (week == 1 && tmp == 12) {
//			year += 1;
//		}
//		return year * 100 + week;
        return Integer.parseInt(date(DateFormatConstants.FORMAT_YYYYWW, timestamp));
    }

    /**
     * 获取输入的日期戳是当年的第几周 2012-3-14
     *
     * @param str 日期字符串
     * @return weekOfYear
     * @author ruan
     */
    public static int getWeekOfYear(String str) {
        return getWeekOfYear(strToTime(str));
    }

    /**
     * 获取当前时间是当年的第几周 2012-3-14
     *
     * @return weekOfYear
     * @author ruan
     */
    public static int getWeekOfYear() {
        return getWeekOfYear(currentSecond());
    }

    /**
     * 获取当前时间是当年的第几月
     */
    public static int getMonthOfYear() {
        Calendar cal = Calendar.getInstance();
        cal.setTimeInMillis(System.currentTimeMillis());
        return cal.get(Calendar.MONTH) + 1;
    }

    /**
     * 把输入的日期转成指定的格式
     *
     * @param format1  源日期格式
     * @param date     时间
     * @param formate2 新日期格式
     * @return String
     * @author chenjy 2012-3-28
     */
    public static String dateChangeFormat(String format1, int date, String formate2) {
        SimpleDateFormat sdf = getFormat(format1);
        Date fact = null;
        try {
            fact = sdf.parse(String.valueOf(date));
        } catch (ParseException e) {
            e.printStackTrace();
        }
        SimpleDateFormat sdfnew = getFormat(formate2);
        return sdfnew.format(fact);
    }

    /**
     * 获取两个日期相隔天数
     *
     * @param day1 例:2012-04-10
     * @param day2 例:2012-04-15
     * @return 相隔天数
     */
    public static int apartDay(String day1, String day2) {
        int apartSecond = DateTimeUtil.strToTime(day1, DateFormatConstants.FORMAT_YYYYMMDD) - DateTimeUtil.strToTime(day2, DateFormatConstants.FORMAT_YYYYMMDD);
        return Math.abs(apartSecond / TimeConstants.ONE_DAY_SECOND);
    }

    /**
     * 获取两个时间相隔天数
     *
     * @param timestamp1 时间戳
     * @param timestamp2
     * @return 相隔天数
     */
    public static int apartDay(int timestamp1, int timestamp2) {
        SimpleDateFormat sdf = getFormat(DateFormatConstants.FORMAT_YYYY__MM__DD);
        String day1 = DateTimeUtil.date(DateFormatConstants.FORMAT_YYYY__MM__DD, timestamp1);
        String day2 = DateTimeUtil.date(DateFormatConstants.FORMAT_YYYY__MM__DD, timestamp2);
        int days = 0;
        try {
            days = (int) ((sdf.parse(day1).getTime() - sdf.parse(day2).getTime()) / TimeConstants.ONE_DAY_MILLIS);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return Math.abs(days);
    }

    /**
     * 获取两个时间相隔天数
     *
     * @param timestamp1 时间戳
     * @param timestamp2
     * @return 相隔天数
     */
    public static int apartDayBi(int timestamp1, int timestamp2) {
        SimpleDateFormat sdf = getFormat(DateFormatConstants.FORMAT_YYYY__MM__DD);
        String day1 = DateTimeUtil.date(DateFormatConstants.FORMAT_YYYY__MM__DD, timestamp1);
        String day2 = DateTimeUtil.date(DateFormatConstants.FORMAT_YYYY__MM__DD, timestamp2);
        int days = -1;
        try {
            days = (int) ((sdf.parse(day1).getTime() - sdf.parse(day2).getTime()) / TimeConstants.ONE_DAY_MILLIS);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return days;
    }

    /**
     * 获取下一天 的日期
     *
     * @param ymd 例:2012-04-10
     * @return 20120411 错误则返回null
     */
    public static Integer tomorrowDay(Integer ymd) {
        SimpleDateFormat sdf = getFormat(DateFormatConstants.FORMAT_YYYYMMDD);
        Integer tomorrowYmd = null;
        try {
            tomorrowYmd = parseInt(sdf.format(new Date(sdf.parse(ymd.toString()).getTime() + TimeConstants.ONE_DAY_MILLIS) // 加一天
            ));
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return tomorrowYmd;
    }

    /**
     * 把当前时间格式化
     *
     * @return int (yyyyMMdd)
     */
    public static int today() {
        String format = DateFormatConstants.FORMAT_YYYYMMDD;
        return parseInt(date(format, System.currentTimeMillis()));
    }

    /**
     * 把当前时间格式化
     *
     * @return int (yyyyMMdd)
     */
    public static int timeYmd(int time) {
        String format = DateFormatConstants.FORMAT_YYYYMMDD;
        return parseInt(date(format, time));
    }

    /**
     * 把明天时间格式化
     *
     * @return int (yyyyMMdd)
     */
    public static int tomorrow() {
        return parseInt(date(DateFormatConstants.FORMAT_YYYYMMDD, tomorrowBreak()));
    }

    /**
     * 昨天的时间yyyyMMdd
     *
     * @return
     */
    public static int yesterday() {
        return parseInt(date(DateFormatConstants.FORMAT_YYYYMMDD, yesterdayBreak()));
    }


    /**
     * 把字符串时间转成map，方便使用
     *
     * @param s
     * @return HashMap
     */
    public static HashMap<String, Integer> strTimeToMap(String s) {
        HashMap<String, Integer> map = new HashMap<String, Integer>();

        String[] arr = s.split(" ");
        if (arr.length > 1) {
            map.put("week", Integer.parseInt(arr[0]));
            String[] arrHms = arr[1].split(":");
            map.put("hour", Integer.parseInt(arrHms[0]));
            map.put("minute", Integer.parseInt(arrHms[1]));
            map.put("second", Integer.parseInt(arrHms[2]));
        } else if (arr.length == 1) {
            String[] arrHms = arr[0].split(":");
            map.put("hour", Integer.parseInt(arrHms[0]));
            map.put("minute", Integer.parseInt(arrHms[1]));
            map.put("second", Integer.parseInt(arrHms[2]));
        }
        return map;
    }

    /**
     * 计算一个时间段相隔多少秒
     *
     * @param hm 12:00-13:00
     * @author ruan 2012-9-4
     */
    public static int timeDiff(String hm) {
        // 思路:12:00-13:00，把它拆分成 小时*60 + 分钟 ，算出时间段内相差多少分钟
        // 然后再转化成秒
        String[] time = hm.split("-");
        String[] minArr1 = time[0].split(":");
        String[] minArr2 = time[1].split(":");
        return (Integer.parseInt(minArr2[0]) * 60 + Integer.parseInt(minArr2[1]) - Integer.parseInt(minArr1[0]) * 60 - Integer.parseInt(minArr1[1])) * 60;
    }

    /**
     * 转换
     *
     * @param obj
     * @return
     * @throws NumberFormatException
     */
    private static int parseInt(Object obj) {
        return (int) Double.parseDouble(obj.toString());
    }

    /**
     * 是否处于该时间段
     *
     * @param begin 开始时间 格式:d hh:mm:ss
     * @param end   结束时间 格式:d hh:mm:ss
     * @return true or false
     * @bug "1 21:00:00", "1 20:30:00" 返回true
     */
    public static boolean isInPeriod(String begin, String end) {
        int tmp = end.compareTo(begin);
        if (tmp == 0) { // 时间相同，一定无法开启
            return false;
        }

        HashMap<String, Integer> b = strTimeToMap(begin);
        HashMap<String, Integer> e = strTimeToMap(end);

        boolean haveWeek = b.containsKey("week") && e.containsKey("week");
        int n = 0;
        if (haveWeek) {
            n = DateTimeUtil.getDayOfWeek() - b.get("week");
            if (n < 0) {
                n = 7 + n;
            }
        }

        Calendar calendarBegin = Calendar.getInstance();
        if (haveWeek) {
            calendarBegin.add(Calendar.DATE, -n);
        }
        calendarBegin.set(Calendar.HOUR_OF_DAY, b.get("hour"));
        calendarBegin.set(Calendar.MINUTE, b.get("minute"));
        calendarBegin.set(Calendar.SECOND, b.get("second"));

        if (haveWeek) {
            int weekTmp = DateTimeUtil.getDayOfWeek((int) (calendarBegin.getTimeInMillis() / TimeConstants.ONE_SECOND_MILLIS)); // 获取开始时间是星期几
            n = e.get("week") - weekTmp;
            if (n < 0) {
                n = 7 + n;
            } else if (n == 0) {
                if (tmp < 0) {
                    n = 7 + n;
                }
            }
        }

        Calendar calendarEnd = Calendar.getInstance();
        calendarEnd.setTimeInMillis(calendarBegin.getTimeInMillis());
        if (haveWeek) {
            calendarEnd.add(Calendar.DATE, n);
        }
        calendarEnd.set(Calendar.HOUR_OF_DAY, e.get("hour"));
        calendarEnd.set(Calendar.MINUTE, e.get("minute"));
        calendarEnd.set(Calendar.SECOND, e.get("second"));

        long now = Calendar.getInstance().getTimeInMillis();

        if (now < calendarBegin.getTimeInMillis() || now > calendarEnd.getTimeInMillis()) {
            return false;
        }
        return true;
    }

    /**
     * 寻找最合适的单位来显示时间
     *
     * @param time
     * @return
     * @author ruan 2013-7-21
     */
    public static String showTime(long time) {
        String str = "";
        if (time > 0 && time <= 1000) {
            str = time + " ns";
        } else if (time > 1000 && time <= 1000000) {
            str = new DecimalFormat("0.00").format(time / 1000.0) + " μs";
        } else if (time > 1000000 && time <= 1000000000) {
            str = new DecimalFormat("0.00").format(time / 1000000.0) + " ms";
        } else {
            str = new DecimalFormat("0.00").format(time / 1000000000.0) + " s";
        }
        return str;
    }

    /**
     * 寻找最合适的单位来显示时间
     *
     * @param time
     * @return
     * @author ruan
     */
    public static String showTimeStr(int time) {
        StringBuilder str = new StringBuilder();
        int day = time / TimeConstants.ONE_DAY_SECOND;
        time = time - TimeConstants.ONE_DAY_SECOND * day;
        if (day > 0) {
            str.append(day);
            str.append(" d ");
        }
        int hour = time / TimeConstants.ONE_HOUR_SECOND;
        time = time - TimeConstants.ONE_HOUR_SECOND * hour;
        if (hour > 0) {
            str.append(hour);
            str.append(" h ");
        }
        int minute = time / TimeConstants.ONE_MINUTE_SECOND;
        time = time - TimeConstants.ONE_MINUTE_SECOND * minute;
        if (minute > 0) {
            str.append(minute);
            str.append(" m ");
        }
        int second = time;
        if (second > 0) {
            str.append(second);
            str.append(" s ");
        }
        return str.toString().trim();
    }

    /**
     * 将剩余秒数格式化显示
     * @param allSeconds
     * @return
     */
    public static String toDhmsStyle(long allSeconds) {
        String DateTimes = null;

        long days = allSeconds / (60 * 60 * 24);
        long hours = (allSeconds % (60 * 60 * 24)) / (60 * 60);
        long minutes = (allSeconds % (60 * 60)) / 60;
        long seconds = allSeconds % 60;

        if (days > 0) {
            DateTimes = days + "天" + hours + "时" + minutes + "分" + seconds + "秒";
        } else if (hours > 0) {
            DateTimes = hours + "时" + minutes + "分" + seconds + "秒";
        } else if (minutes > 0) {
            DateTimes = minutes + "分" + seconds + "秒";
        } else {
            DateTimes = seconds + "秒";
        }

        return DateTimes;
    }

    /**
     * 获取特定时分的时间戳
     *
     * @param hourMinute 1200(标示12:00) 1330(标示13:30)
     * @return
     * @author tangyangbo 2014-2-11
     */
    public static int customTime(int hourMinute) {
        // 获取今天日期时间
        String nowTime = DateTimeUtil.date(DateFormatConstants.FORMAT_YYYY__MM__DD) + " " + hourMinute / 100 + ":" + hourMinute % 100 + ":00";
        return DateTimeUtil.strToTime(nowTime); // 转化时间戳
    }

    public static int customTime(String hourMinute) {
        return customTime(Integer.parseInt(hourMinute));
    }

    /**
     * 将时间戳转为整形日期
     *
     * @param timestamp
     * @return
     */
    public static int timestampToDateInteger(int timestamp) {
        String dateString = DateTimeUtil.date(DateFormatConstants.FORMAT_YYYYMMDD, timestamp);
        return Integer.parseInt(dateString); // 将日期字符串转为int;
    }

    /**
     * 获取当天yyyyMMdd的int类型时间
     *
     * @return
     */
    public static int getTodayYmd() {
        String dateString = date(DateFormatConstants.FORMAT_YYYYMMDD);
        return Integer.parseInt(dateString);
    }

    /**
     * 获取昨天yyyyMMdd的int类型时间
     *
     * @return
     */
    public static int getYesterdayInt() {
        String dateString = date(DateFormatConstants.FORMAT_YYYYMMDD, System.currentTimeMillis() - TimeConstants.ONE_DAY_MILLIS);
        return Integer.parseInt(dateString);
    }

    /**
     * 获取与今天相差指定天数的yyyyMMdd的int类型时间
     *
     * @param diffDay 相差的天数
     * @return
     */
    public static int getDiffDayInt(int diffDay) {
        String dateString = date(DateFormatConstants.FORMAT_YYYYMMDD, System.currentTimeMillis() + TimeConstants.ONE_DAY_MILLIS * diffDay);
        return Integer.parseInt(dateString);
    }

    /**
     * 将14:14:14这样的格式转化为秒数
     *
     * @param time
     * @return
     */
    public static int timeToSecond(String time) {
        int second = 0;
        String[] value = time.split(":");
        if (value.length != 3) {
            throw new RuntimeException("not time format");
        }
        second += Integer.parseInt(value[0]) * 60 * 60;
        second += Integer.parseInt(value[1]) * 60;
        second += Integer.parseInt(value[2]);
        return second;
    }

    /**
     * 获得某一时间的几点几分
     *
     * @param theDateTime 需要计算的时间
     */
    public static int getDateForHourAndMinute(int theDateTime, int hour, int minute) {
        if (theDateTime <= 0) {
            return 0;
        }
        Calendar cal = Calendar.getInstance();
        long time = theDateTime * TimeConstants.ONE_SECOND_MILLIS;
        cal.setTime(new Date(time));
        Date newTime = new GregorianCalendar(cal.get(Calendar.YEAR), cal.get(Calendar.MONTH), cal.get(Calendar.DAY_OF_MONTH), hour, minute).getTime();
        return (int) (newTime.getTime() / TimeConstants.ONE_SECOND_MILLIS);
    }

    /**
     * 判断两个时间是不是同一天
     *
     * @param time1
     * @param time2
     * @return
     */
    public static boolean isSameDate(int time1, int time2) {
        Calendar cal = Calendar.getInstance();
        cal.setTime(new Date(time1 * TimeConstants.ONE_SECOND_MILLIS));
        int year1 = cal.get(Calendar.YEAR);
        int month1 = cal.get(Calendar.MONTH);
        int date1 = cal.get(Calendar.DAY_OF_YEAR);

        cal.setTime(new Date(time2 * TimeConstants.ONE_SECOND_MILLIS));
        int year2 = cal.get(Calendar.YEAR);
        int month2 = cal.get(Calendar.MONTH);
        int date2 = cal.get(Calendar.DAY_OF_YEAR);

        return year1 == year2 && month1 == month2 && date1 == date2;
    }

    public static int getHour(long time) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTimeInMillis(time);
        return calendar.get(Calendar.HOUR_OF_DAY);
    }

    /**
     * 获取任意一个时间点当天的零时时间
     *
     * @param theDay
     * @return
     */
    public static long getSomedayZeroTime(long theDay) {
        return theDay - (getHour(theDay) * TimeConstants.ONE_HOUR_MILLIS + theDay % TimeConstants.ONE_HOUR_MILLIS);
    }

    /**
     * 返回未来最近的指定星期数且钟点数的时间戳
     *
     * @param week 1- 7
     * @param time 0 - 23
     * @return
     */
    public static int getNearWeekTime(int week, int time) {
        int resultTime = 0;
        int todayWeek = DateTimeUtil.getDayOfWeek();
        if (todayWeek == week) {
            resultTime = DateTimeUtil.dayBreak();
        } else {
            int day = todayWeek - week;
            day = day > 0 ? day : day + 7;
            resultTime = DateTimeUtil.dayBreak() - day * 60 * 60 * 24;
        }
        resultTime += 60 * 60 * time;
        return resultTime;
    }


    /**
     * 获取当前星期几
     *
     * @return
     * 注意:因为jdk中把周日定为一周的第一天,返回值为当前星期几，现在稍作处理(例：星期一返回“1”，星期天返回“7”，这样返回便于理解!)
     */
    public static int getDayOfWeek_() {
        Calendar calendar = Calendar.getInstance();
        int nowWeek = calendar.get(Calendar.DAY_OF_WEEK);
        if (nowWeek == 1) {//如果是星期天返回7
            return 7;
        }
        return nowWeek - 1;
    }

    /**
     * 验证两个时间是否为同一天
     *
     * @param time1
     * @param time2
     * @return
     */
    public static boolean isSameDay(long time1, long time2) {
        Calendar calendar1 = Calendar.getInstance();
        calendar1.setTimeInMillis(time1);
        Calendar calendar2 = Calendar.getInstance();
        calendar2.setTimeInMillis(time2);

        return calendar1.get(Calendar.YEAR) == calendar2.get(Calendar.YEAR)
                && calendar1.get(Calendar.MONTH) == calendar2.get(Calendar.MONTH)
                && calendar1.get(Calendar.DATE) == calendar2.get(Calendar.DATE);
    }

    public static void main(String[] args) {
        System.out.println(getDayOfWeek_());
        System.out.println(date("HH:mm"));
        
        System.out.println(weekMondayBreakMillis());
    }

    /**
     * 周日零点
     * @return
     */
    public static long weekSundayBreakMillis() {
    	Calendar cal = Calendar.getInstance();
    	int thisWeek = cal.get(Calendar.WEEK_OF_YEAR);
    	cal.set(Calendar.WEEK_OF_YEAR, thisWeek);
    	cal.set(Calendar.DAY_OF_WEEK, 1);
    	cal.set(Calendar.HOUR_OF_DAY, 0);
        cal.set(Calendar.MINUTE, 0);
        cal.set(Calendar.SECOND, 0);
        cal.set(Calendar.MILLISECOND, 0);
    	return cal.getTimeInMillis();
    }
    /**
     * 周一零点
     * @return
     */
    public static long weekMondayBreakMillis() {
    	Calendar cal = Calendar.getInstance();
    	int thisWeek = cal.get(Calendar.WEEK_OF_YEAR);
    	cal.set(Calendar.WEEK_OF_YEAR, thisWeek);
    	cal.set(Calendar.DAY_OF_WEEK, 2);
    	cal.set(Calendar.HOUR_OF_DAY, 0);
        cal.set(Calendar.MINUTE, 0);
        cal.set(Calendar.SECOND, 0);
        cal.set(Calendar.MILLISECOND, 0);
    	return cal.getTimeInMillis();
    }
}
