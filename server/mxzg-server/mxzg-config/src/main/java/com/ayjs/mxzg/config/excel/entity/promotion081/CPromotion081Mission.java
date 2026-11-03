package com.ayjs.mxzg.config.excel.entity.promotion081;

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
public class CPromotion081Mission implements BaseExcelModel {

    private int idx;
    private TargetStruct target;
    private ImmutableList<ImmutableThing> reward;

    @Override
    public int getExcelId() {
        return idx;
    }
}
