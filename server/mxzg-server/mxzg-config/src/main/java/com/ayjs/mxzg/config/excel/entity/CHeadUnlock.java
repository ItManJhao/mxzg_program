package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.TargetStruct;
import lombok.Getter;

@Getter
public class CHeadUnlock implements BaseExcelModel {

    private int icon;

    //解锁类型
    private int unlock_type;

    //任务目标
    private TargetStruct unlock_task;


    @Override
    public int getExcelId() {
        return icon;
    }
}
