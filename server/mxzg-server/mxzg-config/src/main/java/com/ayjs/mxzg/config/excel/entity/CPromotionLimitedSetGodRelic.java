package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import lombok.Getter;

/**
 * 诸神遗迹通关礼包
 */
@Getter
public class CPromotionLimitedSetGodRelic implements BaseExcelModel {

    private int idx;

    private int god_relic_id;

    private int last_time;

    private int limit_num;

    @Override
    public int getExcelId() {
        return idx;
    }
}
