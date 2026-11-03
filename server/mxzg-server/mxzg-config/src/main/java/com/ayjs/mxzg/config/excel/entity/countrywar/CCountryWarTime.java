package com.ayjs.mxzg.config.excel.entity.countrywar;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import lombok.Getter;

import java.time.LocalDateTime;

/**
 * @Author: CWJ
 * @Date: 2021/4/12
 **/
@Getter
public class CCountryWarTime implements BaseExcelModel {

    private int idx;
    private int stage;
    private int round;
    /***
     * 国战类型
     */
    private int type;
    /**
     * 开始时间
     */
    private LocalDateTime start_time;
    /**
     * 匹配结束时间点
     */
    private LocalDateTime match_end_time;

    @Override
    public int getExcelId() {
        return idx;
    }
}
