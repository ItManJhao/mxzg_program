package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

@Getter
public class CClanSkillResetGem implements BaseExcelModel {

    private int times;

    private ImmutableList<ImmutableThing> need_gem;

    @Override
    public int getExcelId() {
        return times;
    }
}
