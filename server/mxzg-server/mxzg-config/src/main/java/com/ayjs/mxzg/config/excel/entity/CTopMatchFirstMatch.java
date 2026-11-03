package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import lombok.Getter;

/**
 *
 */
@Getter
public class CTopMatchFirstMatch implements BaseExcelModel {
    /**
     * 匹配玩家位置：math.ceil[(R/((math.floor(math.random()*(ratio_up-ratio_low-1)-ratio_low)/10000))]
     */
    private int position;
    /**
     * 系数上限
     */
    private int ratio_up;
    /**
     * 系数下限
     */
    private int ratio_low;

    @Override
    public int getExcelId() {
        return position;
    }
}
