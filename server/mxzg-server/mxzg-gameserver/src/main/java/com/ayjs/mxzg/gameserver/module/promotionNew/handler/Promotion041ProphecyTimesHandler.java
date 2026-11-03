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
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion041ProphecyTimes;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion041ProphecyTimesService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion040SummonTimesConfig;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion041ProphecyTimesConfig;
import com.ayjs.mxzg.protocol.Promotion041GMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.Objects;
import java.util.Set;


/**
 * 先知馈赠活动
 */
@Controller
public class Promotion041ProphecyTimesHandler extends ProtocolHandler {

    @Autowired
    private PromotionControlService promotionControlService;
    @Autowired
    private Promotion041ProphecyTimesService promotion041ProphecyTimesService;
    @Autowired
    private ThingService thingService;
    @Autowired
    private SystemSysCache systemSysCache;

    /**
     * 请求先知馈赠列表
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._13076)
    public void prophecyList(PlayerContext playerContext, Promotion041GMsg.GReqProphecyList msg) {
        promotion041ProphecyTimesService.getPromotion041ProphecyGiftList(playerContext.getId());
    }

    /**
     * 领取先知馈赠奖励
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._13077)
    public void prophecyTimesGift(PlayerContext playerContext, Promotion041GMsg.GReqProphecyTimesGift msg) {
        Promotion041GMsg.GResProphecyTimesGift.Builder builder = Promotion041GMsg.GResProphecyTimesGift.newBuilder();

        if (!promotionControlService.isPromotionRunning(PromotionType.XIAN_ZHI_KUI_ZENG)) {
            throw new ErrorCodeException(ErrorCode.PROMOTION_TIME.getValue(), "PromotionType.XIAN_ZHI_KUI_ZENG");
        }

        //获取玩家活动进度
        Promotion041ProphecyTimes prophecyGift =
                promotion041ProphecyTimesService.getPromotionInfo(playerContext.getId());
        //已领取
        if (prophecyGift.getRewardIdx().contains(msg.getIdx())) {
            throw new ErrorCodeException(ErrorCode.PROMOTION_REWARD_ALREADY_GET.getValue(), "PromotionType.XIAN_ZHI_KUI_ZENG");
        }
        //条件不足
        Promotion041ProphecyTimesConfig config = promotion041ProphecyTimesService.selectConfigOne(msg.getIdx());
        if (Objects.isNull(config) || prophecyGift.getTimes() < config.getPlay_times()) {
            throw new ErrorCodeException(ErrorCode.PROMOTION_NOT_PROGRESS.getValue(), "PromotionType.XIAN_ZHI_KUI_ZENG");
        }

        /*Set<Integer> rewardList = prophecyGift.getRewardIdx();
        rewardList.add(msg.getIdx());
        prophecyGift.setRewardIdx(rewardList);*/
        Set<Integer> rewardList = prophecyGift.getRewardIdx();
        rewardList.add(msg.getIdx());
        prophecyGift.setRewardIdx(rewardList);
        // 判断活动轮
        if (prophecyGift.getRound() < systemSysCache.getPromotionAdvSummonTargetRewardRound()) {
            //奖励全部领取后活动轮数加1
            boolean s = true;
            int maxTimes = 0;
            for (Promotion041ProphecyTimesConfig times : promotion041ProphecyTimesService.selectConfigList()) {
                if (!prophecyGift.getRewardIdx().contains(times.getIdx())) {
                    s = false;
                    break;
                }
                if (maxTimes < times.getPlay_times()) {
                    maxTimes = times.getPlay_times();
                }
            }
            if (s) {
                prophecyGift.setRound(prophecyGift.getRound() + 1);
                prophecyGift.setTimes(prophecyGift.getTimes() - maxTimes);
                if (prophecyGift.getRound() < systemSysCache.getPromotionBlessPoolTargetRewardRound()) {
                    prophecyGift.getRewardIdx().clear();
                }
            }
        }
        promotion041ProphecyTimesService.updatePromotion(prophecyGift);

        thingService.add(playerContext.getId(), ImmutableThingUtil.fromJson(config.getReward()), GameEvent.PROPHECY_GIFT, NoticeType.NORMAL);

        playerContext.write(CmdCode._13077, builder.build());
    }

}
