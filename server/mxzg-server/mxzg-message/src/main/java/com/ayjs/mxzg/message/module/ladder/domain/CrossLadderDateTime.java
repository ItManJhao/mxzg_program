package com.ayjs.mxzg.message.module.ladder.domain;

import cn.hutool.core.util.StrUtil;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import lombok.Getter;
import lombok.Setter;

/**
 * 天梯时间
 */
@Getter
@Setter
public class CrossLadderDateTime {
    /**
     * 下一次活动开始执行时间
     */
    private int nextStartDateTime;
    /**
     * 下一次活动结束执行时间
     */
    private int nextEndDateTime;
    /**
     * 上一次结算时间
     */
    private int lastEndDateTime;
    /**
     * 本周活动开始时间
     */
    private int theWeekStartDateTime;
    /**
     * 本周活动结束时间
     */
    private int theWeekEndDateTime;

    @Override
    public String toString() {
        return StrUtil.format("nextStartDateTime:{} nextEndDateTime:{},lastEndDateTime:{},theWeekStartDateTime:{},theWeekEndDateTime:{}",
                DateTimeUtil.date(nextStartDateTime),
                DateTimeUtil.date(nextEndDateTime),
                DateTimeUtil.date(lastEndDateTime),
                DateTimeUtil.date(theWeekStartDateTime),
                DateTimeUtil.date(theWeekEndDateTime));
    }
}
