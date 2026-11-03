package com.ayjs.mxzg.config.excel.entity.promotion;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.common.util.JsonUtil;
import com.ayjs.mxzg.config.struct.TargetStruct;

import lombok.Getter;

/**
 * 好战者活动
 */
@Getter
public class CPromotion030MysteryBox implements BaseExcelModel {
	private int idx;
    private int turns;
    private int day;
    //TODO 结构修改
    private String mission;
    private int exp;

    private TargetStruct targetStruct;

    public TargetStruct getTargetStruct() {
        if (targetStruct == null)
            targetStruct = JsonUtil.parseJson(mission, TargetStruct.class);
        return targetStruct;
    }

    @Override
    public int getExcelId() {
        return idx;
    }

}
