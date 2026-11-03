package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableMap;
import lombok.Getter;


/**
 * 神器洗炼等级
 */
@Getter
public class CGoddessWashAttr implements BaseExcelModel {
    private int idx;

    private int wash_level;

    private int level;

    private ImmutableList<ImmutableThing> cost_res;

    private ImmutableMap<AttributeType, Long> add_ability;

    private ImmutableMap<AttributeType, Long> ability;

    @Override
    public int getExcelId() {
        return idx;
    }
}
