package com.ayjs.mxzg.config.excel.entity.spaceTime;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.common.util.IDrop;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

@Getter
public class CSpaceTimeShop implements BaseExcelModel, IDrop {

    private int idx;

    private int route_id;

    private int chance;

    private ImmutableList<ImmutableThing> cost;

    private ImmutableList<ImmutableThing> reward;

    private int box_id;

    private int buy_limit;

    @Override
    public int getDropId() {
        return idx;
    }

    @Override
    public int getRate() {
        return chance;
    }

    @Override
    public int getExcelId() {
        return idx;
    }
}
