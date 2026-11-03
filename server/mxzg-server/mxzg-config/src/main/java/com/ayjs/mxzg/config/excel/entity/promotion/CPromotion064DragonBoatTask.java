package com.ayjs.mxzg.config.excel.entity.promotion;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.TargetStruct;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 龙舟任务配置表
 * @author hyx
 */
@Getter
public class CPromotion064DragonBoatTask implements BaseExcelModel {

    private int idx;

    private int day_turns;

    private TargetStruct task_target;

    private ImmutableList<ImmutableThing> task_reward;

    @Override
    public int getExcelId() {
        return idx;
    }
}
