package com.ayjs.mxzg.config.excel.entity.occupation;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.TargetStruct;
import lombok.Getter;

/**
 * 职级任务模板
 */
@Getter
public class COccupationTask implements BaseExcelModel {

    private int id;//任务id
    private int oc_id;//职级id
    private TargetStruct task;//任务目标


    @Override
    public int getExcelId() {
        return id;
    }
}
