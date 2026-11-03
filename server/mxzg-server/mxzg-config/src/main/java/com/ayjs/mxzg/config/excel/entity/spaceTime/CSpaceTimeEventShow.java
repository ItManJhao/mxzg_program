package com.ayjs.mxzg.config.excel.entity.spaceTime;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.common.util.IDrop;
import com.ayjs.mxzg.config.struct.FleetSailingStruct;
import com.ayjs.mxzg.config.struct.FleetUnlockStruct;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

@Getter
public class CSpaceTimeEventShow implements BaseExcelModel, IDrop {

    private int idx;

    private int route_id;

    private int chance;

    private int event_id;

    private ImmutableList<FleetUnlockStruct> route;

    private int group;

    private ImmutableList<FleetSailingStruct> buff;

    private ImmutableList<FleetSailingStruct> debuff;

    private ImmutableList<ImmutableThing> cost;

    private int product_id;


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
