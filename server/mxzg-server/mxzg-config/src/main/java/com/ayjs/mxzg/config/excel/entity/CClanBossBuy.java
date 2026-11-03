package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 公会挑战次购买表
 */
@Getter
public class CClanBossBuy implements BaseExcelModel {

    /**
     * 购买次数
     */
    private int times;

    /**
     * 扣费
     */
    private ImmutableList<ImmutableThing> cost;

    @Override
    public int getExcelId() {
        return times;
    }
}
