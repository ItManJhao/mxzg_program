package com.ayjs.mxzg.config.excel.entity.stageMatch.rim;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;
import lombok.Setter;

/**
 * @Author: CWJ
 * @Date: 2020/6/16
 **/
@Getter
@Setter
public class CSuperStageTokenReward implements BaseExcelModel {

    private int idx;

    private int win_count;

    private ImmutableList<ImmutableThing> reward;

    private ImmutableList<ImmutableThing> token_reward;

    @Override
    public int getExcelId() {
        return idx;
    }
}
