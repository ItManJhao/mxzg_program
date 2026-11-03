package com.ayjs.mxzg.gameserver.module.promotionNew.promotion092.observer;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.gameserver.infrastructure.constant.ServerConfig;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.gameserver.remote.large.event.StageCrossConnectEvent;
import com.ayjs.mxzg.message.module.promotion092.message.Promotion092CountRankReqMessage;
import com.ayjs.mxzg.message.module.promotion092.message.Promotion092HeroRankReqMessage;
import com.ayjs.rpc.dispatcher.MessageDispatcher;
import org.springframework.beans.factory.annotation.Autowired;

/**
 * @Author: CWJ
 * @Date: 2021/3/12
 **/
@Observer
public class Promotion092Observer {
    @Autowired
    private MessageDispatcher messageDispatcher;
    @Autowired
    private ServerConfig serverConfig;
    @Autowired
    private PromotionControlService promotionControlService;

    @Subscribe
    public void listen(StageCrossConnectEvent event) {
        PromotionControl control = promotionControlService.getControl(PromotionType.NV_SHEN_XIAN_HUA);
        messageDispatcher.dispatch(Promotion092CountRankReqMessage.of(serverConfig.getServerId(), control.getStartTime()));
        messageDispatcher.dispatch(Promotion092HeroRankReqMessage.of(serverConfig.getServerId(), control.getStartTime()));
    }
}
