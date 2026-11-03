package com.ayjs.mxzg.config.excel.entity.spaceTime;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

import java.util.List;

public class CSpaceTimeAdventure implements BaseExcelModel {

    private int idx;

    private int route_type;

    private int fleet_level;

    private int distance_traveled;

    private ImmutableList<ImmutableThing> fix_reward;

    private ImmutableList<ImmutableThing> random_reward;

    public int getIdx() {
        return idx;
    }

    public int getRoute_type() {
        return route_type;
    }

    public int getFleet_level() {
        return fleet_level;
    }

    public ImmutableList<ImmutableThing> getFix_reward() {
        return fix_reward;
    }

    public ImmutableList<ImmutableThing> getRandom_reward() {
        return random_reward;
    }

    public long getTotalProgress() {
        return this.distance_traveled * 300;
    }

    @Override
    public int getExcelId() {
        return idx;
    }
}
