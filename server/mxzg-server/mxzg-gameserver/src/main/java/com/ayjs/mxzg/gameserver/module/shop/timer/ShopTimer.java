package com.ayjs.mxzg.gameserver.module.shop.timer;

import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.module.shop.service.ShopService;
import com.ayjs.mxzg.template.scheduler.service.AbstractCronTask;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * 商店凌晨刷新定时器
 */
@Component
public class ShopTimer extends AbstractCronTask {

    @Autowired
    private ShopService shopService;
    @Autowired
    private ContextManager contextManager;

    @Override
    public Object identity() {
        return "ShopTimer";
    }

    @Override
    public String expression() {
        return "0 0 0 * * ?";
    }

    @Override
    public void run() {
        // 在线的玩家刷新商店数据
        contextManager.getOnlineRids().stream().filter(rid -> rid > 0).forEach(rid -> shopService.autoRefreshShop(rid));
    }
}
