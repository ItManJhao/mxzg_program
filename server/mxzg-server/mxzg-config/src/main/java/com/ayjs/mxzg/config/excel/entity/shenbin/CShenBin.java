package com.ayjs.mxzg.config.excel.entity.shenbin;


import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableMap;
import lombok.Getter;

/**
 * 神兵模板
 */
@Getter
public class CShenBin implements BaseExcelModel {

    private int id;
    private int sb_id;//神兵id
    private ImmutableList<ImmutableThing> compose_sb;//合成所需神兵
    private ImmutableList<ImmutableThing> compose_item;//合成所需材料
    private ImmutableMap<AttributeType, Long> attr;
    private int quality;//品质1-5

    @Override
    public int getExcelId() {
        return id;
    }
}
