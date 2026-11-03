package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import lombok.Getter;

/**
 * 限时礼包
 */
@Getter
public class CPromotionLimitedSetDay implements BaseExcelModel {
    /**
     * ID前段排序
     */
    private int idx;
    /**
     * CPromotionLimitedSet.idx
     */
    private int type;
    /**
     * 限制起始天数
     */
    private int start_day;

    /***
     * 限制结束天数
     */
    private int end_day;

    /***
     * 可购买数量限制
     */
    private int buy_max_num;

    /***
     *
     * 可展示数量限制
     */
    private int show_max_num;

    @Override
    public int getExcelId() {
        return idx;
    }
}
