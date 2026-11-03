package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 永恒梦境排名奖励
 *
 * @Author: CWJ
 * @Date: 2019/12/11
 **/
@Getter
public class CDreamlandRankReward implements BaseExcelModel {
    private int idx;
    private int rank_min;
    private int rank_max;
    private ImmutableList<ImmutableThing> reward;

    @Override
    public int getExcelId() {
        return idx;
    }
}
