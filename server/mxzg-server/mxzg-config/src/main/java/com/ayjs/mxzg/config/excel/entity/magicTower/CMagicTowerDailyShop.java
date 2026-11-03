package com.ayjs.mxzg.config.excel.entity.magicTower;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.excel.entity.shop.IShop;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * @Author: CWJ
 * @Date: 2020/6/18
 **/
@Getter
public class CMagicTowerDailyShop implements BaseExcelModel, IShop {

    private int idx;

    private int chance;
    // 购买消耗
    private ImmutableList<ImmutableThing> item_type;
    // 道具
    private ImmutableList<ImmutableThing> need_item;

    private int buy_limit;

    private int star;

    private int appear_level;

    private int limit_type;


    @Override
    public int getExcelId() {
        return idx;
    }

}
