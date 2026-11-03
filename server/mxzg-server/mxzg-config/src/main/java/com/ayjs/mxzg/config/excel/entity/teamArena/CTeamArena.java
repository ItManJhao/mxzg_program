package com.ayjs.mxzg.config.excel.entity.teamArena;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.TargetStruct;
import com.google.common.collect.ImmutableList;
import lombok.Getter;


@Getter
public class CTeamArena implements BaseExcelModel {

    private int idx;
    /***
     * 状态切换时间点（以周一0点开始计算）
     */
    private int time;

    @Override
    public int getExcelId() {
        return idx;
    }
}
