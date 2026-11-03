package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;

import lombok.Getter;

/***
 * 周末礼包
 */
@Getter
public class CWeekendGift implements BaseExcelModel {

    //任务id
    private int idx;
    //对应天数
    private int days;
    //奖励
    private ImmutableList<ImmutableThing> reward;

    @Override
    public int getExcelId() {
        return idx;
    }
}
