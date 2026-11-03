package com.ayjs.mxzg.common.util;

import java.time.format.DateTimeFormatter;

/**
 * 日期格式
 */
public interface DateTimeFormatters {
    /**
     * yyyy_MM_dd 格式
     */
    DateTimeFormatter FORMATTER_YYYY_MM_DD = DateTimeFormatter.ofPattern(DateFormatConstants.FORMAT_YYYY_MM_DD);
    /**
     * YYYYww 格式
     */
    DateTimeFormatter FORMATTER_YYYYWW = DateTimeFormatter.ofPattern(DateFormatConstants.FORMAT_YYYYWW);
    /**
     * yyyy_MM 格式
     */
    DateTimeFormatter FORMATTER_YYYY_MM = DateTimeFormatter.ofPattern(DateFormatConstants.FORMAT_YYYY_MM);
}
