package com.ayjs.mxzg.config.excel.entity.spaceTime;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

@Getter
public class CSpaceTimeFleet implements BaseExcelModel {

    private int level;

    private int need_exp;

    private int energy;

    private int durability;

    private int energy_regain_time;

    private int speed;

    private ImmutableList<ImmutableThing> repair_cost;

    private int regain_durability;

    @Override
    public int getExcelId() {
        return level;
    }
}
