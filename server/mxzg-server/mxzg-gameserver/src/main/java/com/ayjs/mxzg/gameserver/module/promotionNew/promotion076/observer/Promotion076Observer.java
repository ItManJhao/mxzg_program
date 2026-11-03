package com.ayjs.mxzg.gameserver.module.promotionNew.promotion076.observer;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.hero.event.FashionActiveEvent;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion076.converter.Promotion076PB;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion076.service.Promotion076Service;
import org.springframework.beans.factory.annotation.Autowired;
import com.ayjs.mxzg.common.event.annotation.Subscribe;

/**
 * @Author: CWJ
 * @Date: 2020/9/28
 **/
@Observer
public class Promotion076Observer {

    @Autowired
    private Promotion076Service promotion076Service;
    @Autowired
    private Promotion076PB promotion076PB;
    @Autowired
    private ContextManager contextManager;

    @Subscribe
    public void listen(FashionActiveEvent event) {
        if (!promotion076Service.isOpening()) {
            return;
        }
        boolean active = promotion076Service.getAllConfig().stream().filter(config -> config.getFashion_id() == event.getFashionId()
                && event.getStatus() == 0).count() > 0;
        if (active) {
            contextManager.write(event.rid, CmdCode._75821, promotion076PB.buildData(promotion076Service.getPromotionInfo(event.rid)));
        }
    }
}
