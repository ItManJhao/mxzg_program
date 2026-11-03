package com.ayjs.mxzg.config.excel.entity.promotion092;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;
import lombok.Setter;

/**
 * @Author: CWJ
 * @Date: 2020/12/14
 **/
@Getter
@Setter
public class CPromotion092BuyFlower implements BaseExcelModel {

    private int idx;
    private int count_min;
    private int count_max;
    private ImmutableList<ImmutableThing> cost;
    private ImmutableList<ImmutableThing> reward;

    @Override
    public int getExcelId() {
        return idx;
    }

}
