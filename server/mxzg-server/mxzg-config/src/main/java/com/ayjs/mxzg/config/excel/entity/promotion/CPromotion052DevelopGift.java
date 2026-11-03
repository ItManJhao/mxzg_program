package com.ayjs.mxzg.config.excel.entity.promotion;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 超值养成礼
 */
@Getter
public class CPromotion052DevelopGift implements BaseExcelModel {

    private int idx;

    private int type;//礼包类型

    private int level;//礼包等级

    private ImmutableList<ImmutableThing> cost;//消耗

    private ImmutableList<ImmutableThing> value;//原阶值

    private int discount;//折扣（满折是100）

    private ImmutableList<ImmutableThing> reward;//礼包奖励

    private int reset_level;//重置档次

    @Override
    public int getExcelId() {
        return idx;
    }
}
