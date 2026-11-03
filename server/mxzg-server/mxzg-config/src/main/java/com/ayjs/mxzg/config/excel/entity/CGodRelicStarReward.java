package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;

import lombok.Getter;

/**
 * @Author: CWJ
 * @Date: 2020/3/23
 **/
@Getter
public class CGodRelicStarReward implements BaseExcelModel {

    private int idx;
    private int chapter;
    private int star;
    private ImmutableList<ImmutableThing> reward;


    @Override
    public int getExcelId() {
        return idx;
    }


}
