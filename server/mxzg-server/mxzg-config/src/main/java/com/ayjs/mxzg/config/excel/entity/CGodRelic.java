package com.ayjs.mxzg.config.excel.entity;

import java.util.List;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;

import lombok.Getter;

/**
 * @Author: CWJ
 * @Date: 2020/3/23
 * 诸神遗迹
 **/
@Getter
public class CGodRelic implements BaseExcelModel {

    private int idx;
    private int chapter;
    private int level;
    private List<Integer> target;
    private ImmutableList<ImmutableThing> reward;
    private ImmutableList<ImmutableThing> first_reward;


    @Override
    public int getExcelId() {
        return idx;
    }


}
