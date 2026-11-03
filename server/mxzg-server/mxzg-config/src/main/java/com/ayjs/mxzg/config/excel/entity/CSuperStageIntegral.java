package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import lombok.Getter;

/**
 * 段位分差表
 */
@Getter
public class CSuperStageIntegral implements BaseExcelModel {

    /**
     * 主键
     */
    private int idx;
    /**
     * 积分差
     */
    private int points_difference;
    /**
     * 胜利积分
     */
    private int victory_points;
    /**
     * 保护积分
     */
    private int failure_points;

    @Override
    public int getExcelId() {
        return idx;
    }
}
