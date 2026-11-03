package com.ayjs.mxzg.gameserver.module.promotionNew.handler;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion033CombineSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion033Combine;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion033HeroCombine;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.promotionNew.event.ActivityRewardEvent;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion033HeroCombineService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.protocol.Promotion033GMsg;
import com.ayjs.mxzg.protocol.TaskObjGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

/**
 * @Author: CWJ
 * @Date: 2019/10/23
 **/
@Controller
public class Promotion033HeroCombineHandler extends ProtocolHandler {

    @Autowired
    private Promotion033HeroCombineService promotion033HeroCombineService;
    @Autowired
    private PromotionControlService promotionControlService;
    @Autowired
    private Promotion033CombineSysCache promotion033CombineSysCache;
    @Autowired
    private ThingService thingService;
    @Autowired
    private EventBus eventBus;


    @CMD(id = CmdCode._13093)
    public void heroCombineData(PlayerContext playerContext, Promotion033GMsg.GReqMarkHeroList req) {
        Promotion033GMsg.GResMarkHeroList.Builder builder = Promotion033GMsg.GResMarkHeroList.newBuilder();
        PromotionControl control = promotionControlService.getControl(PromotionType.HE_CHENG_JUE_XING);

        Promotion033HeroCombine heroCombine = promotion033HeroCombineService.getPromotionInfo(playerContext.getId());

        heroCombine.getCountRecord().forEach((id, count) -> {
            TaskObjGMsg.PSMakeHeroData.Builder builder1 = TaskObjGMsg.PSMakeHeroData.newBuilder();
            builder1.setCombineNum(count);
            builder1.setRewardNum(heroCombine.getRewardRecord().getOrDefault(id, 0));
            builder1.setIdx(id);
            builder.addList(builder1);
        });
        playerContext.write(CmdCode._13093, builder.build());
    }

    @CMD(id = CmdCode._13094)
    public void rewardHeroCombine(PlayerContext playerContext, Promotion033GMsg.GReqMarkHeroGift req) {
        int idx = req.getIdx();
        CPromotion033Combine config = promotion033CombineSysCache.getOrThrow(idx);
        Promotion033HeroCombine heroCombine = promotion033HeroCombineService.getPromotionInfo(playerContext.getId());

        Asserts.isTrue(promotionControlService.isPromotionRunning(PromotionType.HE_CHENG_JUE_XING), "活动已结束");
        int reward = heroCombine.getRewardRecord().getOrDefault(idx, 0);

        Asserts.isTrue(reward < config.getReward_limit(), ErrorCode.PROMOTION_REWARD_ALREADY_GET.getValue(),String.format("活动次数已经领完,领取次数{%s}，限制次数：{%s}",reward, config.getReward_limit()));

        heroCombine.getRewardRecord().put(idx, reward + 1);
        promotion033HeroCombineService.updatePromotion(heroCombine);
        thingService.add(playerContext.getId(), config.getReward(), GameEvent.COMBINE_GIFT);

        playerContext.write(CmdCode._13094, Promotion033GMsg.GResMarkHeroGift.newBuilder().build());

        eventBus.post(ActivityRewardEvent.of(playerContext.getId(), PromotionType.HE_CHENG_JUE_XING, idx));
    }
}
