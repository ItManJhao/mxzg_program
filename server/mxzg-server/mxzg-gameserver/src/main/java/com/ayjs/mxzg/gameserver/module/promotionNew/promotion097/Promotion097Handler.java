package com.ayjs.mxzg.gameserver.module.promotionNew.promotion097;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.config.excel.cache.promotion097.Promotion097CostCache;
import com.ayjs.mxzg.config.excel.entity.promotion097.Promotion097Cost;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion097.converter.Promotion097PB;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion097.domain.Promotion097;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion097.service.Promotion097Service;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion097LaborDayConfig;
import com.ayjs.mxzg.protocol.Promotion097GMsg.GReqLaborDayLuckDrawReset;
import com.ayjs.mxzg.protocol.Promotion097GMsg.GReqLaborDayLuckDrawGetDataInfo;
import com.ayjs.mxzg.protocol.Promotion097GMsg.GResLaborDayLuckDrawGetDataInfo;
import com.ayjs.mxzg.protocol.Promotion097GMsg.GReqLaborDayLuckDraw;
import com.ayjs.mxzg.protocol.Promotion097GMsg.GReqLaborDayLuckDrawChoice;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.google.common.collect.ImmutableList;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.HashSet;
import java.util.Map;
import java.util.Set;

@Controller
@Slf4j
public class Promotion097Handler extends ProtocolHandler {

    @Autowired
    private ThingService thingService;

    @Autowired
    private Promotion097CostCache promotion097CostCache;

    @Autowired
    private Promotion097Service promotion097Service;

    @Autowired
    private Promotion097PB promotion097PB;

    @CMD(id = CmdCode._76305)
    public void reqDataInfo(PlayerContext playerContext, GReqLaborDayLuckDrawGetDataInfo msg) {
        if (!promotion097Service.isOpening()) {
            playerContext.write(CmdCode._76305, GResLaborDayLuckDrawGetDataInfo.getDefaultInstance());
            return;
        }
        long rid = playerContext.getId();
        Promotion097 promotionInfo = promotion097Service.getPromotionInfo(rid);
        // 请求
        playerContext.write(CmdCode._76305, promotion097PB.buildDataInfo(promotionInfo));
    }

    @CMD(id = CmdCode._76306)
    public void reqLuckDraw(PlayerContext playerContext, GReqLaborDayLuckDraw msg) {
        Asserts.isTrue(promotion097Service.isOpening(), ErrorCode.PROMOTION_NOT_RUNNING.getValue(), "活动未开启！");

        long rid = playerContext.getId();
        Promotion097 promotionInfo = promotion097Service.getPromotionInfo(rid);
        int times = promotionInfo.getTimes();
        int curRound = promotionInfo.getCurRound();
        // 检查能不能当轮抽
        int rewardPos = promotion097Service.getTurnsRandomRewardPos(rid);
        Asserts.isTrue(rewardPos != -1, ErrorCode.PROMOTION_097_NOT_REWARD_YET.getValue(), "本轮奖励抽完了");

        Map<Integer, Promotion097Cost> curTurnsInfo = promotion097CostCache.getCurTurnsInfo(curRound);
        ImmutableList<ImmutableThing> cost = curTurnsInfo.get(times).getCost();
        thingService.cost(rid, cost, GameEvent.PROMOTION_097_LUCK_DRAW_COST);

        // 更新信息
        int newTimes = times + 1;
        promotionInfo.setTimes(newTimes);
        Integer rewardItemId = promotionInfo.getChoiceRewardMap().get(rewardPos);   // 玩家在该位置上选择的奖励id
        Set<Integer> curRoundRewardSet = promotionInfo.getRewardRecordMap().get(curRound);
        curRoundRewardSet.add(rewardPos);
        promotion097Service.updatePromotion(promotionInfo);
        // 道具发放
        ImmutableList<ImmutableThing> rewardThings = promotion097Service.getDataByTurnsAndPos(curRound, rewardPos).getRewardThings();
        ImmutableThing reward = null;
        for (ImmutableThing rewardThing : rewardThings) {
            if (rewardThing.getThingId() == rewardItemId) {
                reward = ImmutableThing.of(rewardThing.getThingId(), rewardThing.getItem_num());
                break;
            }
        }
        thingService.add(rid, reward, GameEvent.PROMOTION_097_LUCK_DRAW_REWARD, NoticeType.SLIENT);

        playerContext.write(CmdCode._76306, promotion097PB.buildLuckDrawInfo(promotionInfo, reward, rewardPos));
        // 检查是否需要重置
        promotion097Service.checkNeedReset(playerContext, newTimes, curRound);
    }

    @CMD(id = CmdCode._76307)
    public void reqLuckDrawChoice(PlayerContext playerContext, GReqLaborDayLuckDrawChoice msg) {
        Asserts.isTrue(promotion097Service.isOpening(), ErrorCode.PROMOTION_NOT_RUNNING.getValue(), "活动未开启！");
        long rid = playerContext.getId();
        int itemId = msg.getItemId();
        int position = msg.getPosition();

        // 检查这个位置是否可选
        Promotion097 promotionInfo = promotion097Service.getPromotionInfo(rid);
        int curRound = promotionInfo.getCurRound();
        Promotion097LaborDayConfig curRoundPosConfig = promotion097Service.getDataByTurnsAndPos(curRound, position);
        Asserts.isTrue(curRoundPosConfig.getCanChoice() == 1, ErrorCode.PROMOTION_097_POSITION_CAN_NOT_CHOICE.getValue(), "不可选位置");
        // 再验证这个位置上有没有这个奖励
        ImmutableList<ImmutableThing> rewardThings = curRoundPosConfig.getRewardThings();
        boolean flag = false;
        for (ImmutableThing rewardThing : rewardThings) {
            if (rewardThing.getThingId() == itemId) {
                flag = true;
                break;
            }
        }
        Asserts.isTrue(flag, ErrorCode.PROMOTION_097_POSITION_REWARD_NOT_EXIST.getValue(), String.format("可选奖励没有该奖励{%s}", itemId));

        // 更新所选的奖励列表
        Map<Integer, Integer> choiceRewardMap = promotionInfo.getChoiceRewardMap();
        choiceRewardMap.put(position, itemId);
        promotion097Service.updatePromotion(promotionInfo);

        playerContext.write(CmdCode._76307, promotion097PB.buildLuckDrawChoiceInfo(promotionInfo, position));
    }

    @CMD(id = CmdCode._76308)
    public void reqLaborDayReset(PlayerContext playerContext, GReqLaborDayLuckDrawReset msg) {
        Asserts.isTrue(promotion097Service.isOpening(), ErrorCode.PROMOTION_NOT_RUNNING.getValue(), "活动未开启！");
        long rid = playerContext.getId();
        Promotion097 promotionInfo = promotion097Service.getPromotionInfo(rid);
        Asserts.isTrue(promotion097Service.checkCanReset(promotionInfo), ErrorCode.PROMOTION_097_RESET_CONDITION_DISSATISFACTION.getValue(), "重置条件不满足");
        promotion097Service.reset(promotionInfo);
        playerContext.write(CmdCode._76308, promotion097PB.buildDataInfo(promotionInfo));
    }


}
