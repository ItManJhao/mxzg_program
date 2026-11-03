package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.LineUpType;
import lombok.Getter;

/**
 * 战斗类型
 */
@Getter
public class CBattleType implements BaseExcelModel {
    /**
     * 战斗类型
     */
    private int type;
    /**
     * 注释
     */
    private String note;
    /**
     * 最大回合数
     */
    private int round_max;
    /**
     * 是否可以跳过
     */
    private int skip_battle;
    /**
     * 出战阵营
     */
    private LineUpType line_up_type;
    /**
     * 英雄上阵等级限制
     */
    private int hero_need_level;

    @Override
    public int getExcelId() {
        return type;
    }
}
