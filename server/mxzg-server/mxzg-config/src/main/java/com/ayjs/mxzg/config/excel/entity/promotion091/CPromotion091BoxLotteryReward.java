package com.ayjs.mxzg.config.excel.entity.promotion091;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.common.util.IDrop;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * @Author: CWJ
 * @Date: 2020/12/14
 **/
@Getter
public class CPromotion091BoxLotteryReward implements BaseExcelModel, IDrop {

    private int idx;

    private ImmutableList<ImmutableThing> reward;

    private int weight;

    private int need_count;

    @Override
    public int getExcelId() {
        return idx;
    }

    @Override
    public int getDropId() {
        return idx;
    }

    @Override
    public int getRate() {
        return weight;
    }
}
