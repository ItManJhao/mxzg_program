package com.ayjs.mxzg.config.excel.entity.promotion;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 精灵周卡
 *
 * @author hyx
 */
@Getter
public class CPromotion063ElfWeekCard implements BaseExcelModel {

    private int idx;

    private int turns;

    private int product_id;

    private ImmutableList<ImmutableThing> reward;

    private int buy_limit;

    @Override
    public int getExcelId() {
        return idx;
    }
}
