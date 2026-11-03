package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 英雄空间增加表
 */
@Getter
public class CHeroSpace implements BaseExcelModel {
    /**
     * 购买次数
     */
    private int times;
    /**
     * 价格
     */
    private ImmutableList<ImmutableThing> prize;
    /**
     * 增加的空间
     */
    private int space;

    @Override
    public int getExcelId() {
        return times;
    }
}
