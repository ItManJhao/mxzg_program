package com.ayjs.mxzg.config.excel.entity.chat;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import lombok.Getter;

/**
 * @Author: CWJ
 * @Date: 2020/9/19
 **/
@Getter
public class CForbidChat implements BaseExcelModel {

    private int idx;

    private int forbid_time;

    @Override
    public int getExcelId() {
        return idx;
    }
}
