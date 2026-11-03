package com.ayjs.mxzg.gameserver.module.promotionNew.handler;

import com.ayjs.mxzg.common.exception.ErrorCodeException;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion043SummonCrystal;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion043SummonCrystalService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion043SummonCrystalConfig;
import com.ayjs.mxzg.protocol.Promotion043GMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.List;


/**
 * 召唤水晶活动
 */
@Controller
public class Promotion043SummonCrystalHandler extends ProtocolHandler {

    @Autowired
    private Promotion043SummonCrystalService promotion043SummonCrystalService;
    @Autowired
    private PromotionControlService promotionControlService;
    @Autowired
    private ThingService thingService;


    /**
     * 召唤水晶列表
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._13087)
    public void summonCrystalInfo(PlayerContext playerContext, Promotion043GMsg.GReqSummonCrystalInfo msg) {
        promotion043SummonCrystalService.getPromotionProgress(playerContext.getId());
    }

    /**
     * 领取召唤水晶任务奖励
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._13088)
    public void getSummonCrystal(PlayerContext playerContext, Promotion043GMsg.GReqSummonCrystalGet msg) {
        Promotion043GMsg.GResSummonCrystalGet.Builder builder = Promotion043GMsg.GResSummonCrystalGet.newBuilder();
        if (!promotionControlService.isPromotionRunning(PromotionType.ZHAO_HUAN_SHUI_JING)) {
            throw new ErrorCodeException(ErrorCode.PROMOTION_TIME.getValue(), "PromotionType.ZHAO_HUAN_SHUI_JING");
        }

        //获取玩家活动进度
        Promotion043SummonCrystal promotion043SummonCrystal =
                promotion043SummonCrystalService.getPromotionInfo(playerContext.getId());
        //已领取
        if (promotion043SummonCrystal.getRewardList().contains(msg.getIdx())) {
            throw new ErrorCodeException(ErrorCode.PROMOTION_REWARD_ALREADY_GET.getValue(), "PromotionType.ZHAO_HUAN_SHUI_JING");
        }
        //条件不足
        Promotion043SummonCrystalConfig config = promotion043SummonCrystalService.getPromotion(msg.getIdx());
        if (promotion043SummonCrystal.getProgressMap().get(msg.getIdx()) < config.getNum()) {
            throw new ErrorCodeException(ErrorCode.PROMOTION_NOT_PROGRESS.getValue(), "PromotionType.ZHAO_HUAN_SHUI_JING");
        }

        List<Integer> rewardList = promotion043SummonCrystal.getRewardList();
        rewardList.add(msg.getIdx());
        promotion043SummonCrystal.setRewardList(rewardList);
        promotion043SummonCrystalService.updatePromotion(promotion043SummonCrystal);

        thingService.add(playerContext.getId(), ImmutableThingUtil.fromJson(config.getReward()), GameEvent.SUMMON_CRYSTAL, NoticeType.NORMAL);

        playerContext.write(CmdCode._13088, builder.build());

    }

}
