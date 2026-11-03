package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.common.util.IDrop;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 随机道具表格
 * @author hyx
 */
@Getter
public class CItemExChange implements BaseExcelModel, IDrop {

    private int idx;
    private int item_type;
    private ImmutableList<ImmutableThing> reward;
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
