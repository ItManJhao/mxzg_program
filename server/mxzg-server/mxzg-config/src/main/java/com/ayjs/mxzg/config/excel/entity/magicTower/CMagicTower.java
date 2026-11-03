package com.ayjs.mxzg.config.excel.entity.magicTower;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2020/3/23
 * 诸神遗迹
 **/
@Getter
public class CMagicTower implements BaseExcelModel {

    private int level;
    private int rank;
    private List<Integer> target;
    private ImmutableList<ImmutableThing> reward;
    private ImmutableList<ImmutableThing> first_reward;
    private String language;


    @Override
    public int getExcelId() {
        return level;
    }


}
