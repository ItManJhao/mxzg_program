package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 庇护所药水事件配置表
 * @author hyx
 */
@Getter
public class CShelterEventItem implements BaseExcelModel {

    private int idx;

    private int event_id;

    private ImmutableList<ImmutableThing> reward;

    private int chance;

    @Override
    public int getExcelId() {
        return idx;
    }
}
