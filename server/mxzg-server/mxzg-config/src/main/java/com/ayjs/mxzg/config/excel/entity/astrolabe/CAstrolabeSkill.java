package com.ayjs.mxzg.config.excel.entity.astrolabe;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.AttributeElement;
import lombok.Getter;

import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2020/4/28
 **/
@Getter
public class CAstrolabeSkill implements BaseExcelModel {

    private int idx;

    private List<AttributeElement> attrs;

    @Override
    public int getExcelId() {
        return idx;
    }
}
