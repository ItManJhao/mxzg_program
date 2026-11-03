package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;

import lombok.Getter;

/**
 * @Author: CWJ
 * @Date: 2020/3/23
 **/
@Getter
public class CGodRelicUnlock implements BaseExcelModel {

    private int idx;
    private int unlock_need_star;

    @Override
    public int getExcelId() {
        return idx;
    }


}
