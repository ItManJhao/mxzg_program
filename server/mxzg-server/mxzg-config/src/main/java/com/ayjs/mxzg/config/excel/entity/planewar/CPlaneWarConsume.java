package com.ayjs.mxzg.config.excel.entity.planewar;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * @Author: CWJ
 * @Date: 2020/9/15
 **/
@Getter
public class CPlaneWarConsume implements BaseExcelModel {

    private int idx;

    private ImmutableList<ImmutableThing> consume;

    @Override
    public int getExcelId() {
        return idx;
    }

}
