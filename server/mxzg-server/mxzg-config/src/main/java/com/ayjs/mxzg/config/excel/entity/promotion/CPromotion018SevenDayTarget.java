package com.ayjs.mxzg.config.excel.entity.promotion;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.TargetStruct;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 七日目标
 * cwj
 */
@Getter
public class CPromotion018SevenDayTarget implements BaseExcelModel {
    //唯一id
    private int idx;
    private int turns;
    //天数
    private int day;
    //任务页签
    private int tag;
    //语言表
    private int tag_lan;
    //重置限制
    private int recharge_require;
    //类型
    /***
     * {@link com.ayjs.mxzg.config.struct.SevenDayTargetKind}
     */
    private int kind;
    //    //任务类型
//    private int type;
//    //数值
//    private int num;
    private TargetStruct task;
    //消耗
    private ImmutableList<ImmutableThing> cost;
    //奖励
    private ImmutableList<ImmutableThing> reward;
    //语言表id
    private int mission_lan;

    @Override
    public int getExcelId() {
        return idx;
    }

}
