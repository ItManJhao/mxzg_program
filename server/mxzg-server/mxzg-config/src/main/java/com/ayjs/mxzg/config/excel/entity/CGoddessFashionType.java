package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableMap;
import lombok.Getter;

/**
 * 羁绊皮肤类型
 */
@Getter
public class CGoddessFashionType implements BaseExcelModel {

    private int type;

    private int goddess_type;

    private int unlock_type;

    private ImmutableList<ImmutableThing> need_item;

    private ImmutableMap<AttributeType, Long> attr;

    @Override
    public int getExcelId() {
        return type;
    }
}