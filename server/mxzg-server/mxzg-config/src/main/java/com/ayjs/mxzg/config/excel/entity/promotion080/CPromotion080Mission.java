package com.ayjs.mxzg.config.excel.entity.promotion080;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.TargetStruct;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * @Author: CWJ
 * @Date: 2020/8/6
 **/
@Getter
public class CPromotion080Mission implements BaseExcelModel {

    private int idx;
    private int day;
    private TargetStruct target;
    private ImmutableList<ImmutableThing> reward;

    @Override
    public int getExcelId() {
        return idx;
    }
}
