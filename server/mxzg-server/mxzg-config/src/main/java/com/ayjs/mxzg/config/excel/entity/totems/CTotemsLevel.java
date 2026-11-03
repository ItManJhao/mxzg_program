package com.ayjs.mxzg.config.excel.entity.totems;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableMap;
import lombok.Getter;

/**
 * 图腾升级表
 */
@Getter
public class CTotemsLevel implements BaseExcelModel {
    private int id;//唯一id
    private int totems_id;//图腾id
    private int level;//等级
    private ImmutableList<ImmutableThing> cost;
    private ImmutableMap<AttributeType, Long> attr;
    private int skill;
    private int skill_level;

    @Override
    public int getExcelId() {
        return id;
    }
}
