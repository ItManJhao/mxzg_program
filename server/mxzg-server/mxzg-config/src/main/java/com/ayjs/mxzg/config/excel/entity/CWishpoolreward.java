package com.ayjs.mxzg.config.excel.entity;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 许愿池
 */
@Getter
public class CWishpoolreward implements BaseExcelModel {
    /**
     * idx
     */
    private int idx;
    /**
     * 许愿池类型（1低级2高级）
     */
    private int wishpool_type;
    /***
     * 最小等级
     */
    private int min_lv;
    /**
     * 最大等级
     */
    private int max_lv;
    /**
     * 许愿池位置
     */
    private int place;
    /***
     * 位置概率
     */
    private int place_chance;
    /**
     * 是否有获取限制（0为无限，1为限制获取1次）
     */
    private int gain_limit;
    /**
     * 幸运公告（0没有，1有公告）
     */
    private int rare_broadcast;
    /**
     * reward
     */
    private ImmutableList<ImmutableThing> reward;

    @Override
    public int getExcelId() {
        return idx;
    }
}
