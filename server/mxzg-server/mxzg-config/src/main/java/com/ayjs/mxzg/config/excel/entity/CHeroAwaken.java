package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.AttributeKind;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 英雄基础
 */
@Getter
public class CHeroAwaken implements BaseExcelModel {

    private int hero_type;

    private int need_star;

    private ImmutableList<AttributeKind> base_attr;

    private int base_count;

    private ImmutableList<AttributeKind> special_attr;

    private int special_count;

    private ImmutableList<ImmutableThing> cost;

    @Override
    public int getExcelId() {
        return hero_type;
    }


}
