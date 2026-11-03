package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

import java.util.List;

/**
 * 英雄置换
 */
@Getter
public class CHeroSwitch implements BaseExcelModel {

    private int idx;

    private int elem;

    private int star;

    private ImmutableList<ImmutableThing> cost;//扣费

    private int need_hero;  //需要的英雄数量

    private List<Integer> elem_target;  //可以置换的英雄元素列表

    @Override
    public int getExcelId() {
        return idx;
    }


}
