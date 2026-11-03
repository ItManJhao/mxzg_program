package com.ayjs.mxzg.config.excel.entity.occupation;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 职级模板
 */
@Getter
public class COccupation implements BaseExcelModel {

    private int id;
    private int shenbinCore;
    private int landNum;
    private int heroNum;
    private ImmutableList<ImmutableThing> reward;

    @Override
    public int getExcelId() {
        return id;
    }
}
