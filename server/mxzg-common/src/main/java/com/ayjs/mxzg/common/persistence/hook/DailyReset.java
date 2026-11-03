package com.ayjs.mxzg.common.persistence.hook;

import java.time.LocalDateTime;
import java.time.LocalTime;

/**
 * 每日重置
 */
@Hook(opportunity = HookOpportunity.GET_AFTER)
public interface DailyReset {

    /**
     * 默认每日重置时间 "00:00:00"
     */
    LocalTime DEFAULT_RESET_TIME = LocalTime.parse("00:00:00");

    /**
     * 获取每日重置的时间
     *
     * @return
     */
    default LocalTime getResetTime() {
        return DEFAULT_RESET_TIME;
    }

    /**
     * 获取上次重置时间
     *
     * @return
     */
    LocalDateTime getLastResetDateTime();

    /**
     * 设置上次重置时间
     *
     * @param resetDateTime
     */
    void setLastResetDateTime(LocalDateTime resetDateTime);

    /**
     * 重置
     */
    void reset();
}
