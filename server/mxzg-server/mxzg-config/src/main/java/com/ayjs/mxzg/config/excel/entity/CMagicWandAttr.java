package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.common.util.IDrop;
import lombok.Getter;

@Getter
public class CMagicWandAttr implements BaseExcelModel, IDrop {

    private int idx;
    // 魔杖的品质
    private int rare;
    // 属性type
    private int attr_type;
    // 权重
    private int weight;

    @Override
    public int getExcelId() {
        return idx;
    }

    @Override
    public int getDropId() {
        return idx;
    }

    @Override
    public int getRate() {
        return weight;
    }
}
