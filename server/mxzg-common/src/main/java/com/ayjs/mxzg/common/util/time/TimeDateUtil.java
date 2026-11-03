package com.ayjs.mxzg.common.util.time;

import cn.hutool.core.date.DateUtil;
import com.ayjs.mxzg.common.util.gson.GsonUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * 时间日期工具类
 */
public class TimeDateUtil {
    private static Logger logger = LoggerFactory.getLogger(Logger.class);
    public static DateFormat FORMAT_D = new SimpleDateFormat("yyyy-MM-dd");
    public static DateFormat FORMAT_YYMMDD = new SimpleDateFormat("yyyyMMdd");
    public static DateFormat FORMAT_YYMMDDHH = new SimpleDateFormat("yyyyMMddHH");
    public static DateFormat FORMAT_YYMMDD_HHMMSS = new SimpleDateFormat(
            "yyyy-MM-dd HH:mm:ss");
    public static DateFormat FORMAT_HHMMSS = new SimpleDateFormat("HH:mm:ss");
    public static DateFormat FORMAT_HHMM = new SimpleDateFormat("HH:mm");


    /**
     * 一天的时间
     */
    public static final int ONEDAY = 3600 * 24 * 1000;
    public static final int ONEDAYINT = 3600 * 24;
    /**
     * 一周的时间
     */
    public static final int ONEWEEK = 3600 * 24 * 1000 * 7;
    public static final int ONEWEEKINT = 3600 * 24 * 7;


    public static final int ONEHOUR = 3600 * 1000;
    public static final int ONEHOURINT = 3600;

    /**
     * 12个小时
     */
    public static final int TWELVE = 3600 * 12 * 1000;
    /**
     * 分钟
     */
    public static final int ONEMIN = 60 * 1000;
    public static final int ONEMININT = 60;
    /**
     * 秒
     */

    public static final int ONESECOND = 1000;
    public static final int ONESECONDINT = 1;
    /**
     * 七天时间
     */
    public static final int SEVEN_DAYS_TIME = 7 * 3600 * 24;

    public static final long SEVEN_DAYS_TIME_LONG = 7 * 3600 * 24 * 1000;

    /**
     * 十天时间
     */
    public static final int TEN_DAYS_TIME = 10 * 3600 * 24;

    /**
     * 获取当前时间戳(毫秒)
     *
     * @return
     * @name getCurrentTime
     */
    public static long getCurrentTime() {
        return System.currentTimeMillis();
    }

    /**
     * 获取当前时间戳(分)
     *
     * @return
     * @name getCurrentTime
     */
    public static long getCurrentTimeMinute() {
        return System.currentTimeMillis() / 60000;
    }

    /**
     * 获取当前时间戳(时)
     *
     * @return
     * @name getCurrentTime
     */
    public static long getCurrentTimehour() {
        return System.currentTimeMillis() / 3600000;
    }

    /**
     * 获取当前时间戳(秒)
     *
     * @return
     * @name getCurrentTime
     */
    public static int getCurrentTimeInt() {
        return (int) (System.currentTimeMillis() / 1000);
    }

    /**
     * 将毫秒转化为秒
     *
     * @param time
     * @return
     */
    public static int getCurrentTimeInt(long time) {
        return (int) (time / 1000);
    }

    /**
     * 获取今天零时的时间
     *
     * @return 零时以long类型返回的数值
     */
    public static long getTodayZeroTime() {
        long now = System.currentTimeMillis();
        return now - (getHour() * ONEHOUR + now % ONEHOUR);
    }

    /**
     * 获取本周零时时间(周一)
     *
     * @return
     */
    public static long getWeekZeroTime() {
        Calendar calendar = Calendar.getInstance();
        calendar.set(Calendar.MINUTE, 0);
        calendar.set(Calendar.SECOND, 0);
        calendar.set(Calendar.HOUR_OF_DAY, 0);
        calendar.set(Calendar.MILLISECOND, 0);
        calendar.set(Calendar.DAY_OF_WEEK, 2);
        return calendar.getTimeInMillis();
    }

    /**
     * 周日是一周的开始
     *
     * @return
     */
    public static int getWeekZeroTimeInt() {
        return (int) (getWeekZeroTime() / 1000);
    }

    public static long getWeekZeroMondayAsFirstDay() {
        return DateUtil.beginOfWeek(DateUtil.calendar(new Date()), true).getTime().getTime();
    }

    /**
     * 周一是一周的开始
     *
     * @return
     */
    public static int getWeekZeroMondayAsFirstDayInt() {
        return (int) (getWeekZeroMondayAsFirstDay() / 1000);
    }

    public static long getSundayZero() {
        Calendar calendar = Calendar.getInstance();
        calendar.set(Calendar.MINUTE, 0);
        calendar.set(Calendar.SECOND, 0);
        calendar.set(Calendar.HOUR_OF_DAY, 0);
        calendar.set(Calendar.MILLISECOND, 0);
        calendar.set(Calendar.DAY_OF_WEEK, 1);
        return calendar.getTimeInMillis();
    }

    public static int getSundayZeroInt() {
        return (int) (getSundayZero() / 1000);
    }

    public static int getNextWeekZeroTimeInt() {
        return getWeekZeroMondayAsFirstDayInt() + ONEDAYINT * 7;
    }

    /**
     * 时间是否在当前周【周一00:00:00，周日23:59:59】
     *
     * @param time
     * @return
     */
    public static boolean isCurrentWeek(int time) {
        if (time < getWeekZeroMondayAsFirstDayInt() || time >= getNextWeekZeroTimeInt()) {
            return false;
        }
        return true;
    }

    /**
     * 获取本周星期几的零时时间
     *
     * @param week
     * @return
     */
    public static long getWeekZeroTime(int week) {
        Calendar calendar = Calendar.getInstance();
        calendar.set(Calendar.MINUTE, 0);
        calendar.set(Calendar.SECOND, 0);
        calendar.set(Calendar.HOUR_OF_DAY, 0);
        calendar.set(Calendar.MILLISECOND, 0);
        calendar.set(Calendar.DAY_OF_WEEK, week);
        return calendar.getTimeInMillis();
    }


    /**
     * 获取月月底时间
     *
     * @param
     * @return
     */
    public static long getMonthEndTime() {
        Calendar calendar = Calendar.getInstance();
        calendar.set(Calendar.MONTH, calendar.get(Calendar.MONTH) + 1);
        calendar.set(Calendar.DAY_OF_MONTH, 1);
        calendar.set(Calendar.HOUR_OF_DAY, 0);
        calendar.set(Calendar.MINUTE, 0);
        calendar.set(Calendar.SECOND, 0);
        calendar.set(Calendar.MILLISECOND, 0);
        return calendar.getTimeInMillis();
    }

    /**
     * 获取月初0点时间
     *
     * @param
     * @return
     */
    public static long getMonthZeroTime() {
        Calendar calendar = Calendar.getInstance();
        calendar.set(Calendar.MONTH, calendar.get(Calendar.MONTH));
        calendar.set(Calendar.DAY_OF_MONTH, 1);
        calendar.set(Calendar.HOUR_OF_DAY, 0);
        calendar.set(Calendar.MINUTE, 0);
        calendar.set(Calendar.SECOND, 0);
        calendar.set(Calendar.MILLISECOND, 0);
        return calendar.getTimeInMillis();
    }

    public static int getMonthZeroTimeInt() {
        return (int) (getMonthZeroTime() / 1000);
    }

    /**
     * 获取下一个月初0点时间
     *
     * @return
     */
    public static long getNextMonthZeroTime() {
        Calendar calendar = Calendar.getInstance();
        calendar.set(Calendar.MONTH, calendar.get(Calendar.MONTH) + 1);
        calendar.set(Calendar.DAY_OF_MONTH, 1);
        calendar.set(Calendar.HOUR_OF_DAY, 0);
        calendar.set(Calendar.MINUTE, 0);
        calendar.set(Calendar.SECOND, 0);
        calendar.set(Calendar.MILLISECOND, 0);
        return calendar.getTimeInMillis();
    }

    public static int getNextMonthZeroTimeInt() {
        return (int) (getNextMonthZeroTime() / 1000);
    }


    /**
     * 获取明天零时的时间
     *
     * @return 零时以long类型返回的数值
     */
    public static long getTomorrowZeroTime() {
        long zeroTime = getTodayZeroTime();
        zeroTime += ONEDAY;
        return zeroTime;
    }

    /**
     * 获取昨天零时的时间
     *
     * @return 零时以int类型返回的数值
     */
    public static int getYesterdayZeroTime() {
        long zeroTime = getTodayZeroTime();
        zeroTime = zeroTime - ONEDAY;
        return (int) (zeroTime / 1000);
    }

    /**
     * 获取昨天零时的时间
     *
     * @return 零时以long类型返回的数值
     */
    public static long getYesterdayZeroTimeLong() {
        long zeroTime = getTodayZeroTime();
        zeroTime = zeroTime - ONEDAY;
        return zeroTime;
    }

    /**
     * 获取任意一个时间点当天的零时时间
     *
     * @param theDay
     * @return
     */
    public static long getSomedayZeroTime(long theDay) {
        return theDay - (getHour(theDay) * ONEHOUR + theDay % ONEHOUR);
    }

    /**
     * 获取任意一个时间点当天的零时时间
     *
     * @param theDay
     * @return
     */
    public static int getSomedayZeroInt(int theDay) {
        return theDay - (getHour(theDay * 1000l) * ONEHOURINT + theDay % ONEHOURINT);
    }

    /**
     * 获取任意一个时间点当天是第几天
     *
     * @param theDay
     * @return
     */
    public static int getWillDayTime(long theDay) {
        return (int) ((getTodayZeroTime() - getSomedayZeroTime(theDay)) / ONEDAY) + 1;
    }

    /**
     * 获取今天零时的时间
     *
     * @return 零时以int类型返回的数值
     */
    public static int getTodayZeroTimeInt() {
        long todayZeroTime = getTodayZeroTime();
        return (int) (todayZeroTime / 1000);
    }

    /**
     * 获取明天零时的时间
     *
     * @return 零时以int类型返回的数值
     */
    public static int getTomorrowZeroTimeInt() {
        long tomorrowZeroTime = getTomorrowZeroTime();
        return (int) (tomorrowZeroTime / 1000);
    }

    private static int getHour(long time) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTimeInMillis(time);
        return calendar.get(Calendar.HOUR_OF_DAY);
    }

    public static int getHour() {
        return Calendar.getInstance().get(Calendar.HOUR_OF_DAY);
    }

    public static String time2String(long time) {
        return FORMAT_YYMMDD_HHMMSS.format(new Date(time));
    }

    public static String time2String(long time, DateFormat format) {
        Date date = new Date(time);
        String printData = format.format(date);
        return printData;
    }

    /**
     * 获取时间(日 为单位：(格式:20130601)）
     *
     * @param time
     * @return
     */
    public static int getTimeInt(long time) {
        return Integer.valueOf(FORMAT_YYMMDD.format(new Date(time)));
    }

    /**
     * 字符串转换成日期格式
     *
     * @param dateString 待转换的日期字符串
     * @param format     日期格式
     * @return 转换后的日期
     */
    public static Date string2Date(String dateString, DateFormat format) {
        if (dateString == null || dateString.trim().length() == 0) {
            return new Date();
        }
        try {
            return format.parse(dateString);
        } catch (Exception e) {
            logger.error("字符串时间格式错误:" + dateString);
        }
        return new Date();
    }

    public static long stringToTime(String dateStr, DateFormat format) {
        Calendar calendar = Calendar.getInstance();
        Date date = null;
        try {
            date = TimeDateUtil.FORMAT_D.parse(dateStr);
        } catch (ParseException e) {
            date = new Date();
        }
        calendar.setTime(date);
        return calendar.getTimeInMillis();
    }

    /**
     * 日期字符串转化为毫秒数
     *
     * @param dateStr
     * @return
     */
    public static long stringToTime(String dateStr) {
        try {
            Date date = TimeDateUtil.FORMAT_YYMMDD_HHMMSS.parse(dateStr);
            return date.getTime();
        } catch (ParseException e) {
            return getCurrentTime();
        }
    }

    /**
     * 获取下个小时的整点时间
     *
     * @return
     */
    public static long getNextHourTime() {
        Calendar calendar = Calendar.getInstance();
        calendar.set(Calendar.MILLISECOND, 0);
        calendar.set(Calendar.MINUTE, 0);
        calendar.set(Calendar.SECOND, 0);
        calendar.add(Calendar.HOUR, 1);
        return calendar.getTimeInMillis();
    }


    public static long getCurrentHourTime() {
        Calendar calendar = Calendar.getInstance();
        calendar.set(Calendar.MILLISECOND, 0);
        calendar.set(Calendar.MINUTE, 0);
        calendar.set(Calendar.SECOND, 0);
        calendar.add(Calendar.HOUR, 0);
        return calendar.getTimeInMillis();
    }


    /**
     * 获取下个小时多少分钟整时间
     *
     * @return
     */
    public static long getNextMinTime(int minute) {
        Calendar calendar = Calendar.getInstance();
        calendar.set(Calendar.MILLISECOND, 0);
        calendar.set(Calendar.MINUTE, minute);
        calendar.set(Calendar.SECOND, 0);
        calendar.add(Calendar.HOUR, 1);
        return calendar.getTimeInMillis();
    }

    /**
     * 获取下个当前多少分钟整时间
     *
     * @return
     */
    public static long getMinTime(int minute) {
        Calendar calendar = Calendar.getInstance();
        calendar.set(Calendar.MILLISECOND, 0);
        calendar.set(Calendar.MINUTE, minute);
        calendar.set(Calendar.SECOND, 0);
        calendar.add(Calendar.HOUR, 0);
        return calendar.getTimeInMillis();
    }

    /**
     * 获取指定时间在当年的月份
     *
     * @return
     */
    public static int getMonthOfYear(long time) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTimeInMillis(time);
        return calendar.get(Calendar.MONTH) + 1;
    }

    /**
     * 获取指定时间是当月的第几天
     *
     * @return
     */
    public static int getDayOfMonth(long time) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTimeInMillis(time);
        return calendar.get(Calendar.DAY_OF_MONTH);
    }

    /**
     * 获取指定时间是当月的第几天
     *
     * @return
     */
    public static int getDayOfYear(long time) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTimeInMillis(time);
        return calendar.get(Calendar.DAY_OF_YEAR);
    }

    /**
     * 获取指定时间是当周的第几天
     *
     * @return
     */
    public static int getDayOfWeek(long time) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTimeInMillis(time);
        int result = calendar.get(Calendar.DAY_OF_WEEK) - 1;
        if (result == 0) {
            result = 7;
        }
        return result;
    }

    /**
     * 获取星期几
     *
     * @return
     */
    public static int getDayOfWeek() {
        Calendar calendar = Calendar.getInstance();
        int result = calendar.get(Calendar.DAY_OF_WEEK) - 1;
        if (result == 0) {
            result = 7;
        }
        return result;
    }

    /**
     * 获取指定时间是在哪一年
     *
     * @param time
     * @return
     */
    public static int getYear(long time) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTimeInMillis(time);
        return calendar.get(Calendar.YEAR);
    }

    /**
     * 当前时间是否在某一时间段内，用于检测活动时间的开始与结束 如钓鱼活动在每日的13:00开始，13:30结束，那么函数的调用就是 startTime
     * = 13 * TimeDateUtil.ONEHOUR = 13:00 endTime = 13 * TimeDateUtil.ONEHOUR +
     * 30 * TimeDateUtil.ONEMIN = 13:30
     *
     * @param startTime
     * @param endTime
     * @return
     */
    public static boolean isCurrentTimeBetween(long startTime, long endTime) {
        long currentTime = TimeDateUtil.getCurrentTime();
        long todayStartTime = TimeDateUtil.getTodayZeroTime() + startTime;
        long todayEndTime = TimeDateUtil.getTodayZeroTime() + endTime;
        if (currentTime >= todayStartTime && currentTime <= todayEndTime) {
            return true;
        }
        return false;
    }

    /**
     * 获取当月的天数
     *
     * @return
     */
    public static int getDayCountOfThisMonth() {
        Calendar calendar = Calendar.getInstance();
        calendar.set(Calendar.DATE, 1);
        calendar.roll(Calendar.DATE, -1);
        return calendar.get(Calendar.DATE);
    }

    /**
     * @param year
     * @param month {link=Calendar}
     * @param date
     * @return
     */
    public static long getDateLongZeroTime(int year, int month, int date) {
        Calendar calendar = Calendar.getInstance();
        calendar.set(year, month, date);
        return TimeDateUtil.getSomedayZeroTime(calendar.getTimeInMillis());
    }

    public static int getDateIntZeroTime(int year, int month, int date) {
        return (int) (getDateLongZeroTime(year, month, date) / 1000);
    }

    /**
     * 获取多少天的时间
     *
     * @param day 天数
     * @return
     */
    public static int getDayTimeInt(int day) {
        return day * 3600 * 24;
    }

    public static long getNextTime(int[] hours) {
        long currentTime = getCurrentTime();
        //天的偏移量
        int dayOffset = 0;
        long nextRefreshTime = 0;

        long todayZeroTime = getTodayZeroTime();

        while (nextRefreshTime < currentTime) {
            for (int time : hours) {
                nextRefreshTime = todayZeroTime + dayOffset * ONEDAY + time * ONEHOUR;
                if (nextRefreshTime > currentTime) {
                    break;
                }
            }
            dayOffset++;
        }
        return nextRefreshTime;
    }

    public static long getNextWeekZeroTime() {
        Calendar calendar = Calendar.getInstance();
        calendar.set(Calendar.MINUTE, 0);
        calendar.set(Calendar.SECOND, 0);
        calendar.set(Calendar.HOUR_OF_DAY, 0);
        calendar.set(Calendar.MILLISECOND, 0);
        calendar.set(Calendar.DAY_OF_WEEK, 2);
        calendar.add(Calendar.DATE, 7);
        return calendar.getTimeInMillis();
    }

    /**
     * 根据hh:mm:ss获取时长
     *
     * @param hhmmss
     * @return
     */
    public static long getTimeDuration(String hhmmss) {
        String[] strs = hhmmss.split(":");
        long time = 0;
        for (int i = strs.length - 1; i >= 0; i--) {
            Integer ti = 0;
            try {
                ti = Integer.parseInt(strs[i]);
            } catch (Exception e) {
            }
            time += ti * Math.pow(60, strs.length - 1 - i);
        }
        return time * 1000;
    }

    /**
     * 获取当前日期的几天前或几天后日期
     *
     * @return
     */
    public static String getCurrentBeforeNum(int num) {
        Calendar cal = Calendar.getInstance();
        cal.setTime(new Date());
        cal.add(Calendar.DATE, num);
        Date date = cal.getTime();
        return FORMAT_YYMMDD_HHMMSS.format(date);
    }

    /**
     *  
     *  根据当前日期获得上周的日期区间（上周周一和周日日期） 
     */
    public static Map<String, String> getLastTimeInterval(Date date) {
        Calendar calendar1 = Calendar.getInstance();
        Calendar calendar2 = Calendar.getInstance();
        calendar1.setTime(date);
        calendar2.setTime(date);
        int dayOfWeek = calendar1.get(Calendar.DAY_OF_WEEK) - 1;
        if (dayOfWeek <= 0) {
            dayOfWeek = 7;
        }
        int offset1 = 1 - dayOfWeek;
        int offset2 = 8 - dayOfWeek;
        calendar1.add(Calendar.DATE, offset1 - 7);
        calendar2.add(Calendar.DATE, offset2 - 7);
        // last Monday
        String lastBeginDate = FORMAT_YYMMDD_HHMMSS.format(calendar1.getTime());
        // last Sunday  
        String lastEndDate = FORMAT_YYMMDD_HHMMSS.format(calendar2.getTime());
        Map<String, String> map = new HashMap<>();
        map.put("lastBeginDate", lastBeginDate);
        map.put("lastEndDate", lastEndDate);
        return map;
    }

    /**
     *  
     *  根据当前日期获得上周的时间戳区间（上周周一和周日日期） 
     */
    public static Map<String, Integer> getTimeStampInterval(Date date) {
        Map<String, String> lastTimeMap = getLastTimeInterval(date);
        String lastBeginDate = lastTimeMap.get("lastBeginDate");
        String lastEndDate = lastTimeMap.get("lastEndDate");
        Map<String, Integer> map = new HashMap<>();
        try {
            Integer beginTime = (int) (FORMAT_YYMMDD_HHMMSS.parse(lastBeginDate).getTime() / 1000);
            Integer endTime = (int) (FORMAT_YYMMDD_HHMMSS.parse(lastEndDate).getTime() / 1000);
            map.put("beginTime", beginTime);
            map.put("endTime", endTime);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return map;
    }

    /*
     * 	将时间转换为时间戳
     */
    public static int dateToStamp(String s) throws ParseException {
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date date = simpleDateFormat.parse(s);
        long ts = date.getTime();
        return (int) (ts / 1000);
    }
    
	/*public static void main(String[] args) {
		int beginZero = TimeDateUtil.getYesterdayZeroTime();
		int endZero = TimeDateUtil.getCurrentTimeInt();
		try {
			int ll = dateToStamp("2019-02-19 00:00:00");
			
			System.out.println(" .beginZero="+beginZero +"  .endZero="+endZero );
			
			System.out.println(" .lla="+ll);
		} catch (ParseException e) {
			e.printStackTrace();
		}
	}*/

    /**
     * 获取过去的天数
     *
     * @param date
     * @return
     */
    public static long pastDays(Date date) {
        long t = new Date().getTime() - date.getTime();
        return t / (24 * 60 * 60 * 1000);
    }

    /**
     * 获取今天某个时间的时间错
     *
     * @param s
     * @return
     */
    @SuppressWarnings("deprecation")
    public static int stringToTimeInt(String s) {
        Date string2Date = string2Date(s, TimeDateUtil.FORMAT_HHMMSS);
        long todayZeroTime = TimeDateUtil.getTodayZeroTime() / 1000L;
        int time = (int) (todayZeroTime + (string2Date.getHours() * 3600) + (string2Date.getMinutes() * 60));
        return time;
    }

    public static boolean isSameDay(long time1, long time2) {
        return getDayOfYear(time1) == getDayOfYear(time2);
    }

    public static int getWeekOfYear(long time) {
        Calendar cal = Calendar.getInstance();
        cal.setTimeInMillis(time);
        return cal.get(Calendar.WEEK_OF_YEAR);
    }

    /***
     * 以年为周期
     * @param time1
     * @param time2
     * @return
     */
    public static boolean isSameWeek(long time1, long time2) {
        return getWeekOfYear(time1) == getWeekOfYear(time2);
    }

    /***
     * 间隔天数 (最少之为1)
     * (毫秒数)
     * @param time1
     * @param time2
     * @return
     */
    public static int intervalDays(long time1, long time2) {
        long intervalTime = Math.abs(time1 - time2);
        return (int) (intervalTime / ONEDAY) + 1;
    }


    /***
     * 间隔天数(最小值为1)
     * (秒数)
     * @param time1
     * @param time2
     * @return
     */
    public static int intervalDays(int time1, int time2) {
        int intervalTime = Math.abs(time1 - time2);
        return intervalTime / ONEDAYINT + 1;
    }

    public static long getZeroTime(long time) {
        Calendar cal = Calendar.getInstance();
        cal.setTimeInMillis(time);
        cal.set(Calendar.HOUR_OF_DAY, 0);
        cal.set(Calendar.MINUTE, 0);
        cal.set(Calendar.MILLISECOND, 0);
        cal.set(Calendar.SECOND, 0);
        return cal.getTime().getTime();
    }

    public static boolean isToday(long time) {
        return isSameDay(time, getCurrentTime());
    }

    public static boolean isToday(int time) {
        return isSameDay(time * 1l * ONESECOND, getCurrentTime());
    }

    public static int toSecond(long mill) {
        return (int) (mill / ONESECOND);
    }

    public static void main(String[] args) throws Exception {
        Map<Integer, Integer> map = new HashMap<>();
        map.put(1, 1);
        map.put(2, 2);
        System.out.println(GsonUtils.toJson(map));
    }

}