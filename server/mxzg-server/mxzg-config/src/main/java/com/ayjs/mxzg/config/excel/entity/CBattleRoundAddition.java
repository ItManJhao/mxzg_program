package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.google.common.collect.ImmutableMap;
import lombok.Getter;

/**
 * 战斗回合加成表
 */
@Getter
public class CBattleRoundAddition implements BaseExcelModel {

    /** 主键*/
    private int idx;

    private int battleType; // 战斗类型

    private int round;  // 回合

    private ImmutableMap<AttributeType, Long> addition; //加成属性
    @Override
    public int getExcelId() {
        return idx;
    }
}
