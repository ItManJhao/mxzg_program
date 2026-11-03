package com.ayjs.mxzg.config.excel.entity.promotion;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 三日任务终极奖励
 * @author hyx
 */
@Getter
public class CPromotion061ThreeDayTaskReward implements BaseExcelModel {

    private int idx;

    private int turns;

    private int day;

    private ImmutableList<ImmutableThing> reward;

    @Override
    public int getExcelId() {
        return idx;
    }
}
