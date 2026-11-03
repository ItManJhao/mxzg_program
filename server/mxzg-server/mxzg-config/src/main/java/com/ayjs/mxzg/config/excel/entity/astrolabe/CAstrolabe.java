package com.ayjs.mxzg.config.excel.entity.astrolabe;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.AttributeElement;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2020/4/28
 **/
@Getter
public class CAstrolabe implements BaseExcelModel {

    private int idx;

    private int star;

    private ImmutableList<ImmutableThing> cost;

    private List<Integer> skills;
    private List<AttributeElement> attrs;

    @Override
    public int getExcelId() {
        return idx;
    }
}
