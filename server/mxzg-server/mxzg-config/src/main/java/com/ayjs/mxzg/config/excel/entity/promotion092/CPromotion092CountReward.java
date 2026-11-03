package com.ayjs.mxzg.config.excel.entity.promotion092;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * @Author: CWJ
 * @Date: 2020/12/14
 **/
@Getter
public class CPromotion092CountReward implements BaseExcelModel {

    private int idx;
    private int count;
    private ImmutableList<ImmutableThing> reward;

    @Override
    public int getExcelId() {
        return idx;
    }

}
