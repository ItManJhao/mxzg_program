package com.ayjs.mxzg.config.excel.entity.teamArena;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * @Author: CWJ
 * @Date: 2020/4/14
 **/
@Getter
public class CTeamArenaRankReward implements BaseExcelModel {

    private int idx;
    private int rank_low;
    private int rank_up;

    private ImmutableList<ImmutableThing> reward;

    @Override
    public int getExcelId() {
        return idx;
    }
}
