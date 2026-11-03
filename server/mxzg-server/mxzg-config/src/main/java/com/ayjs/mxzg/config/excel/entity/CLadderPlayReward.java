package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.common.util.IDrop;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;
import lombok.Setter;

/**
 * @Author: CWJ
 * @Date: 2020/1/3
 **/
@Getter
@Setter
public class CLadderPlayReward implements BaseExcelModel, IDrop {

    private int type;

    private ImmutableList<ImmutableThing> reward;

    private int chance;

    @Override
    public int getExcelId() {
        return type;
    }

    @Override
    public int getDropId() {
        return type;
    }

    @Override
    public int getRate() {
        return chance;
    }
}
