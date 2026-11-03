package com.ayjs.mxzg.gameserver.log.shop.observer;

import cn.hutool.core.collection.CollectionUtil;
import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.gameserver.log.shop.domain.ShopLog;
import com.ayjs.mxzg.gameserver.module.shop.event.ShopBuyEvent;
import com.ayjs.mxzg.template.log.LogEntityFactory;
import com.ayjs.mxzg.template.log.LogService;
import org.springframework.beans.factory.annotation.Autowired;

@Observer
public class ShopLogObserver {
    @Autowired
    private LogService logService;
    @Autowired
    private LogEntityFactory logEntityFactory;

    @Subscribe(async = Subscribe.AsyncType.AsyncLog)
    private void listen(ShopBuyEvent event) {
        ShopLog shopLog = logEntityFactory.create(ShopLog.class);
        shopLog.setRid(event.getRid());
        shopLog.setShopType(event.getShopType().getValue());
        shopLog.setShopIdx(event.getShopIdx());
        shopLog.setBuyTimes(event.getBuyTimes());
        if (CollectionUtil.isNotEmpty(event.getCostItemStr())) {
            ImmutableThing immutableThing = event.getCostItemStr().get(0);
            shopLog.setCostItemType(immutableThing.getItem_type());
            shopLog.setCostItemNum(immutableThing.getItem_num());
        }
        if (CollectionUtil.isNotEmpty(event.getRewardItemStr())) {
            ImmutableThing immutableThing = event.getRewardItemStr().get(0);
            shopLog.setRewardItemType(immutableThing.getItem_type());
            shopLog.setRewardItemNum(immutableThing.getItem_num());
        }
        shopLog.setDateTime(TimeDateUtil.getCurrentTimeInt());
        logService.addLog(shopLog);
    }
}
