package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

import java.util.List;

/**
 * 皮肤熔炼配置
 */
@Getter
public class CGoddessFashionSmelt implements BaseExcelModel {

    private int idx;

    private List<ImmutableThing> origin_item;

    private ImmutableList<ImmutableThing> target_item;

    @Override
    public int getExcelId() {
        return idx;
    }
}