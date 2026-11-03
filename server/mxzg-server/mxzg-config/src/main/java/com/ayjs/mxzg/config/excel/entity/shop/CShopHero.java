package com.ayjs.mxzg.config.excel.entity.shop;
import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;

import lombok.Getter;


/**
 * 英雄商店
 */
@Getter
public class CShopHero implements BaseExcelModel, IShop {

    private int idx;

    private int chance;

    private ImmutableList<ImmutableThing> item_type;

    private ImmutableList<ImmutableThing> need_item;

    private int limit_type;

    private int buy_limit;



    @Override
    public int getExcelId() {
        return idx;
    }
}
