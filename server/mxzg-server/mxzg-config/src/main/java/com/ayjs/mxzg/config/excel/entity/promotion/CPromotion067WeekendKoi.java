package com.ayjs.mxzg.config.excel.entity.promotion;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 周末锦鲤
 * @author hyx
 */
@Getter
public class CPromotion067WeekendKoi implements BaseExcelModel {

    private int idx;

    private int turns;

    private int pond_type;

    private ImmutableList<ImmutableThing> koi_reward;

    private int product_id;

    private int buy_limit;

    @Override
    public int getExcelId() {
        return idx;
    }

}
