package com.ayjs.mxzg.config.excel.entity.shenbin;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import lombok.Getter;

/**
 * 神兵孔位
 */
@Getter
public class CShenBinHole implements BaseExcelModel {

    private int id;
    private int job;//职业
    private int corelv;//核心等级
    private int hole;//孔位
    private int sb_id;//神兵


    @Override
    public int getExcelId() {
        return id;
    }
}
