package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import lombok.Getter;

/**
 * 皮肤（时装）解锁
 * @author hyx
 */
@Getter
public class CHeroFashionUnlock implements BaseExcelModel {

    private int item_type;

    private int fashion_id;

    private int type;

    private int time_limit;


    @Override
    public int getExcelId() {
        return item_type;
    }
}
