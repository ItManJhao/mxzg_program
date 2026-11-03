package com.ayjs.mxzg.config.excel.entity.hades;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * @Author: CWJ
 * @Date: 2021/1/6
 **/
@Getter
public class CHadesBuyCount implements BaseExcelModel {
    private int idx;
    private ImmutableList<ImmutableThing> cost;

    @Override
    public int getExcelId() {
        return idx;
    }
}
