package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import lombok.Getter;

@Getter
public class CServerLadderRobotShow implements BaseExcelModel {

    private int idx;

    private int type;

    private int image;

    @Override
    public int getExcelId() {
        return idx;
    }
}
