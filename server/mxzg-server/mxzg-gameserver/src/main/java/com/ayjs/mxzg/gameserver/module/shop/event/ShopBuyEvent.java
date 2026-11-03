package com.ayjs.mxzg.gameserver.module.shop.event;

import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.gameserver.module.shop.constant.ShopType;
import lombok.Value;

import java.util.List;

/**
 * 商店购买商品事件
 */
@Value(staticConstructor = "of")
public class ShopBuyEvent {

    private long rid;
    /**
     * 商店类型
     */
    private ShopType shopType;
    /**
     * 购买的下表
     */
    private int shopIdx;
    /**
     * 消耗
     */
    private List<ImmutableThing> costItemStr;
    /**
     * 获得
     */
    private List<ImmutableThing> rewardItemStr;
    /**
     * 购买次数
     */
    private int buyTimes;

}
