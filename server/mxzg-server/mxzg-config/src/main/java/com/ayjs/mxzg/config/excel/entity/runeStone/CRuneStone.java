package com.ayjs.mxzg.config.excel.entity.runeStone;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.RuneStoneThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

import java.util.Map;

/**
 * 符石
 *
 * @Author: CWJ
 * @Date: 2020/7/29
 **/
@Getter
public class CRuneStone implements BaseExcelModel {

    private int idx;
    private int quality;
    private int intensify;
    private int kind;
    private Map<Integer, Integer> main_aptitude;
    private int init_extra_num;
    //合成或升级消耗
    private ImmutableList<RuneStoneThing> combine_cost_stone;
    private ImmutableList<ImmutableThing> combine_cost_item;

    //分解奖励
    private ImmutableList<RuneStoneThing> break_stone;
    private ImmutableList<ImmutableThing> break_item;


    @Override
    public int getExcelId() {
        return idx;
    }
}
