package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import lombok.Getter;

/**
 * 段位赛周期表
 */
@Getter
public class CSuperStageRank implements BaseExcelModel {

    /**
     * 排名
     */
    private int idx;
    /**
     * 称号id
     */
    private int title_id;


    @Override
    public int getExcelId() {
        return idx;
    }
}
