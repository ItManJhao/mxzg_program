package com.ayjs.mxzg.config.excel.entity.planewar;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * @Author: CWJ
 * @Date: 2020/9/15
 **/
@Getter
public class CPlaneWarLevel implements BaseExcelModel {
    private int idx;
    private int element;
    private int level;
    private int battle_language;
    private ImmutableList<ImmutableThing> reward;
    private int hero_skillid;

    @Override
    public int getExcelId() {
        return idx;
    }

}
