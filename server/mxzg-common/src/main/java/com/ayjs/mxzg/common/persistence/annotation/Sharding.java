package com.ayjs.mxzg.common.persistence.annotation;

import com.ayjs.mxzg.common.util.DateTimeFormatters;

import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;
import java.time.LocalDateTime;

/**
 * 分表策略
 */
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface Sharding {
    /**
     * 分片策略
     *
     * @return
     */
    Strategy strategy() default Strategy.SINGLE;

    /**
     * strategy = INCREMENT 时值意义：单表数据量大小, -1表示无限制,
     * strategy = INCREMENT 时值意义：拆分表个数，用指定指定字段取模如：(role表拆成两个：role_0,role_1)
     *
     * @return
     */
    int size() default -1;

    /**
     * 分片周期  strategy = DATE 时该值有意义
     *
     * @return
     */
    Period period() default Period.MONTHLY;

    String splitBy() default "";

    /**
     * 分片策略
     */
    enum Strategy {

        /**
         * 单表
         */
        SINGLE,

        /**
         * 根据增量id分片
         */
        INCREMENT,

        /**
         * 根据日期分片该类型分片用于日志表分表，不支持通过id查询
         */
        DATE,
        /**
         * 根据某个数值字段拆分成N个表
         */
        SPLIT;
    }

    /**
     * 分片周期
     */
    enum Period {

        /**
         * 每日 返回格式：daily_2019_02_14 返当天的日期 yyyy_MM_dd
         */
        DAILY {
            @Override
            public String getPeriodName(LocalDateTime dateTime) {
                return this.name().toLowerCase() + "_" + dateTime.format(DateTimeFormatters.FORMATTER_YYYY_MM_DD);
            }
        },

        /**
         * 每周 - 返回格式：weekly_201910 返回每周的周日 YYYYww
         */
        WEEKLY {
            @Override
            public String getPeriodName(LocalDateTime dateTime) {
                return this.name().toLowerCase() + "_" + dateTime.format(DateTimeFormatters.FORMATTER_YYYYWW);
            }
        },

        /**
         * 每月 返回格式：monthly_2019_03 返回当月的年月 yyyy_MM
         */
        MONTHLY {
            @Override
            public String getPeriodName(LocalDateTime dateTime) {
                return this.name().toLowerCase() + "_" + dateTime.format(DateTimeFormatters.FORMATTER_YYYY_MM);
            }
        };

        /**
         * 获取周期名
         *
         * @param dateTime
         * @return
         */
        public abstract String getPeriodName(LocalDateTime dateTime);
    }
}
