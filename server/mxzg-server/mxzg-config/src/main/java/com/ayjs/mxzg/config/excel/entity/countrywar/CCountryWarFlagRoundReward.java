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
public class CCountryWarFlagRoundReward implements BaseExcelModel {

    /***
     * 主题类型
     */
    private int idx;
    private int round;
    private ImmutableList<ImmutableThing> reward;


    @Override
    public int getExcelId() {
        return idx;
    }
}
