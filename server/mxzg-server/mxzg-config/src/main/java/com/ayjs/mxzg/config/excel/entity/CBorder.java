package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import lombok.Getter;

/**
 * @Author: CWJ
 * @Date: 2019/10/28
 **/
@Getter
public class CBorder implements BaseExcelModel {
    private int icon;
    /**
     * 激活类型
     */
    private int active_type;
    /**
     * 激活条件，当类型是道具激活的时候，代表消耗，当类型是条件的时候，配置条件
     */
    private String condition;
    private int limit_time;

    @Override
    public int getExcelId() {
        return icon;
    }
}
