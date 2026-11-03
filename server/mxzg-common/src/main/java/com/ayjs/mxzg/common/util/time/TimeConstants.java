package com.ayjs.mxzg.common.util.time;

/**
 * 时间单位常量定义
 */
public interface TimeConstants {
	/**
     * 一秒
     */
    int ONE_SECOND = 1;
    /**
     * 一秒钟的毫秒数
     */
    long ONE_SECOND_MILLIS = 1000L;
    /**
     * 一分钟的秒数
     */
    int ONE_MINUTE_SECOND = 60;
    /**
     * 一分钟的毫秒数
     */
    long ONE_MINUTE_MILLIS = 60 * ONE_SECOND_MILLIS;
    /**
     * 一小时的秒数
     */
    int ONE_HOUR_SECOND = 60 * ONE_MINUTE_SECOND;
    /**
     * 一小时的毫秒数
     */
    long ONE_HOUR_MILLIS = 60 * ONE_MINUTE_MILLIS;
    /**
     * 一天的秒数
     */
    int ONE_DAY_SECOND = 24 * ONE_HOUR_SECOND;
    /**
     * 一天的毫秒数
     */
    long ONE_DAY_MILLIS = 24 * ONE_HOUR_MILLIS;
    /**
     * 一周的秒数
     */
    int ONE_WEEK_SECOND = ONE_DAY_SECOND * 7;
    /**
     * 一周的毫秒数
     */
    long ONE_WEEK_MILLIS = ONE_DAY_MILLIS * 7;

    /**
     * 一天的分数
     */
    int ONE_DAY_MINUTE = ONE_DAY_SECOND / ONE_MINUTE_SECOND;
    /**
     * 半天的秒数
     */
    int HALF_DAY_SECOND = 12 * ONE_HOUR_SECOND;
}
