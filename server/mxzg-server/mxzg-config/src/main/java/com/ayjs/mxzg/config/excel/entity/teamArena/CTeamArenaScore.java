package com.ayjs.mxzg.config.excel.entity.teamArena;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import lombok.Getter;


@Getter
public class CTeamArenaScore implements BaseExcelModel {

    private int idx;
    private int minus;
    private int get_score;
    private int lose_score;


    @Override
    public int getExcelId() {
        return idx;
    }
}
