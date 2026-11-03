package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * @Author: CWJ
 * @Date: 2020/3/24
 **/
@Getter
public class CHeroPalace implements BaseExcelModel {
    private int idx;
    private int type;
    private int rank;
    private int num;
    private int elem;
    private int star;
    private ImmutableList<ImmutableThing> reward;
    private int notice;

    @Override
    public int getExcelId() {
        return idx;
    }
}
