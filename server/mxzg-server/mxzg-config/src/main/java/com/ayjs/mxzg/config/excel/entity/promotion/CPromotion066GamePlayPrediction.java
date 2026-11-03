package com.ayjs.mxzg.config.excel.entity.promotion;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 功能预告活动
 *
 * @author hyx
 */
public class CPromotion066GamePlayPrediction implements BaseExcelModel {

    private int idx;

    private int open_level;

    private String start_time;

    private String end_time;

    private int startTime;

    private int endTime;

    private ImmutableList<ImmutableThing> reward;

    public int getStartTime() {
        return DateTimeUtil.strToTime(start_time);
    }

    public int getEndTime() {
        return DateTimeUtil.strToTime(end_time);
    }

    public int getIdx() {
        return idx;
    }

    public int getOpen_level() {
        return open_level;
    }

    public ImmutableList<ImmutableThing> getReward() {
        return reward;
    }

    @Override
    public int getExcelId() {
        return idx;
    }
}
