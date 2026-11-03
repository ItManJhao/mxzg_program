package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 道具分解
 * @author hyx
 */
@Getter
public class CDecompositionItem implements BaseExcelModel {

    private int item_type;

    private ImmutableList<ImmutableThing> reward;

    @Override
    public int getExcelId() {
        return item_type;
    }
}
