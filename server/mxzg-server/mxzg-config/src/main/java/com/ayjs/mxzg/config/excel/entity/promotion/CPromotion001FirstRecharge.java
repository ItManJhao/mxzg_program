package com.ayjs.mxzg.config.excel.entity.promotion;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 *
 */
@Getter
public class CPromotion001FirstRecharge implements BaseExcelModel {

    /**
     * ID
     */
    private int idx;

    private int type;
    
    private int product_id;
    /**
     *
     */
    private int day;
    /**
     * 第一天奖励
     */
    private ImmutableList<ImmutableThing> reward;

    @Override
    public int getExcelId() {
        return idx;
    }

}
