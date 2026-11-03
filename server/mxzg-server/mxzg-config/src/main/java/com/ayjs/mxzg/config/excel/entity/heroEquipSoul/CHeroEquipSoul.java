package com.ayjs.mxzg.config.excel.entity.heroEquipSoul;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * @Author: CWJ
 * @Date: 2021/3/8
 **/
@Getter
public class CHeroEquipSoul implements BaseExcelModel {

    private int idx;
    private int place;
    private int level;
    private int skill;
    private int skill_level;
    private ImmutableList<ImmutableThing> cost;
    private ImmutableList<ImmutableThing> reset_cost;


    @Override
    public int getExcelId() {
        return idx;
    }
}
