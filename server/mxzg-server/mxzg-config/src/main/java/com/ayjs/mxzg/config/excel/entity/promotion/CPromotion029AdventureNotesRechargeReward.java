package com.ayjs.mxzg.config.excel.entity.promotion;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 冒险笔记充值奖励
 */
@Getter
public class CPromotion029AdventureNotesRechargeReward implements BaseExcelModel {
    private int idx;
    private int turns;
    private int recharge_need;
    private ImmutableList<ImmutableThing> reward;

    @Override
    public int getExcelId() {
        return idx;
    }

}
