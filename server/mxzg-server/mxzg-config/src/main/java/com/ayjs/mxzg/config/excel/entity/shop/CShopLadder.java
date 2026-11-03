package com.ayjs.mxzg.config.excel.entity.shop;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 跨服天梯积分商店
 * @author hyx
 */
@Getter
public class CShopLadder implements BaseExcelModel, IShop {

    private int idx;

    private int chance;

    /**
     * 商品道具
     */
    private ImmutableList<ImmutableThing> item_type;
    /**
     * 价格
     */
    private ImmutableList<ImmutableThing> need_item;

    private int limit_type;

    private int buy_limit;


    @Override
    public int getExcelId() {
        return idx;
    }
}
