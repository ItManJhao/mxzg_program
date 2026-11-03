package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

@Getter
public class CGoddessReset implements BaseExcelModel {

	private int idx;

	private int times_low;

	private int times_up;

    private ImmutableList<ImmutableThing> need;


    @Override
    public int getExcelId() {
        return idx;
    }
}
