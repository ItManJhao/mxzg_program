package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableMap;
import lombok.Getter;

@Getter
public class CMagicWandStrengthen implements BaseExcelModel {

    private int idx;
    // 魔杖配置表id
    private int item_type;
    // 强化等级
    private int level;
    // 强化消耗
    private ImmutableList<ImmutableThing> cost;
    // 强化等级属性
    private ImmutableMap<AttributeType, Long> attrs;

    @Override
    public int getExcelId() {
        return idx;
    }
}
