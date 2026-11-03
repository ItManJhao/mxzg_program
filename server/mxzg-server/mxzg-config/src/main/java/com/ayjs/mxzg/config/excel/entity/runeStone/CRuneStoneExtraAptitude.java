package com.ayjs.mxzg.config.excel.entity.runeStone;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;
import lombok.Setter;

/**
 * 符石资质
 *
 * @Author: CWJ
 * @Date: 2020/7/29
 **/
@Getter
@Setter
public class CRuneStoneExtraAptitude implements BaseExcelModel {

    private int idx;
    private int quality;
    private int kind;
    private int job;
    private int aptitude;
    private long min_value;
    private long max_value;

    private ImmutableList<ImmutableThing> cost;

    @Override
    public int getExcelId() {
        return idx;
    }
}
