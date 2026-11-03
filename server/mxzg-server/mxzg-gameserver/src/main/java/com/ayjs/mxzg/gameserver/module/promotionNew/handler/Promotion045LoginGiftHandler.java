package com.ayjs.mxzg.gameserver.module.promotionNew.handler;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.JsonUtil;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion045LoginGift;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion045LoginGiftService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion045LoginGiftConfig;
import com.ayjs.mxzg.protocol.Promotion045GMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * 登录有礼
 *
 * @Author: CWJ
 * @Date: 2019/11/3
 **/
@Component
public class Promotion045LoginGiftHandler extends ProtocolHandler {

    @Autowired
    private Promotion045LoginGiftService promotion045LoginGiftService;
    @Autowired
    private ThingService thingService;
    @Autowired
    private PromotionControlService promotionControlService;

    @CMD(id = CmdCode._13164)
    public void sendData(PlayerContext playerContext, Promotion045GMsg.GReqLoginGiftData req) {
        Promotion045GMsg.GResLoginGiftData.Builder builder = Promotion045GMsg.GResLoginGiftData.newBuilder();
        Promotion045LoginGift promotion = promotion045LoginGiftService.getPromotionInfo(playerContext.getId());
        builder.addAllRewardIds(promotion.getRewardRecord());
        builder.setDays(promotion.getLoginDays());
        playerContext.write(CmdCode._13164, builder.build());
    }

    @CMD(id = CmdCode._13165)
    public void reward(PlayerContext playerContext, Promotion045GMsg.GReqLoginGiftReward req) {
        Asserts.isTrue(promotionControlService.isPromotionRunning(PromotionType.DENG_LU_YOU_LI),
                ErrorCode.PROMOTION_NOT_RUNNING.getValue(), String.format("活动{%s}已关闭!", PromotionType.DENG_LU_YOU_LI));
        Promotion045LoginGiftConfig config = promotion045LoginGiftService.getConfig(req.getIdx());
        Promotion045LoginGift promotionInfo = promotion045LoginGiftService.getPromotionInfo(playerContext.getId());
        Asserts.notNull(config, ErrorCode.CONFIG_NOT_EXIST.getValue(), String.format("活动配置{%s}不存在!", req.getIdx()));
        Asserts.isTrue(!promotionInfo.getRewardRecord().contains(req.getIdx())
                , ErrorCode.PROMOTION_TOOK_REWARD.getValue(), String.format("已领取记录{%s},请求id{%s}", JsonUtil.toJson(promotionInfo.getRewardRecord()), req.getIdx()));
        promotionInfo.getRewardRecord().add(req.getIdx());
        promotion045LoginGiftService.updatePromotion(promotionInfo);

        thingService.add(playerContext.getId(), ImmutableThingUtil.fromJson(config.getReward()), GameEvent.LOGIN_GIFT);

        Promotion045GMsg.GResLoginGiftReward.Builder builder = Promotion045GMsg.GResLoginGiftReward.newBuilder();
        builder.setIdx(req.getIdx());
        playerContext.write(CmdCode._13165, builder.build());

    }

}
