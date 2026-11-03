package com.ayjs.mxzg.config.excel.entity.promotion;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 龙舟宝箱配置表
 * @author hyx
 */
@Getter
public class CPromotion064DragonBoatBoxReward implements BaseExcelModel {

    private int idx;

    private int day_turns;

    private int task_count;

    public ImmutableList<ImmutableThing> box_reward;

    @Override
    public int getExcelId() {
        return idx;
    }
}
