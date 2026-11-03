package com.ayjs.mxzg.config.excel.entity.promotion;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.common.util.IDrop;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;


/**
 * 周末锦鲤奖池组
 * @author hyx
 */
@Getter
public class CPromotion067WeekendKoiPond implements BaseExcelModel, IDrop {

    private int idx;

    private int pond_type;

    private int chance;

    private int show_num;

    private ImmutableList<ImmutableThing> reward;

    private int rare;

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
        return chance;
    }

}