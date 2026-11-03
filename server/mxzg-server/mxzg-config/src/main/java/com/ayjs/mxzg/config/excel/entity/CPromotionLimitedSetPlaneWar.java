package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import lombok.Getter;

/**
 * 限时礼包
 */
@Getter
public class CPromotionLimitedSetPlaneWar implements BaseExcelModel {
    /**
     * ID前段排序
     */
    private int idx;
    /**
     * 元素
     */
    private int element;
    /**
     * 等级
     */
    private int level;

    /****
     * 购买时限
     */
    private int limit_time;


    @Override
    public int getExcelId() {
        return idx;
    }
}
