package com.ayjs.mxzg.config.excel.entity.countrywar;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.common.util.IDrop;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * @Author: CWJ
 * @Date: 2021/4/12
 **/
@Getter
public class CCountryWarLottery implements BaseExcelModel, IDrop {

    private int idx;
    private int round;
    private int weight;
    private ImmutableList<ImmutableThing> reward;
    private int max_count;
    private int min_count;

    @Override
    public int getDropId() {
        return idx;
    }

    @Override
    public int getRate() {
        return weight;
    }

    @Override
    public int getExcelId() {
        return idx;
    }
}
