package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.StageType;
import lombok.Getter;

import java.time.LocalDateTime;

/**
 * 段位赛周期表
 */
@Getter
public class CSuperStageCycle implements BaseExcelModel {

    /**
     * 主键
     */
    private int idx;
    /**
     * 赛季
     */
    private int season;
    /**
     * 开始时间
     */
    private LocalDateTime start_time;
    /**
     * 阶段类型
     */
    private StageType stage_type;

    @Override
    public int getExcelId() {
        return idx;
    }
}
