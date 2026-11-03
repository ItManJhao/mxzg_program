package com.ayjs.mxzg.config.excel.entity.promotion;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 *
 */
@Getter
public class CPromotion054FlashSale implements BaseExcelModel {

    /**
     * ID
     */
    private int idx;

    private int turns;

    /**
     *
     */
    private int limit_day;

    /**
     *
     */
    private int limit_num;
    /**
     * 第一天奖励
     */
    private ImmutableList<ImmutableThing> reward;

    /***
     * 商品id
     */
    private int production_id;

    @Override
    public int getExcelId() {
        return idx;
    }

}
