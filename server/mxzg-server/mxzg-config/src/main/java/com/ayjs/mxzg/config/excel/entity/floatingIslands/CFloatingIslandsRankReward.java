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
@Setter
@Getter
public class CFloatingIslandsRankReward implements BaseExcelModel {
    private int idx;
    private int rank_down;
    private int rank_up;
    private ImmutableList<ImmutableThing> reward;

    @Override
    public int getExcelId() {
        return idx;
    }
}
