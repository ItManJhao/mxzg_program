package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableMap;
import lombok.Getter;

/**
 * 皮肤（时装）升级
 * @author hyx
 */
@Getter
public class CHeroFashionUp implements BaseExcelModel {

    private int idx;

    private int fashion_id;

    private int level;

    private ImmutableList<ImmutableThing> need_item;

    private ImmutableMap<AttributeType, Long> ability;

    @Override
    public int getExcelId() {
        return idx;
    }
}
