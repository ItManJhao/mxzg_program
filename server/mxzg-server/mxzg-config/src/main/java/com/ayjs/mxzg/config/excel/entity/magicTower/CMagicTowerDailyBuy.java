package com.ayjs.mxzg.config.excel.entity.magicTower;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * @Author: CWJ
 * @Date: 2020/3/23
 * 诸神遗迹
 **/
@Getter
public class CMagicTowerDailyBuy implements BaseExcelModel {

    private int idx;
    private ImmutableList<ImmutableThing> need;

    @Override
    public int getExcelId() {
        return idx;
    }

}
