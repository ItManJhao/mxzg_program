package com.ayjs.mxzg.config.excel.entity.floatingIslands;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;
import lombok.Setter;

/**
 * @Author: CWJ
 * @Date: 2020/6/30
 **/
@Getter
@Setter
public class CFloatingIslandsDmgReward implements BaseExcelModel {

    private int idx;
    private long dmg_value;
    private ImmutableList<ImmutableThing> reward;

//    public long dmgLong() {
//        return Long.valueOf(dmg_value).intValue();
//    }

    @Override
    public int getExcelId() {
        return idx;
    }


}
