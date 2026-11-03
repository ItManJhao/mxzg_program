package com.ayjs.mxzg.config.excel.entity.spaceTime;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.common.util.IDrop;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

@Getter
public class CSpaceTimeBox implements BaseExcelModel, IDrop {

    private int idx;

    private int item_id;

    private int chance;

    private ImmutableList<ImmutableThing> reward;

    @Override
    public int getExcelId() {
        return idx;
    }

    @Override
    public int getDropId() {
        return idx;
    }

    @Override
    public int getRate() {
        return chance;
    }
}
