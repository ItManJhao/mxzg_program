package com.ayjs.mxzg.config.excel.entity.pet;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableMap;
import lombok.Getter;

@Getter
public class CPetLevel implements BaseExcelModel {

    private int idx;

    private int id;

    private int level;

    private int need_pet;

    private ImmutableList<ImmutableThing> cost;

    private ImmutableMap<AttributeType, Long> attr;

    private int skill;

    private int skill_level;

    @Override
    public int getExcelId() {
        return idx;
    }
}
