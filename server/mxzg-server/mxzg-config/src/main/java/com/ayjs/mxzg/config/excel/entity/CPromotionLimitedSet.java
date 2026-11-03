package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;

import lombok.Getter;

/**
 * 限时礼包
 */
@Getter
public class CPromotionLimitedSet implements BaseExcelModel {
    /**
     * ID前段排序
     */
    private int idx;
    /**
     * 星级
     */
    private int star;
    /**
     *
     */
    private int last_time;

    /***
     *
     */
    @Deprecated
    private int max_num;

    @Override
    public int getExcelId() {
        return idx;
    }
}
