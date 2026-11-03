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
public class CTeamArenaChallengeReward implements BaseExcelModel {

    private int idx;
    private int need_count;

    private ImmutableList<ImmutableThing> reward;

    @Override
    public int getExcelId() {
        return idx;
    }
}
