package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

@Getter
public class CDailyMissionCost implements BaseExcelModel {
    /**
     * 唯一id
     */
    private int idx;
    /**
     * 副本类型
     * 1 金币副本， 2经验副本， 3英雄副本，4羁绊副本，5精灵（符文）副本
     */
    private int mission_type;
    /**
     * 关卡
     */
    private int battle_num;

    /**
     * 奖励
     */
    private ImmutableList<ImmutableThing> cost;

    @Override
    public int getExcelId() {
        return idx;
    }
}
