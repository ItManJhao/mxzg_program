package com.ayjs.mxzg.config.excel.entity.tweakCube;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * @Author: CWJ
 * @Date: 2020/9/8
 **/
@Getter
public class CTweakCubeTrenchOpen implements BaseExcelModel {

    private int idx;

    private ImmutableList<ImmutableThing> cost;

    @Override
    public int getExcelId() {
        return idx;
    }
}
