package com.ayjs.mxzg.config.excel.entity.promotion087;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * @Author: CWJ
 * @Date: 2020/12/14
 **/
@Getter
public class CPromotion087LotteryType implements BaseExcelModel {

    private int idx;

    private ImmutableList<ImmutableThing> cost;

    @Override
    public int getExcelId() {
        return idx;
    }
}
