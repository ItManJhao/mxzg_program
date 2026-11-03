package com.ayjs.mxzg.gameserver.module.shop.observer;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.config.excel.cache.SystemSysCache;
import com.ayjs.mxzg.config.excel.cache.shop.ShopmarketSysCache;
import com.ayjs.mxzg.config.excel.entity.shop.CShopmarket;
import com.ayjs.mxzg.gameserver.module.fetter.event.GoddessVipLevelUpEvent;
import com.ayjs.mxzg.gameserver.module.role.event.CreateRoleEvent;
import com.ayjs.mxzg.gameserver.module.role.event.LoginEvent;
import com.ayjs.mxzg.gameserver.module.shop.constant.ShopType;
import com.ayjs.mxzg.gameserver.module.shop.domain.Shop;
import com.ayjs.mxzg.gameserver.module.shop.service.ShopService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.HashMap;
import java.util.Map;

/**
 * 事件监听
 */
@Observer
@Slf4j
public class ShopObserver {

    @Autowired
    private SystemSysCache systemSysCache;
    @Autowired
    private ShopService shopService;
    @Autowired
    private ShopmarketSysCache shopmarketSysCache;

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void onEvent(LoginEvent event) {
        shopService.shopControl(event.getRid());
    }

    /**
     * 创号事件
     * @param event
     */
    @Subscribe
    public void createRoleEvent(CreateRoleEvent event){

        Shop shop = shopService.getShop(event.getRid(), ShopType.MARKET);

        Map<Integer,Integer> shopMap = new HashMap<>();
        for(Integer idx : systemSysCache.getMarketInitialItem()){
            CShopmarket cShopmarket = shopmarketSysCache.getOrThrow(idx);
            shopMap.put(idx,0);
        }
        shop.setItems(shopMap);
        shopService.updateShop(shop);

    }

    /**
     * 羁绊升级刷新一次市场数据
     * @param event
     */
    @Subscribe(async = Subscribe.AsyncType.Async)
    public void goddessVipLevelUpEvent(GoddessVipLevelUpEvent event){

        Shop shop = shopService.getShop(event.getRid(), ShopType.MARKET);
        shopService.sendOneShopData0(shop);
    }
}
