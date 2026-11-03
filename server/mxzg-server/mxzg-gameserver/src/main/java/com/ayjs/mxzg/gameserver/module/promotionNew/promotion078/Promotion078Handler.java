package com.ayjs.mxzg.gameserver.module.promotionNew.promotion078;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.GJsonUtils;
import com.ayjs.mxzg.common.util.gson.GsonUtils;
import com.ayjs.mxzg.config.excel.cache.promotion078.Promotion078Const;
import com.ayjs.mxzg.config.excel.cache.promotion078.Promotion078LotteryCountRewardSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion078.CPromotion078LotteryCountReward;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion078.converter.Promotion078PB;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion078.domain.Promotion078;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion078.service.Promotion078Service;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion078LotteryRewardConfig;
import com.ayjs.mxzg.protocol.Promotion078GMsg;
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
public class Promotion078Handler extends ProtocolHandler {

    @Autowired
    private Promotion078Service promotion078Service;
    @Autowired
    private Promotion078PB promotion078PB;
    @Autowired
    private ThingService thingService;

    @Autowired
    private Promotion078Const promotion078Const;
    @Autowired
    private Promotion078LotteryCountRewardSysCache promotion078LotteryCountRewardSysCache;

    @CMD(id = CmdCode._75901)
    public void getData(PlayerContext playerContext, Promotion078GMsg.GReqHalloweenLotteryGetDataInfo req) {
        if (!promotion078Service.isOpening()) {
            playerContext.write(CmdCode._75901, Promotion078GMsg.GReqHalloweenLotteryGetDataInfo.getDefaultInstance());
            return;
        }
        playerContext.write(CmdCode._75901, promotion078PB.buildData(promotion078Service.getPromotionInfo(playerContext.getId())));
    }

    @CMD(id = CmdCode._75902)
    public void select(PlayerContext playerContext, Promotion078GMsg.GReqHalloweenLotterySelect req) {

        Asserts.isTrue(promotion078Service.isOpening(), ErrorCode.PROMOTION_NOT_RUNNING.getValue(), String.format("活动为开启！"));

        Promotion078 promotionInfo = promotion078Service.getPromotionInfo(playerContext.getId());

        int rewardIdx = req.getSelectInfo().getKey();
        int rewardIndex = req.getSelectInfo().getValue();

        Promotion078LotteryRewardConfig config = promotion078Service.getConfig(rewardIdx);

        Asserts.isTrue(config.getNeed_select() == 1,
                ErrorCode.PROMOTION_078_CANT_SELECT.getValue(),
                String.format("不需要选择奖励{%s}", rewardIdx));

        Asserts.isTrue(rewardIndex >= 1 & rewardIndex <= config.getRewardThings().size(),
                ErrorCode.SYSTEM_ERROR.getValue(),
                String.format("奖励索引错误{%s}", rewardIndex));

        if (promotionInfo.getSelectInfo().containsKey(rewardIdx)) {
            Asserts.isTrue(thingService.enough(playerContext.getId(), promotion078Const.getLotteryChangeCost()),
                    ErrorCode.ITEM_NUM_LOW.getValue(),
                    String.format("道具不足{%s}", GJsonUtils.toJson(promotion078Const.getLotteryChangeCost())));
            thingService.cost(playerContext.getId(), promotion078Const.getLotteryChangeCost(), GameEvent.PROMOTION_078_CHANGE_COST);
        }

        promotionInfo.getSelectInfo().put(rewardIdx, rewardIndex);
        promotion078Service.updatePromotion(promotionInfo);

        playerContext.write(CmdCode._75902, promotion078PB.buildSelect(rewardIdx, rewardIndex));

    }

    @CMD(id = CmdCode._75903)
    public void lottery(PlayerContext playerContext, Promotion078GMsg.GReqHalloweenLotteryLottery req) {
        Asserts.isTrue(promotion078Service.isOpening(),
                ErrorCode.PROMOTION_NOT_RUNNING.getValue(),
                String.format("活动为开启！"));
        Promotion078 promotionInfo = promotion078Service.getPromotionInfo(playerContext.getId());
        Asserts.isTrue(promotionInfo.getSelectInfo().size() > 0,
                ErrorCode.PROMOTION_078_TYPE_NOT_SELECT.getValue(),
                String.format("未选择奖励{%s}", promotionInfo.getSelectInfo().size()));

        Asserts.isTrue(req.getNum() == 1 || req.getNum() == 10,
                ErrorCode.PROMOTION_078_LOTTERY_NUM_ERROR.getValue(),
                String.format("抽奖次数错误{%s}", req.getNum()));
        List<ImmutableThing> cost = ImmutableThingUtil.multiplyThing(promotion078Const.getLotteryCost(), req.getNum());
        Asserts.isTrue(thingService.enough(playerContext.getId(), cost),
                ErrorCode.ITEM_NUM_LOW.getValue(),
                String.format("道具数量不足{%s}", GJsonUtils.toJson(cost)));

        thingService.cost(playerContext.getId(), cost, GameEvent.PROMOTION_078_LOTTERY_COST);

        //抽中大奖之后，重置次数
        List<ImmutableThing> list = Lists.newArrayList();
        Promotion078LotteryRewardConfig firstConfig = null;
        for (int i = 0; i < req.getNum(); i++) {
            Promotion078LotteryRewardConfig cPromotion078Reward = promotion078Service.randomReward(promotionInfo);
            if (i == 0) {
                firstConfig = cPromotion078Reward;
                promotionInfo.setLastLotteryIdx(firstConfig.getIdx());
            }
            promotionInfo.setLotteryCount(promotionInfo.getLotteryCount() + 1);

            promotionInfo.setLotteryTurnCount(promotionInfo.getLotteryTurnCount() + 1);
            promotionInfo.getLotteryTurnRecord().add(cPromotion078Reward.getId());
            if (cPromotion078Reward.getNeed_select() == 1) {
                promotionInfo.setLotteryTurnCount(0);
                promotionInfo.getLotteryTurnRecord().clear();
                list.add(cPromotion078Reward.getRewardThings().get(promotionInfo.getSelectInfo().get(cPromotion078Reward.getId()) - 1));
            } else {
                list.addAll(cPromotion078Reward.getRewardThings());
            }
        }
        promotion078Service.updatePromotion(promotionInfo);
        thingService.add(playerContext.getId(), list, GameEvent.PROMOTION_078_LOTTERY_REWARD, NoticeType.SLIENT);
        playerContext.write(CmdCode._75903, promotion078PB.buildLottery(promotionInfo, list, firstConfig.getIdx()));

    }

    @CMD(id = CmdCode._75904)
    public void getCountReward(PlayerContext playerContext, Promotion078GMsg.GReqHalloweenLotteryGetLotteryCountReward req) {
        Asserts.isTrue(promotion078Service.isOpening(), ErrorCode.PROMOTION_NOT_RUNNING.getValue(), String.format("活动为开启！"));
        CPromotion078LotteryCountReward config = promotion078LotteryCountRewardSysCache.getOrThrow(req.getIdx());
        Promotion078 promotionInfo = promotion078Service.getPromotionInfo(playerContext.getId());
        Asserts.isTrue(config.getCount() <= promotionInfo.getLotteryCount(),
                ErrorCode.PROMOTION_078_OPEN_COUNT_LOW.getValue(),
                String.format("开箱次数不足{%s}-{%s}", config.getCount(), promotionInfo.getLotteryCount()));

        Asserts.isTrue(!promotionInfo.getLotteryCountRecord().contains(config.getIdx()),
                ErrorCode.PROMOTION_078_COUNT_HAD_REWARD.getValue(),
                String.format("奖励已经领取{%s}-{%s}", config.getIdx(), GsonUtils.toJson(promotionInfo.getLotteryCountRecord())));

        promotionInfo.getLotteryCountRecord().add(config.getIdx());
        promotion078Service.updatePromotion(promotionInfo);
        thingService.add(playerContext.getId(), config.getReward(), GameEvent.PROMOTION_078_LOTTERY_COUNT_REWARD);
        playerContext.write(CmdCode._75904, promotion078PB.buildGetLotteryCount(config.getIdx()));
    }


}
