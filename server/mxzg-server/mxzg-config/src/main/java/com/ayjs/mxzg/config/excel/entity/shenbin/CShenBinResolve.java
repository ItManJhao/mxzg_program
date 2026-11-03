package com.ayjs.mxzg.config.excel.entity.shenbin;


import com.ayjs.mxzg.common.excel.BaseExcelModel;
import lombok.Getter;

/**
 * 神兵分解
 */
@Getter
public class CShenBinResolve implements BaseExcelModel {

    private int id;//id 品质
    private int percent;//百分比

    @Override
    public int getExcelId() {
        return id;
    }
}
