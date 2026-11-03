package com.ayjs.mxzg.config.excel.entity.promotion;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * @Author: CWJ
 * @Date: 2019/10/25
 **/
@Getter
public class CPromotion035HappyTime implements BaseExcelModel {

    private int idx;
    private int turns;
    private int promotion_id;
    private int target_num;
    private ImmutableList<ImmutableThing> finish_reward;
    private ImmutableList<ImmutableThing> privilege_reward;

    @Override
    public int getExcelId() {
        return idx;
    }
}
