package com.ayjs.mxzg.config.excel.entity.runeStone;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.Attribute;
import com.google.common.collect.ImmutableMap;
import lombok.Getter;

/**
 * 符石强化套装
 *
 * @Author: CWJ
 * @Date: 2020/7/29
 **/
@Getter
public class CRuneStoneIntensifySuit implements BaseExcelModel {

    private int idx;
    private int intensify;
    private ImmutableMap<Attribute, Long> attr;

    @Override
    public int getExcelId() {
        return idx;
    }
}
