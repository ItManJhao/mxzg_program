package com.ayjs.mxzg.config.excel.entity.promotion090;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 通行证等级奖励
 * @author hyx
 */
@Getter
public class CPromotion090TrafficPermitReward implements BaseExcelModel {

    private int level;

    private ImmutableList<ImmutableThing> level_cost;

    private int exp;

    private ImmutableList<ImmutableThing> finish_reward;

    private ImmutableList<ImmutableThing> privilege_reward;

    @Override
    public int getExcelId() {
        return level;
    }
}
