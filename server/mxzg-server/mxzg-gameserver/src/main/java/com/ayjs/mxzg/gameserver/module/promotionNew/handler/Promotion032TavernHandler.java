package com.ayjs.mxzg.gameserver.module.promotionNew.handler;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion032TavernSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion032Tavern;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion032Tavern;
import com.ayjs.mxzg.gameserver.module.promotionNew.event.Promotion032TavernRewardEvent;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion032TavernService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.protocol.Promotion032GMsg;
import com.ayjs.mxzg.protocol.TaskObjGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * 酒馆达标
 *
 * @Author: CWJ
 * @Date: 2019/10/24
 **/
@Component
public class Promotion032TavernHandler extends ProtocolHandler {
    @Autowired
    private Promotion032TavernService promotion032TavernService;
    @Autowired
    private Promotion032TavernSysCache promotion032TavernSysCache;
    @Autowired
    private PromotionControlService promotionControlService;
    @Autowired
    private ThingService thingService;
    @Autowired
    private EventBus eventBus;

    @CMD(id = CmdCode._13106)
    public void tavernData(PlayerContext playerContext, Promotion032GMsg.GReqPubArriveInfo req) {
        Promotion032Tavern promotion032Tavern = promotion032TavernService.getPromotionInfo(playerContext.getId());
//        PromotionControl promotionControl = promotionControlService.getControl(PromotionType.JIU_GUAN_DA_BIAO);
        Promotion032GMsg.GResPubArriveInfo.Builder builder = Promotion032GMsg.GResPubArriveInfo.newBuilder();
        promotion032TavernService.updatePromotion(promotion032Tavern);

        promotion032TavernSysCache.getAll().forEach(config -> {
            TaskObjGMsg.PSSummonCrystalData.Builder builder1 = TaskObjGMsg.PSSummonCrystalData.newBuilder();
            builder1.setIdx(config.getIdx());
            builder1.setProgress(promotion032Tavern.getCountMap().getOrDefault(config.getIdx(), 0));
            builder1.setIsBought(promotion032Tavern.getRewardMap().contains(config.getIdx()) ? 1 : 0);
            builder.addList(builder1);
        });
        playerContext.write(CmdCode._13106, builder.build());
    }

    @CMD(id = CmdCode._13107)
    public void tavernReward(PlayerContext playerContext, Promotion032GMsg.GReqPubArriveGot req) {
        Promotion032Tavern promotion032Tavern = promotion032TavernService.getPromotionInfo(playerContext.getId());
//        PromotionControl promotionControl = promotionControlService.getControl(PromotionType.JIU_GUAN_DA_BIAO);

        CPromotion032Tavern config = promotion032TavernSysCache.getOrThrow(req.getIdx());

        Asserts.isTrue(config.getNum() <= promotion032Tavern.getCountMap().getOrDefault(config.getIdx(), 0), "任务完成数不足");

        Asserts.isTrue(promotionControlService.isPromotionRunning(PromotionType.JIU_GUAN_DA_BIAO),
                ErrorCode.PROMOTION_NOT_STARTING.getValue(), "活动未进行中");

        Asserts.isTrue(!promotion032Tavern.getRewardMap().contains(config.getIdx()),
                ErrorCode.PROMOTION_ID_HAD_REWARD.getValue(), String.format("已领取{%s},请求领取{%s}", promotion032Tavern.getRewardMap(), config.getIdx()));

        promotion032Tavern.getRewardMap().add(config.getIdx());
        promotion032TavernService.updatePromotion(promotion032Tavern);
        thingService.add(playerContext.getId(), config.getReward(), GameEvent.TAVERN_GOT);

        Promotion032GMsg.GResPubArriveGot.Builder builder = Promotion032GMsg.GResPubArriveGot.newBuilder();
        playerContext.write(CmdCode._13107, builder.build());

        eventBus.post(Promotion032TavernRewardEvent.of(playerContext.getId(), config.getIdx()));
    }


}
