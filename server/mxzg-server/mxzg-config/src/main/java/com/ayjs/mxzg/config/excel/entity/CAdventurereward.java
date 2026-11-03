package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 试炼关卡&宝箱的奖励
 */
@Getter
public class CAdventurereward implements BaseExcelModel {
    /**
     * 关卡id
     */
    private int idx;
    /**
     * 关卡类型（1战斗、2宝箱）
     */
    private int type;

    /**
     * 难度
     */
    private int level;

    /**
     * 关卡
     */
    private int mission;
    /**
     * 奖励
     */
    private ImmutableList<ImmutableThing> reward;
    /**
     * 仅关卡类型为战斗时，以自己战力x%的数值来找对手作为关卡（下限）
     */
    private int enemy_rate_low;
    /**
     * 仅关卡类型为战斗时，以自己战力x%的数值来找对手作为关卡（上限）
     */
    private int enemy_rate_up;
    /**
     * 依照之前一天到达的关卡，决定下一天的起始关卡
     */
    private int reset_begin_idx;

    /**
     * 显示关卡
     */
    private int show_mission;

    @Override
    public int getExcelId() {
        return idx;
    }
}
