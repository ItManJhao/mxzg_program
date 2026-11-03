package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.google.common.collect.ImmutableMap;
import lombok.Getter;

/**
 * 尊贵标识
 * @author hyx
 */
@Getter
public class CPeerageEmblem implements BaseExcelModel {

    private int level;

    private long recharge;

    private String nick;

    private ImmutableMap<AttributeType, Long> ability;

    @Override
    public int getExcelId() {
        return level;
    }
}
