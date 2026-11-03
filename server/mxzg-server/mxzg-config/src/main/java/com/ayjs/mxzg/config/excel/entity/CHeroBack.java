package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 英雄回退
 */
@Getter
public class CHeroBack implements BaseExcelModel {

    private int idx;

    private int elem;

    private int star;

    private int evolve_level;

    private ImmutableList<ImmutableThing> cost; //消耗

    private int reback_hero_chip_num;  //回退的英雄数量

    private ImmutableList<ImmutableThing> reback_item;  //可以置换的英雄元素列表

    @Override
    public int getExcelId() {
        return idx;
    }

}
