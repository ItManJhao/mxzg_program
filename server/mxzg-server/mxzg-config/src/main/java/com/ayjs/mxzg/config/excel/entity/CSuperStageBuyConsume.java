package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 段位赛购买次数消耗表
 */
@Getter
public class CSuperStageBuyConsume implements BaseExcelModel {

    /**
     * 次数
     */
    private int idx;

    /**
     * 购买消耗
     */
    private ImmutableList<ImmutableThing> consume;


    @Override
    public int getExcelId() {
        return idx;
    }


}
