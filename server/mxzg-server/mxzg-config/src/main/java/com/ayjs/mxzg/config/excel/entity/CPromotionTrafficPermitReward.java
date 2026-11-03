package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 通行证等级奖励
 *
 * @author hyx
 */
@Getter
public class CPromotionTrafficPermitReward implements BaseExcelModel {

    private int idx;

    private int round;

    private int level;

    private ImmutableList<ImmutableThing> level_cost;

    private int exp;

    private ImmutableList<ImmutableThing> finish_reward;

    private ImmutableList<ImmutableThing> privilege_reward;

    @Override
    public int getExcelId() {
        return idx;
    }
}
