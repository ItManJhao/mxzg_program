package com.ayjs.mxzg.config.excel.entity.shop;

import com.ayjs.mxzg.common.excel.BaseExcelModel;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.google.common.collect.ImmutableList;
import lombok.Getter;

/**
 * 永久皮肤商店
 */
@Getter
public class CShopHeroSkin implements BaseExcelModel {
    // 皮肤唯一idx
    private int fashion_type;
    // 映射id
    private int buy_gem_id;
    // 限购次数
    private int buy_limit;
    // 折扣
    private int discount;

    @Override
    public int getExcelId() {
        return fashion_type;
    }
}
