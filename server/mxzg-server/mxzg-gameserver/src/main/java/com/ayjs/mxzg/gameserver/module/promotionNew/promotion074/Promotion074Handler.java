package com.ayjs.mxzg.gameserver.module.promotionNew.promotion074;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.GJsonUtils;
import com.ayjs.mxzg.common.util.gson.GsonUtils;
import com.ayjs.mxzg.config.excel.cache.promotion074.Promotion074Const;
import com.ayjs.mxzg.config.excel.cache.promotion074.Promotion074LotteryCountRewardSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion074.CPromotion074LotteryCountReward;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion074.converter.Promotion074PB;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion074.domain.Promotion074;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion074.service.Promotion074Service;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion074LotteryRewardConfig;
import com.ayjs.mxzg.protocol.Promotion074GMsg;
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
public class Promotion074Handler extends ProtocolHandler {

    @Autowired
    private Promotion074Service promotion074Service;
    @Autowired
    private Promotion074PB promotion074PB;
    @Autowired
    private ThingService thingService;

    @Autowired
    private Promotion074Const promotion074Const;
    @Autowired
    private Promotion074LotteryCountRewardSysCache promotion074LotteryCountRewardSysCache;

    @CMD(id = CmdCode._75801)
    public void getData(PlayerContext playerContext, Promotion074GMsg.GReqMidLotteryGetDataInfo req) {
        if (!promotion074Service.isOpening()) {
            playerContext.write(CmdCode._75801, Promotion074GMsg.GReqMidLotteryGetDataInfo.getDefaultInstance());
            return;
        }
        playerContext.write(CmdCode._75801, promotion074PB.buildData(promotion074Service.getPromotionInfo(playerContext.getId())));
    }

    @CMD(id = CmdCode._75802)
    public void select(PlayerContext playerContext, Promotion074GMsg.GReqMidLotterySelect req) {

        Asserts.isTrue(promotion074Service.isOpening(), ErrorCode.PROMOTION_NOT_RUNNING.getValue(), String.format("活动为开启！"));

        Promotion074 promotionInfo = promotion074Service.getPromotionInfo(playerContext.getId());

        int rewardIdx = req.getSelectInfo().getKey();
        int rewardIndex = req.getSelectInfo().getValue();

        Promotion074LotteryRewardConfig config = promotion074Service.getConfig(rewardIdx);

        Asserts.isTrue(config.getNeed_select() == 1,
                ErrorCode.PROMOTION_074_CANT_SELECT.getValue(),
                String.format("不需要选择奖励{%s}", rewardIdx));

        Asserts.isTrue(rewardIndex >= 1 & rewardIndex <= config.getRewardThings().size(),
                ErrorCode.SYSTEM_ERROR.getValue(),
                String.format("奖励索引错误{%s}", rewardIndex));

        if (promotionInfo.getSelectInfo().containsKey(rewardIdx)) {
            Asserts.isTrue(thingService.enough(playerContext.getId(), promotion074Const.getLotteryChangeCost()),
                    ErrorCode.ITEM_NUM_LOW.getValue(),
                    String.format("道具不足{%s}", GJsonUtils.toJson(promotion074Const.getLotteryChangeCost())));
            thingService.cost(playerContext.getId(), promotion074Const.getLotteryChangeCost(), GameEvent.PROMOTION_074_CHANGE_COST);
        }

        promotionInfo.getSelectInfo().put(rewardIdx, rewardIndex);
        promotion074Service.updatePromotion(promotionInfo);

        playerContext.write(CmdCode._75802, promotion074PB.buildSelect(rewardIdx, rewardIndex));

    }

    @CMD(id = CmdCode._75803)
    public void lottery(PlayerContext playerContext, Promotion074GMsg.GReqMidLotteryLottery req) {
        Asserts.isTrue(promotion074Service.isOpening(),
                ErrorCode.PROMOTION_NOT_RUNNING.getValue(),
                String.format("活动为开启！"));
        Promotion074 promotionInfo = promotion074Service.getPromotionInfo(playerContext.getId());
        Asserts.isTrue(promotionInfo.getSelectInfo().size() > 0,
                ErrorCode.PROMOTION_074_TYPE_NOT_SELECT.getValue(),
                String.format("未选择奖励{%s}", promotionInfo.getSelectInfo().size()));

        Asserts.isTrue(req.getNum() == 1 || req.getNum() == 10,
                ErrorCode.PROMOTION_074_LOTTERY_NUM_ERROR.getValue(),
                String.format("抽奖次数错误{%s}", req.getNum()));
        List<ImmutableThing> cost = ImmutableThingUtil.multiplyThing(promotion074Const.getLotteryCost(), req.getNum());
        Asserts.isTrue(thingService.enough(playerContext.getId(), cost),
                ErrorCode.ITEM_NUM_LOW.getValue(),
                String.format("道具数量不足{%s}", GJsonUtils.toJson(cost)));

        thingService.cost(playerContext.getId(), cost, GameEvent.PROMOTION_074_LOTTERY_COST);

        //抽中大奖之后，重置次数
        List<ImmutableThing> list = Lists.newArrayList();
        Promotion074LotteryRewardConfig firstConfig = null;
        for (int i = 0; i < req.getNum(); i++) {
            Promotion074LotteryRewardConfig cPromotion074Reward = promotion074Service.randomReward(promotionInfo);
            if (i == 0) {
                firstConfig = cPromotion074Reward;
            }
            promotionInfo.setLotteryCount(promotionInfo.getLotteryCount() + 1);

            promotionInfo.setLotteryTurnCount(promotionInfo.getLotteryTurnCount() + 1);
            promotionInfo.getLotteryTurnRecord().add(cPromotion074Reward.getId());
            if (cPromotion074Reward.getNeed_select() == 1) {
                promotionInfo.setLotteryTurnCount(0);
                promotionInfo.getLotteryTurnRecord().clear();
                list.add(cPromotion074Reward.getRewardThings().get(promotionInfo.getSelectInfo().get(cPromotion074Reward.getId()) - 1));
            } else {
                list.addAll(cPromotion074Reward.getRewardThings());
            }
        }
        promotion074Service.updatePromotion(promotionInfo);
        thingService.add(playerContext.getId(), list, GameEvent.PROMOTION_074_LOTTERY_REWARD, NoticeType.SLIENT);
        playerContext.write(CmdCode._75803, promotion074PB.buildLottery(promotionInfo, list, firstConfig.getIdx()));

    }

    @CMD(id = CmdCode._75804)
    public void getCountReward(PlayerContext playerContext, Promotion074GMsg.GReqMidLotteryGetLotteryCountReward req) {
        Asserts.isTrue(promotion074Service.isOpening(), ErrorCode.PROMOTION_NOT_RUNNING.getValue(), String.format("活动为开启！"));
        CPromotion074LotteryCountReward config = promotion074LotteryCountRewardSysCache.getOrThrow(req.getIdx());
        Promotion074 promotionInfo = promotion074Service.getPromotionInfo(playerContext.getId());
        Asserts.isTrue(config.getCount() <= promotionInfo.getLotteryCount(),
                ErrorCode.PROMOTION_074_OPEN_COUNT_LOW.getValue(),
                String.format("开箱次数不足{%s}-{%s}", config.getCount(), promotionInfo.getLotteryCount()));

        Asserts.isTrue(!promotionInfo.getLotteryCountRecord().contains(config.getIdx()),
                ErrorCode.PROMOTION_074_COUNT_HAD_REWARD.getValue(),
                String.format("奖励已经领取{%s}-{%s}", config.getIdx(), GsonUtils.toJson(promotionInfo.getLotteryCountRecord())));

        promotionInfo.getLotteryCountRecord().add(config.getIdx());
        promotion074Service.updatePromotion(promotionInfo);
        thingService.add(playerContext.getId(), config.getReward(), GameEvent.PROMOTION_074_LOTTERY_COUNT_REWARD);
        playerContext.write(CmdCode._75804, promotion074PB.buildGetLotteryCount(config.getIdx()));
    }


}
