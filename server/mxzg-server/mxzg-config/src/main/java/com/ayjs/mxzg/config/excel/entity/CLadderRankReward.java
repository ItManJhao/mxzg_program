package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;
import lombok.Setter;

/**
 * @Author: CWJ
 * @Date: 2020/1/3
 **/
@Getter
@Setter
public class CLadderRankReward implements BaseExcelModel {

    private int idx;

    private int rank_low;

    private int rank_up;

    private ImmutableList<ImmutableThing> rank_reward;

    @Override
    public int getExcelId() {
        return idx;
    }
}
