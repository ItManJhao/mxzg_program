package com.ayjs.mxzg.gameserver.module.promotionNew.handler;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion069RechargeGiftSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion069RechargeGift;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion069RechargeGift;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion069RechargeGiftService;
import com.ayjs.mxzg.protocol.promotion069GMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * @author hyx
 */
@Controller
public class Promotion069RechargeGiftHandler extends ProtocolHandler {

    @Autowired
    private Promotion069RechargeGiftService promotion069RechargeGiftService;
    @Autowired
    private Promotion069RechargeGiftSysCache promotion069RechargeGiftSysCache;
    @Autowired
    private ThingService thingService;

    /**
     * 发送
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._14400)
    public void sendRechargeGiftInfo(PlayerContext playerContext, promotion069GMsg.GReqRechargeGiftInfo msg) {
        Promotion069RechargeGift promotion069RechargeGift = promotion069RechargeGiftService.get(playerContext.getId());
        promotion069RechargeGiftService.sendInfo(promotion069RechargeGift);

    }

    @CMD(id = CmdCode._14401)
    public void getRechargeGiftReward(PlayerContext playerContext, promotion069GMsg.GReqGetRechargeGiftReward msg) {

        Promotion069RechargeGift promotion069RechargeGift = promotion069RechargeGiftService.get(playerContext.getId());
        Asserts.isTrue(promotion069RechargeGift.getOpenTime() <= DateTimeUtil.currentSecond(),
                ErrorCode.PROMOTION_RECHARGE_GIFT_TIME_LIMIT.getValue(), "超值赠礼活动尚未激活");

        Asserts.isTrue(promotion069RechargeGift.getActiveTimeMap().get(msg.getType()) != null,
                ErrorCode.PROMOTION_RECHARGE_GIFT_TYPE_NOT_ACTIVE.getValue(), "超值赠礼活动尚未激活");

        List<ImmutableThing> rewardList = new ArrayList<>();
        List<Integer> idxList = new ArrayList<>();


        List<CPromotion069RechargeGift> configList = promotion069RechargeGiftSysCache.getConfigList(msg.getType());
        //已激活天数
        int day = DateTimeUtil.apartDay(DateTimeUtil.currentSecond(), promotion069RechargeGift.getActiveTimeMap().get(msg.getType())) + 1;
        for (CPromotion069RechargeGift config : configList) {
            if (config.getReward_type() == 0) {
                int time = promotion069RechargeGift.getRewardTimeMap().getOrDefault(config.getIdx(), 0);
                if (time < DateTimeUtil.dayBreak() && day <= promotion069RechargeGiftSysCache.getDay(msg.getType())) {
                    promotion069RechargeGift.getRewardTimeMap().put(config.getIdx(), DateTimeUtil.dayBreak());
                    rewardList.addAll(config.getReward());
                    idxList.add(config.getIdx());
                }
            } else {
                if (config.getNeed_day() <= day && !promotion069RechargeGift.getRewardList().contains(config.getIdx())) {
                    promotion069RechargeGift.getRewardList().add(config.getIdx());
                    rewardList.addAll(config.getReward());
                    idxList.add(config.getIdx());
                }
            }
        }

        Asserts.isTrue(rewardList.size() > 0, ErrorCode.PROMOTION_RECHARGE_GIFT_TYPE_NOT_REWARD.getValue(), "当前没有奖励可领取");

        promotion069RechargeGiftService.update(promotion069RechargeGift);

        thingService.add(playerContext.getId(), rewardList, GameEvent.PROMOTION_RECHARGE_GIFT_REWARD);

        promotion069GMsg.GResGetRechargeGiftReward.Builder builder = promotion069GMsg.GResGetRechargeGiftReward.newBuilder();
        builder.addAllRewardIds(idxList);
        playerContext.write(CmdCode._14401, builder.build());
    }

}
