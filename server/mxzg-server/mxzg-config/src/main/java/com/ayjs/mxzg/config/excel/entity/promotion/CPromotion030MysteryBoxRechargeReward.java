package com.ayjs.mxzg.config.excel.entity.promotion;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 神秘魔盒充值奖励
 */
@Getter
public class CPromotion030MysteryBoxRechargeReward implements BaseExcelModel {
    public int idx;
    private int turns;
    public int recharge_need;
    public ImmutableList<ImmutableThing> reward;

    @Override
    public int getExcelId() {
        return idx;
    }

}
