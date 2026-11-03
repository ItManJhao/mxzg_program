package com.ayjs.mxzg.config.excel.entity.promotion;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 诸神之战奖励
 *
 * @Author: CWJ
 * @Date: 2019/10/18
 **/
@Getter
public class CPromotion034PveReward implements BaseExcelModel {
    /**id集合*/
    private int idx;
    /**轮次*/
    private int turns;
    /**副本类型*/
    private int mission_type;
    /**关卡等级*/
    private int mission_id;
    /**通关奖励*/
    private ImmutableList<ImmutableThing> final_reward;
    /**随机奖励*/
    private ImmutableList<ImmutableThing> random_reward;
    /**战斗名字*/
    private String name_lang;
    /**战斗类型*/
    private int battle_type;

    @Override
    public int getExcelId() {
        return idx;
    }
}
