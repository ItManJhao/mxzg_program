package com.ayjs.mxzg.gameserver.module.promotionNew.promotion083;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.GJsonUtils;
import com.ayjs.mxzg.common.util.gson.GsonUtils;
import com.ayjs.mxzg.config.excel.cache.promotion083.Promotion083Const;
import com.ayjs.mxzg.config.excel.cache.promotion083.Promotion083LotteryCountRewardSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion083.CPromotion083LotteryCountReward;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion083.converter.Promotion083PB;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion083.domain.Promotion083;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion083.service.Promotion083Service;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion083LotteryRewardConfig;
import com.ayjs.mxzg.protocol.Promotion083GMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.google.common.collect.Lists;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2020/9/22
 **/
@Component
public class Promotion083Handler extends ProtocolHandler {

    @Autowired
    private Promotion083Service promotion083Service;
    @Autowired
    private Promotion083PB promotion083PB;
    @Autowired
    private ThingService thingService;

    @Autowired
    private Promotion083Const promotion083Const;
    @Autowired
    private Promotion083LotteryCountRewardSysCache promotion083LotteryCountRewardSysCache;

    @CMD(id = CmdCode._76041)
    public void getData(PlayerContext playerContext, Promotion083GMsg.GReqBlackFiveLotteryGetDataInfo req) {
        if (!promotion083Service.isOpening()) {
            playerContext.write(CmdCode._76041, Promotion083GMsg.GReqBlackFiveLotteryGetDataInfo.getDefaultInstance());
            return;
        }
        playerContext.write(CmdCode._76041, promotion083PB.buildData(promotion083Service.getPromotionInfo(playerContext.getId())));
    }

    @CMD(id = CmdCode._76042)
    public void select(PlayerContext playerContext, Promotion083GMsg.GReqBlackFiveLotterySelect req) {

        Asserts.isTrue(promotion083Service.isOpening(), ErrorCode.PROMOTION_NOT_RUNNING.getValue(), String.format("活动为开启！"));

        Promotion083 promotionInfo = promotion083Service.getPromotionInfo(playerContext.getId());

        int rewardIdx = req.getSelectInfo().getKey();
        int rewardIndex = req.getSelectInfo().getValue();

        Promotion083LotteryRewardConfig config = promotion083Service.getConfig(rewardIdx);

        Asserts.isTrue(config.getNeed_select() == 1,
                ErrorCode.PROMOTION_083_CANT_SELECT.getValue(),
                String.format("不需要选择奖励{%s}", rewardIdx));

        Asserts.isTrue(rewardIndex >= 1 & rewardIndex <= config.getRewardThings().size(),
                ErrorCode.SYSTEM_ERROR.getValue(),
                String.format("奖励索引错误{%s}", rewardIndex));

        if (promotionInfo.getSelectInfo().containsKey(rewardIdx)) {
            Asserts.isTrue(thingService.enough(playerContext.getId(), promotion083Const.getLotteryChangeCost()),
                    ErrorCode.ITEM_NUM_LOW.getValue(),
                    String.format("道具不足{%s}", GJsonUtils.toJson(promotion083Const.getLotteryChangeCost())));
            thingService.cost(playerContext.getId(), promotion083Const.getLotteryChangeCost(), GameEvent.PROMOTION_083_CHANGE_COST);
        }

        promotionInfo.getSelectInfo().put(rewardIdx, rewardIndex);
        promotion083Service.updatePromotion(promotionInfo);

        playerContext.write(CmdCode._76042, promotion083PB.buildSelect(rewardIdx, rewardIndex));

    }

    @CMD(id = CmdCode._76043)
    public void lottery(PlayerContext playerContext, Promotion083GMsg.GReqBlackFiveLotteryLottery req) {
        Asserts.isTrue(promotion083Service.isOpening(),
                ErrorCode.PROMOTION_NOT_RUNNING.getValue(),
                String.format("活动为开启！"));
        Promotion083 promotionInfo = promotion083Service.getPromotionInfo(playerContext.getId());
        Asserts.isTrue(promotionInfo.getSelectInfo().size() > 0,
                ErrorCode.PROMOTION_083_TYPE_NOT_SELECT.getValue(),
                String.format("未选择奖励{%s}", promotionInfo.getSelectInfo().size()));

        Asserts.isTrue(req.getNum() == 1 || req.getNum() == 10,
                ErrorCode.PROMOTION_083_LOTTERY_NUM_ERROR.getValue(),
                String.format("抽奖次数错误{%s}", req.getNum()));
        List<ImmutableThing> cost = ImmutableThingUtil.multiplyThing(promotion083Const.getLotteryCost(), req.getNum());
        Asserts.isTrue(thingService.enough(playerContext.getId(), cost),
                ErrorCode.ITEM_NUM_LOW.getValue(),
                String.format("道具数量不足{%s}", GJsonUtils.toJson(cost)));

        thingService.cost(playerContext.getId(), cost, GameEvent.PROMOTION_083_LOTTERY_COST);

        //抽中大奖之后，重置次数
        List<ImmutableThing> list = Lists.newArrayList();
        Promotion083LotteryRewardConfig firstConfig = null;
        for (int i = 0; i < req.getNum(); i++) {
            Promotion083LotteryRewardConfig cPromotion083Reward = promotion083Service.randomReward(promotionInfo);
            if (i == 0) {
                firstConfig = cPromotion083Reward;
                promotionInfo.setLastLotteryIdx(firstConfig.getIdx());
            }
            promotionInfo.setLotteryCount(promotionInfo.getLotteryCount() + 1);

            promotionInfo.setLotteryTurnCount(promotionInfo.getLotteryTurnCount() + 1);
            promotionInfo.getLotteryTurnRecord().add(cPromotion083Reward.getId());
            if (cPromotion083Reward.getNeed_select() == 1) {
                promotionInfo.setLotteryTurnCount(0);
                promotionInfo.getLotteryTurnRecord().clear();
                list.add(cPromotion083Reward.getRewardThings().get(promotionInfo.getSelectInfo().get(cPromotion083Reward.getId()) - 1));
            } else {
                list.addAll(cPromotion083Reward.getRewardThings());
            }
        }
        promotion083Service.updatePromotion(promotionInfo);
        thingService.add(playerContext.getId(), list, GameEvent.PROMOTION_083_LOTTERY_REWARD, NoticeType.SLIENT);
        playerContext.write(CmdCode._76043, promotion083PB.buildLottery(promotionInfo, list, firstConfig.getIdx()));

    }

    @CMD(id = CmdCode._76044)
    public void getCountReward(PlayerContext playerContext, Promotion083GMsg.GReqBlackFiveLotteryGetLotteryCountReward req) {
        Asserts.isTrue(promotion083Service.isOpening(), ErrorCode.PROMOTION_NOT_RUNNING.getValue(), String.format("活动为开启！"));
        CPromotion083LotteryCountReward config = promotion083LotteryCountRewardSysCache.getOrThrow(req.getIdx());
        Promotion083 promotionInfo = promotion083Service.getPromotionInfo(playerContext.getId());
        Asserts.isTrue(config.getCount() <= promotionInfo.getLotteryCount(),
                ErrorCode.PROMOTION_083_OPEN_COUNT_LOW.getValue(),
                String.format("开箱次数不足{%s}-{%s}", config.getCount(), promotionInfo.getLotteryCount()));

        Asserts.isTrue(!promotionInfo.getLotteryCountRecord().contains(config.getIdx()),
                ErrorCode.PROMOTION_083_COUNT_HAD_REWARD.getValue(),
                String.format("奖励已经领取{%s}-{%s}", config.getIdx(), GsonUtils.toJson(promotionInfo.getLotteryCountRecord())));

        promotionInfo.getLotteryCountRecord().add(config.getIdx());
        promotion083Service.updatePromotion(promotionInfo);
        thingService.add(playerContext.getId(), config.getReward(), GameEvent.PROMOTION_083_LOTTERY_COUNT_REWARD);
        playerContext.write(CmdCode._76044, promotion083PB.buildGetLotteryCount(config.getIdx()));
    }


}
