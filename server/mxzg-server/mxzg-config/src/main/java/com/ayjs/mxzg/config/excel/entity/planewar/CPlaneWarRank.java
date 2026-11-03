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
public class CPlaneWarRank implements BaseExcelModel {
    private int idx;
    /***
     * rank_up<rank_down
     */
    private int rank_up;
    private int rank_down;
    private ImmutableList<ImmutableThing> reward;

    @Override
    public int getExcelId() {
        return idx;
    }

}
