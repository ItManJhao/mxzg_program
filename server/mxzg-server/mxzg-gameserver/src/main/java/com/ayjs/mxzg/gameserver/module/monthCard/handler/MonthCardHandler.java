package com.ayjs.mxzg.gameserver.module.monthCard.handler;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.config.excel.cache.GrowthGiftSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion008CardSysCache;
import com.ayjs.mxzg.config.excel.entity.CGrowthGift;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.monthCard.constant.MonthCardType;
import com.ayjs.mxzg.gameserver.module.monthCard.domain.MonthCard;
import com.ayjs.mxzg.gameserver.module.monthCard.serice.MonthCardService;
import com.ayjs.mxzg.gameserver.module.recharge.domain.RoleRecharge;
import com.ayjs.mxzg.gameserver.module.recharge.service.RoleRechargeService;
import com.ayjs.mxzg.protocol.Task1GMsg;
import com.ayjs.mxzg.protocol.Task1GMsg.GReqMonthCardList;
import com.ayjs.mxzg.protocol.Task1GMsg.GResMonthCardList;
import com.ayjs.mxzg.protocol.TaskObjGMsg;
import com.ayjs.mxzg.protocol.TaskObjGMsg.MonthCardData;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.apache.commons.collections4.CollectionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * @Author: CWJ
 * @Date: 2019/10/16
 **/
@Component
public class MonthCardHandler extends ProtocolHandler {
    @Autowired
    MonthCardService monthCardService;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private Promotion008CardSysCache promotion008CardSysCache;
    @Autowired
    private RoleRechargeService roleRechargeService;
    @Autowired
    private GrowthGiftSysCache growthGiftSysCache;
    @Autowired
    private ThingService thingService;
    @Autowired
    private ContextManager contextManager;

    @CMD(id = CmdCode._13017)
    public void monthCardList(PlayerContext playerContext, GReqMonthCardList req) {
        this.getMonthCardList(playerContext.getId());
    }

    private void getMonthCardList(long rid) {
        List<MonthCard> monthCards = monthCardService.getAll(rid);
        GResMonthCardList.Builder builder = GResMonthCardList.newBuilder();

        if (CollectionUtils.isNotEmpty(monthCards)) {
            monthCards.forEach(monthCard -> {
                MonthCardData.Builder builder1 = TaskObjGMsg.MonthCardData.newBuilder();
                builder1.setCardType(monthCard.getIdx());
                builder1.setCompleted(monthCard.getRechargeCount());
                builder1.setEndTime(monthCard.getEndTime());
                builder1.setIsGain(DateTimeUtil.isSameDate(monthCard.getRewardTime(), DateTimeUtil.currentSecond()) ? 1 : 0);
                if (monthCard.getType() == MonthCardType.BEST.getType()) {
                    builder1.setIsGainVip(DateTimeUtil.isSameDate(monthCard.getBaseCardRewardTime(), DateTimeUtil.currentSecond()) ? 1 : 0);
                }
                builder1.setGainDays(monthCard.getRewardCount());
                builder.addAward(builder1.build());
            });
        }
        contextManager.write(rid, CmdCode._13017, builder.build());
    }


    @CMD(id = CmdCode._13025)
    public void monthCardReward(PlayerContext playerContext, Task1GMsg.GReqMonthCardReward req) {
        ErrorCode code = monthCardService.reward(playerContext.getId(), req.getIdx());
        if (code != ErrorCode.NO_ERROR)
            playerContext.writeError(code);
    }

    /**
     * 至尊月卡额外奖励领奖
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._13018)
    public void monthVipReward(PlayerContext playerContext, Task1GMsg.GReqMonthVipReward msg) {
        Task1GMsg.GResMonthVipReward.Builder builder = Task1GMsg.GResMonthVipReward.newBuilder();

        MonthCard monthCard = monthCardService.getByType(playerContext.getId(), MonthCardType.BEST);
        if (monthCard == null) {
            playerContext.writeError(ErrorCode.MONTH_BEST_CARD);
            return;
        }
        if (monthCard.getEndTime() < DateTimeUtil.currentSecond()) {
            playerContext.writeError(ErrorCode.MONTH_CARD_PAST_DUE);
            return;
        }

        if (monthCard.getBaseCardRewardTime() > DateTimeUtil.dayBreak()) {
            playerContext.writeError(ErrorCode.MONTH_CARD_DAILY_REWARD_CD);
            return;
        }

        monthCard.setBaseCardRewardTime(DateTimeUtil.currentSecond());
        monthCardService.update(monthCard);

        RoleRecharge recharge = roleRechargeService.getRoleRecharge(playerContext.getId());
        CGrowthGift cGrowthGift = growthGiftSysCache.getGrowthGift(recharge.getTotalRecharge());
        thingService.add(playerContext.getId(), cGrowthGift.getGift_every_day(), GameEvent.GROWTH_GIFT_BEST_CARD);

        playerContext.write(CmdCode._13018, builder.build());

        this.getMonthCardList(playerContext.getId());
    }


}
