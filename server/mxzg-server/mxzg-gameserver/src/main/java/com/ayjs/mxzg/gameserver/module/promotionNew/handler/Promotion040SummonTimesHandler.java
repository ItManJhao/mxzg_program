package com.ayjs.mxzg.gameserver.module.promotionNew.handler;


import com.ayjs.mxzg.common.exception.ErrorCodeException;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.config.excel.cache.SystemSysCache;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion040SummonTimes;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion040SummonTimesService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion040SummonTimesConfig;
import com.ayjs.mxzg.protocol.Promotion040GMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.Objects;
import java.util.Set;


/**
 * 召唤达标
 */
@Controller
public class Promotion040SummonTimesHandler extends ProtocolHandler {

    @Autowired
    private Promotion040SummonTimesService promotion040SummonTimesService;
    @Autowired
    private PromotionControlService promotionControlService;
    @Autowired
    private ThingService thingService;
    @Autowired
    private SystemSysCache systemSysCache;

    /**
     * 获取召唤达标列表
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._13080)
    public void summonList(PlayerContext playerContext, Promotion040GMsg.GReqSummonList msg) {
        promotion040SummonTimesService.getPromotionProgress(playerContext.getId());
    }

    /**
     * 领取召唤达标活动奖励
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._13081)
    public void summonTimesGift(PlayerContext playerContext, Promotion040GMsg.GReqSummonTimesGift msg) {
        Promotion040GMsg.GResSummonTimesGift.Builder builder = Promotion040GMsg.GResSummonTimesGift.newBuilder();

        if (!promotionControlService.isPromotionRunning(PromotionType.ZHAO_HUAN_DA_BIAO)) {
            throw new ErrorCodeException(ErrorCode.PROMOTION_TIME.getValue(), "PromotionType.ZHAO_HUAN_DA_BIAO");
        }

        //获取玩家活动进度
        Promotion040SummonTimes promotion040SummonTimes =
                promotion040SummonTimesService.getPromotionInfo(playerContext.getId());
        //已领取
        if (promotion040SummonTimes.getRewardList().contains(msg.getIdx())) {
            throw new ErrorCodeException(ErrorCode.PROMOTION_REWARD_ALREADY_GET.getValue(), "PromotionType.ZHAO_HUAN_DA_BIAO");
        }
        //条件不足
        Promotion040SummonTimesConfig config = promotion040SummonTimesService.selectConfigOne(msg.getIdx());
        if (Objects.isNull(config) || promotion040SummonTimes.getTimes() < config.getSummon_times()) {
            throw new ErrorCodeException(ErrorCode.PROMOTION_NOT_PROGRESS.getValue(), "PromotionType.ZHAO_HUAN_DA_BIAO");
        }

        Set<Integer> rewardList = promotion040SummonTimes.getRewardList();
        rewardList.add(msg.getIdx());
        promotion040SummonTimes.setRewardList(rewardList);
        // 判断活动轮
        if (promotion040SummonTimes.getRound() < systemSysCache.getPromotionAdvSummonTargetRewardRound()) {
            //奖励全部领取后活动轮数加1
            boolean s = true;
            int maxTimes = 0;
            for (Promotion040SummonTimesConfig times : promotion040SummonTimesService.selectConfigList()) {
                if (!promotion040SummonTimes.getRewardList().contains(times.getIdx())) {
                    s = false;
                    break;
                }
                if (maxTimes < times.getSummon_times()) {
                    maxTimes = times.getSummon_times();
                }
            }
            if (s) {
                promotion040SummonTimes.setRound(promotion040SummonTimes.getRound() + 1);
                promotion040SummonTimes.setTimes(promotion040SummonTimes.getTimes() - maxTimes);
                if (promotion040SummonTimes.getRound() < systemSysCache.getPromotionBlessPoolTargetRewardRound()) {
                    promotion040SummonTimes.getRewardList().clear();
                }
            }
        }
        promotion040SummonTimesService.updatePromotion(promotion040SummonTimes);

        thingService.add(playerContext.getId(), ImmutableThingUtil.fromJson(config.getReward()), GameEvent.CYCLE_PROMOTION, NoticeType.NORMAL);

        playerContext.write(CmdCode._13081, builder.build());
    }

}
