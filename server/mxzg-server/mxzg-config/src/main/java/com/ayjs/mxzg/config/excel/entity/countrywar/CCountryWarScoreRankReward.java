package com.ayjs.mxzg.config.excel.entity.countrywar;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * @Author: CWJ
 * @Date: 2021/4/12
 **/
@Getter
public class CCountryWarScoreRankReward implements BaseExcelModel {

    private int idx;
    private int rank_up;
    private int rank_down;
    private ImmutableList<ImmutableThing> reward;


    @Override
    public int getExcelId() {
        return idx;
    }
}
