package com.ayjs.mxzg.config.excel.entity.promotion;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.common.util.IDrop;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 龙舟翻牌配置表
 *
 * @author hyx
 */
@Getter
public class CPromotion064DragonBoatCard implements BaseExcelModel, IDrop {

    private int idx;

    private int turns;

    private int type;

    private int chance;

    private int show_min;

    private int show_num;

    private ImmutableList<ImmutableThing> reward;

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
