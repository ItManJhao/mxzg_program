package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;

import lombok.Getter;
import lombok.Setter;

/**
 * @Author: CWJ
 * @Date: 2020/1/3
 **/
@Getter
@Setter
public class CLadderFightTimes implements BaseExcelModel {

    private int buy_times;

    private ImmutableList<ImmutableThing> cost;

    @Override
    public int getExcelId() {
        return buy_times;
    }
}
