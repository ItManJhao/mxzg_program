package com.ayjs.mxzg.config.excel.entity.promotion;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 活动
 *
 * @author HIAPAD
 */
@Getter
public class CPromotion011befall implements BaseExcelModel {

    private int idx;

    private int type;

    private int num;

    private ImmutableList<ImmutableThing> reward;

    private int kind;

    private int can_reward;

    @Override
    public int getExcelId() {
        return idx;
    }

}
