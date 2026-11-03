package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

@Getter
public class CGoddessSkillCost implements BaseExcelModel {

    private int idx;

    private int level;

    private ImmutableList<ImmutableThing> cost_res;

    private int need_base_level;

    @Override
    public int getExcelId() {
        return idx;
    }
}
