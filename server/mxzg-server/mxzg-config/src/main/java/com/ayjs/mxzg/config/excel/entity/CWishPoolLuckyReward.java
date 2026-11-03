package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 幸运值表
 */
@Getter
public class CWishPoolLuckyReward implements BaseExcelModel {
    /***
     * 标识
     */
    private int idx;

    /***
     * 类型
     */
    private int type;

    /***
     * 幸运值
     */
    private int lucky_value_need;

    /***
     * 奖励
     */
    private ImmutableList<ImmutableThing> reward;

    @Override
    public int getExcelId() {
        return idx;
    }
}
