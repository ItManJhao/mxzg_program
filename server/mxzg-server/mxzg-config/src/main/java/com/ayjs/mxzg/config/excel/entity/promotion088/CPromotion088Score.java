package com.ayjs.mxzg.config.excel.entity.promotion088;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * @Author: CWJ
 * @Date: 2020/12/14
 **/
@Getter
public class CPromotion088Score implements BaseExcelModel {

    private int idx;

    private ImmutableList<ImmutableThing> cost_item;

    private int get_score;

    private int cost_score;

    private ImmutableList<ImmutableThing> reward;

    @Override
    public int getExcelId() {
        return idx;
    }
}
