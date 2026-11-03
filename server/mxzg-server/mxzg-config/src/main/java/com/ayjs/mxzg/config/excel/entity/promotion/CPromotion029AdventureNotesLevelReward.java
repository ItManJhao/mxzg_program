package com.ayjs.mxzg.config.excel.entity.promotion;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 冒险笔记等级奖励
 */
@Getter
public class CPromotion029AdventureNotesLevelReward implements BaseExcelModel {
    private int level;
    private int turns;
    private int exp_need;
    private ImmutableList<ImmutableThing> reward;

    @Override
    public int getExcelId() {
        return level;
    }

}
