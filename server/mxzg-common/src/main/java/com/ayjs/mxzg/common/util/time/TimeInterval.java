package com.ayjs.mxzg.common.util.time;

import lombok.Value;

import java.time.LocalTime;
import java.util.List;

/**
 * 时间区间
 */
@Value(staticConstructor = "of")
public class TimeInterval {

    private LocalTime start;
    private LocalTime end;

    /**
     * 构造 eg: ["12:00:00","12:29:59"]
     *
     * @param interval
     * @return
     */
    public static TimeInterval of(List<String> interval) {
        LocalTime start = LocalTime.parse(interval.get(0));
        LocalTime end = LocalTime.parse(interval.get(1));
        return of(start, end);
    }

    /**
     * {@code time} 是否在闭区间 [{@code start}, {@code end}) 内  eg: 00:00:01 在 [00:00:00,23:59:59] 内
     *
     * @param time
     * @return
     */
    public boolean contains(LocalTime time) {
        return !start.isAfter(time) && !time.isAfter(end);
    }
}
