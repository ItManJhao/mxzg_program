package com.ayjs.mxzg.config.excel.entity.crusadegroup;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.CrusadeGroupStage;
import lombok.Getter;

import java.time.LocalDateTime;

/**
 * 讨伐团周期表
 */
@Getter
public class CCrusadeGroupCycle implements BaseExcelModel {

    /**
     * 主键
     */
    private int idx;
    /**
     * 回合
     */
    private int round;
    /**
     * 开始时间
     */
    private LocalDateTime start_time;
    /**
     * 阶段类型
     */
    private CrusadeGroupStage stage_type;

    @Override
    public int getExcelId() {
        return idx;
    }
}
