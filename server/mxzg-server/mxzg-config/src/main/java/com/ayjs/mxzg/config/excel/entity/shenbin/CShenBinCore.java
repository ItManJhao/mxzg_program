package com.ayjs.mxzg.config.excel.entity.shenbin;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.SkillScript;
import com.google.common.collect.ImmutableMap;
import lombok.Getter;

import java.util.List;

/**
 * 神兵核心
 */
@Getter
public class CShenBinCore implements BaseExcelModel {

    private int id;
    private int job;//职业
    private int corelv;//核心等级
    private int teamlv;//讨伐团职级等级
    private ImmutableMap<AttributeType, Long> attr;
    private List<SkillScript> skills;//核心技能


    @Override
    public int getExcelId() {
        return id;
    }
}
