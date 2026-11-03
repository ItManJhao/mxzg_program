package com.ayjs.mxzg.config.excel.entity.spaceTime;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.AttributeKind;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.google.common.collect.ImmutableMap;
import lombok.Getter;

import java.util.List;

@Getter
public class CSpaceTimeFleetSkill implements BaseExcelModel {

    private int idx;

    private int type;

    private int level;

    private ImmutableMap<AttributeType, Long> ability;

    private int fleet_speed_add;

    private int fleet_item;

    private int fleet_endurance;

    @Override
    public int getExcelId() {
        return idx;
    }
}
