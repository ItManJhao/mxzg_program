package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * @Author: CWJ
 * @Date: 2019/12/11
 **/
@Getter
public class CDreamlandDailyReward implements BaseExcelModel {

    private int idx;
    /**
     * 每天前n关读取奖励
     */
    private ImmutableList<ImmutableThing> standard_reward;
    /**
     * 每天n关后读取的奖励
     */
    private ImmutableList<ImmutableThing> after_reward;

    @Override
    public int getExcelId() {
        return idx;
    }
}
