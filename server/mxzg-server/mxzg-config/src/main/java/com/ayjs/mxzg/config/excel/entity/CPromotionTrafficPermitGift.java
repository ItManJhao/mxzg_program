package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 通行证特权礼包
 */
@Getter
public class CPromotionTrafficPermitGift implements BaseExcelModel {

    private int idx;

    private int production_id;//商品id

    private int day_point;

    private int point;

    private ImmutableList<ImmutableThing> reward;

    private int limit;


    @Override
    public int getExcelId() {
        return idx;
    }
}
