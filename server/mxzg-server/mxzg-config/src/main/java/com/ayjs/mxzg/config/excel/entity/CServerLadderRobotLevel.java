package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import lombok.Getter;

@Getter
public class CServerLadderRobotLevel implements BaseExcelModel {

    private int team;

    private int level;

    @Override
    public int getExcelId() {
        return team;
    }
}
