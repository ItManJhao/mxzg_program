package com.ayjs.mxzg.config.excel.entity.floatingIslands;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;
import lombok.Setter;

/**
 * @Author: CWJ
 * @Date: 2020/6/30
 **/
@Getter
@Setter
public class CFloatingIslandsBuyConsume implements BaseExcelModel {

    private int idx;
    private ImmutableList<ImmutableThing> consume;

    @Override
    public int getExcelId() {
        return idx;
    }

}
