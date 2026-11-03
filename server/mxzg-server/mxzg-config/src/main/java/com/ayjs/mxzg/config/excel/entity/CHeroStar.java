package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 英雄升星
 */
@Getter
public class CHeroStar implements BaseExcelModel {

    private int star;

    private int level_limit;

    private int role_level_require;

    private int world_level_require;

    private int skill1;

    private int skill2;

    private int skill3;

    private int skill4;

    private ImmutableList<ImmutableThing> need_item;

    private ImmutableList<ImmutableThing> upstar_cost;

    private ImmutableList<ImmutableThing> sacrifice_item_refund;

    @Override
    public int getExcelId() {
        return star;
    }

}
