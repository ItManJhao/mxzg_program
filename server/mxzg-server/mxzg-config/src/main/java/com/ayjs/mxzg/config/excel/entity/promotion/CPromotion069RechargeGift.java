package com.ayjs.mxzg.config.excel.entity.promotion;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

@Getter
public class CPromotion069RechargeGift implements BaseExcelModel {

    private int idx;

    private int type;

    private int recharge;

    /**
     * 1:只能领取一次
     * 0：激活类型限时间内每天领取一次
     */
    private int reward_type;

    private int need_day;

    private ImmutableList<ImmutableThing> reward;

    @Override
    public int getExcelId() {
        return idx;
    }
}
