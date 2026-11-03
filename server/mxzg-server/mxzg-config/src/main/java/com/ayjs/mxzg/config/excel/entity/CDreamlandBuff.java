package com.ayjs.mxzg.config.excel.entity;

import java.util.List;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.Attribute;

import lombok.Getter;

/**
 * @Author: CWJ
 * @Date: 2019/12/11
 **/
@Getter
public class CDreamlandBuff implements BaseExcelModel {
    private int idx;
    private int type;
    private List<Attribute> buff_id;
    private int add_type;
    private int chance;

    @Override
    public int getExcelId() {
        return idx;
    }
}
