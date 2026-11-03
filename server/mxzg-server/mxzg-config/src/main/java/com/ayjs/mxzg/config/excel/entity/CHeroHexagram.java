package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.SkillScript;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableMap;
import lombok.Getter;

/**
 * @Author CJX
 * @Date 2021/5/20
 */

@Getter
public class CHeroHexagram implements BaseExcelModel {
    private int idx;
    private int type;
    private int level;
    private ImmutableMap<AttributeType, Long> attr;
    private ImmutableMap<AttributeType, Long> skill_attr;
    private ImmutableList<ImmutableThing> cost;
    private ImmutableList<ImmutableThing> cost_magicwand;
    private int need_star;
    private ImmutableList<SkillScript> skill;
    private ImmutableList<ImmutableThing> give_back;

    @Override
    public int getExcelId() {
        return idx;
    }
}
