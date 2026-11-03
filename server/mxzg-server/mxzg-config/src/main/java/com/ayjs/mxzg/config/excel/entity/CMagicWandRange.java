package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import lombok.Getter;

@Getter
public class CMagicWandRange implements BaseExcelModel {

    private int idx;
    // 属性类型
    private int attr_type;
    // 魔杖品质
    private int rare;
    // 属性最低增加
    private int low;
    // 属性最高增加
    private int high;
    // 属性最低值
    private int min;
    // 属性的最大值
    private int max;
    @Override
    public int getExcelId() {
        return idx;
    }
}
