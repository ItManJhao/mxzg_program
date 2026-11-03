package com.ayjs.mxzg.config.excel.entity.magicTower;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * @Author: CWJ
 * @Date: 2020/6/18
 **/
@Getter
public class CMagicTowerStarReward implements BaseExcelModel {

    private int idx;
    private int star;
    private ImmutableList<ImmutableThing> reward;


    @Override
    public int getExcelId() {
        return idx;
    }


}
