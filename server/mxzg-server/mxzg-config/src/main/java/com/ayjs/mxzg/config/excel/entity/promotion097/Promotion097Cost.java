package com.ayjs.mxzg.config.excel.entity.promotion097;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * @author Rondo
 * @Date 2021-04-14 15:58:54
 */
@Getter
public class Promotion097Cost implements BaseExcelModel {
    private int idx;
    // 轮次
    private int turns;
    // 第几次
    private int times;
    // 消耗
    private ImmutableList<ImmutableThing> cost;
    @Override
    public int getExcelId() {
        return idx;
    }
}
