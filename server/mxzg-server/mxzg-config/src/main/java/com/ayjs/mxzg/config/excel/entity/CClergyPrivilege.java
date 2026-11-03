package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ClergyPrivilege;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;

import lombok.Getter;

/**
 * 神职特权
 * @author hyx
 */
@Getter
public class CClergyPrivilege implements BaseExcelModel {

    private int clergy_level;

    private int unlock_need_exp;

    private ClergyPrivilege unlock_privilege;

    private ImmutableList<ImmutableThing> reward;

    @Override
    public int getExcelId() {
        return clergy_level;
    }
}
