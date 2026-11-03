package com.ayjs.mxzg.config.excel.entity.promotion078;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * @Author: CWJ
 * @Date: 2020/8/6
 **/
@Getter
public class CPromotion078LotteryCountReward implements BaseExcelModel {

    private int idx;
    private int count;
    private ImmutableList<ImmutableThing> reward;


    @Override
    public int getExcelId() {
        return idx;
    }
}
