package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import lombok.Getter;

/**
 * 防御系数
 */
@Getter
public class CBattleDefend implements BaseExcelModel {
    /**
     * 星级
     */
    private int star;
    /**
     * 防御系数
     */
    private int rate;

    @Override
    public int getExcelId() {
        return star;
    }
}
