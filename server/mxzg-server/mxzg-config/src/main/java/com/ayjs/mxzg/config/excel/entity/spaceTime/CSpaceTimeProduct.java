package com.ayjs.mxzg.config.excel.entity.spaceTime;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

@Getter
public class CSpaceTimeProduct implements BaseExcelModel {

    private int idx;

    private int product_id;

    private ImmutableList<ImmutableThing> reward;

    private int buy_limit;

    @Override
    public int getExcelId() {
        return idx;
    }
}
