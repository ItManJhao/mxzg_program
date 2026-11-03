package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 英雄重生
 * @author hyx
 */
@Getter
public class CHeroReborn implements BaseExcelModel {

    private int idx;

    private int hero;

    private int star;

    private ImmutableList<ImmutableThing> cost;//扣费

    private ImmutableList<ImmutableThing> reback_hero_chip;//返还本体碎片

    private ImmutableList<ImmutableThing> reback_elem_chip;//返还对应元素碎片

    @Override
    public int getExcelId() {
        return idx;
    }
}
