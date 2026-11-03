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
public class CCountryWarMissionScore implements BaseExcelModel {

    private int idx;
    /***
     * 国战类型
     */
    private int round;
    private ImmutableList<ImmutableThing> need_score;
    private ImmutableList<ImmutableThing> reward;
    private ImmutableList<ImmutableThing> mystery_reward;


    @Override
    public int getExcelId() {
        return idx;
    }
}
