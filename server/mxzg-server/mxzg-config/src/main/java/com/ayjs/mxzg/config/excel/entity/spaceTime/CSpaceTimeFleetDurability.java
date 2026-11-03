package com.ayjs.mxzg.config.excel.entity.spaceTime;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import lombok.Getter;

@Getter
public class CSpaceTimeFleetDurability implements BaseExcelModel {

    private int idx;

    private int durability_down;

    private int decrease_speed;

    private int decrease_item;

    @Override
    public int getExcelId() {
        return idx;
    }
}
