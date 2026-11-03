package com.ayjs.mxzg.config.excel.entity.pet;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import lombok.Getter;

/**
 * @author hyx
 */
@Getter
public class CPet implements BaseExcelModel {

    private int id;

    private int elem;

    private int rate;

    @Override
    public int getExcelId() {
        return id;
    }
}
