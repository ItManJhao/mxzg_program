package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.TargetStruct;
import com.google.common.collect.ImmutableList;

import lombok.Getter;
import lombok.Setter;

/**
 * 活动通行证任务表
 * @author hyx
 */
@Getter
@Setter
public class CPromotionTrafficPermit implements BaseExcelModel {

    private int idx;

    private int config_turns;//配置轮次

    private int task_type;//任务类型

    private int turns;//任务轮次

    private TargetStruct mission;//任务目标

    private ImmutableList<ImmutableThing> exp;//经验奖励

    //private TargetStruct targetStruct;

  /*  public TargetStruct getTargetStruct() {
        if (targetStruct == null)
            targetStruct = JsonUtil.parseJson(mission, TargetStruct.class);
        return targetStruct;
    }*/

    @Override
    public int getExcelId() {
        return idx;
    }
}
