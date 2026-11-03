package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.TargetStruct;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 成就
 */
@Getter
public class CDailyTaskMainTest implements BaseExcelModel {

    private int idx;

    private int open_level;

    private TargetStruct task;

    private ImmutableList<ImmutableThing> reward;

    private int point;

    @Override
    public int getExcelId() {
        return idx;
    }

}
