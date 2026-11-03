package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.common.util.IDrop;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 奖励组
 */
@Getter
public class CRewardGroup implements BaseExcelModel, IDrop {
    /**
     * 唯一id
     */
    private int idx;
    /**
     * 奖励组
     */
    private int group_id;
    /**
     * 道具
     */
    private ImmutableList<ImmutableThing> item;
    /**
     * 权重
     */
    private int weight;

    @Override
    public int getExcelId() {
        return idx;
    }

    @Override
    public int getDropId() {
        return idx;
    }

    @Override
    public int getRate() {
        return weight;
    }
}
