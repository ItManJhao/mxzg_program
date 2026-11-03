package com.ayjs.mxzg.config.excel.entity.promotion093;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import lombok.Getter;

/**
 * @Author: CWJ
 * @Date: 2020/12/14
 **/
@Getter
public class CPromotion093Grid implements BaseExcelModel {

    private int idx;
    private int event_type;
    private int event_param;

    @Override
    public int getExcelId() {
        return idx;
    }

}
