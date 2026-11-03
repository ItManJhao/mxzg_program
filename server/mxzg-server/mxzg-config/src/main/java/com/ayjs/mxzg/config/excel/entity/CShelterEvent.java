package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import lombok.Getter;

@Getter
public class CShelterEvent implements BaseExcelModel {

    private int idx;

    /**
     * 出现权重
     */
    private int chance;

    /**
     * 多少次必出
     */
    private int guarantee_times;

    /**
     * 单层最大数量
     */
    private int max_each_level;

    @Override
    public int getExcelId() {
        return idx;
    }
}
