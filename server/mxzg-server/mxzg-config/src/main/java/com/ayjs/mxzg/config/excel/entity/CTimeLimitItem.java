package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 期限道具
 *
 * @author hyx
 */
@Getter
public class CTimeLimitItem implements BaseExcelModel {

    private int item_id;

    private int type;

    private int valid_time;

    private ImmutableList<ImmutableThing> reward;

    @Override
    public int getExcelId() {
        return item_id;
    }
}

