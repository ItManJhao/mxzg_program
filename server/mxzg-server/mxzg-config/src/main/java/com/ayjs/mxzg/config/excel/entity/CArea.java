package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import lombok.Getter;

/**
 * 省市数据
 */
@Getter
public class CArea implements BaseExcelModel {

    private int idx;// 唯一标识键

    private String province;// 省份

    private String city;// 城市

    @Override
    public int getExcelId() {
        return idx;
    }
}
