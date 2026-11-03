package com.ayjs.mxzg.gameserver.module.promotionNew.handler;


import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion061ThreeDayTaskRewardSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion061ThreeDayTaskSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion061ThreeDayTask;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion061ThreeDayTaskReward;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion061ThreeDayTask;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion061ThreeDayTaskService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.protocol.ObjectGMsg;
import com.ayjs.mxzg.protocol.Promotion061GMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;

import java.util.List;

/**
 * 三日任务
 *
 * @author hyx
 */
@Component
public class Promotion061ThreeDayTaskHandler extends ProtocolHandler {

    @Autowired
    private Promotion061ThreeDayTaskService promotion061ThreeDayTaskService;
    @Autowired
    private PromotionControlService promotionControlService;
    @Autowired
    private Promotion061ThreeDayTaskSysCache promotion061ThreeDayTaskSysCache;
    @Autowired
    private Promotion061ThreeDayTaskRewardSysCache promotion061ThreeDayTaskRewardSysCache;
    @Autowired
    private ThingService thingService;

    @CMD(id = CmdCode._13230)
    public void threeDayTaskData(PlayerContext playerContext, Promotion061GMsg.GReqThreeDayTaskData msg) {
        Promotion061GMsg.GResThreeDayTaskData.Builder builder = Promotion061GMsg.GResThreeDayTaskData.newBuilder();

        Promotion061ThreeDayTask promotion061ThreeDayTask = promotion061ThreeDayTaskService.getPromotionInfo(playerContext.getId());
        builder.setDay(promotion061ThreeDayTaskService.getPromotionDay());

        builder.addAllRewardIdx(promotion061ThreeDayTask.getTaskReward());
        builder.addAllUltimateRewardIdx(promotion061ThreeDayTask.getUltimateReward());

        promotion061ThreeDayTask.getTaskList().forEach((k, v) -> {
            ObjectGMsg.PSTaskProgress.Builder date = promotion061ThreeDayTaskService.builderTask(k,v);
            builder.addTaskList(date);
        });

        playerContext.write(CmdCode._13230, builder.build());
    }

    @CMD(id = CmdCode._13231)
    public void getThreeDayTaskReward(PlayerContext playerContext, Promotion061GMsg.GReqThreeDayTaskReward msg) {
        Asserts.isTrue(promotionControlService.isPromotionRunning(PromotionType.SAN_RI_REN_WU), ErrorCode.PROMOTION_NOT_RUNNING.getValue(), "活动已结束");

        Promotion061ThreeDayTask promotion061ThreeDayTask = promotion061ThreeDayTaskService.getPromotionInfo(playerContext.getId());
        Asserts.isTrue(!promotion061ThreeDayTask.getTaskReward().contains(msg.getIdx()), ErrorCode.PROMOTION_ID_HAD_REWARD.getValue(), "三日任务奖励已领取");

        CPromotion061ThreeDayTask config = promotion061ThreeDayTaskSysCache.getOrThrow(msg.getIdx());
        Asserts.isTrue(promotion061ThreeDayTask.getTaskList().get(config.getIdx()) >= config.getTask().getTarget(),
                ErrorCode.PROMOTION_NOT_PROGRESS.getValue(), "三日任务进度不足");

        int day = promotion061ThreeDayTaskService.getPromotionDay();
        Asserts.isTrue(config.getDay() <= day ,ErrorCode.PROMOTION_THREE_DAY_NOT_TASK_REWARD.getValue(),"不可提前领取任务奖励");

        promotion061ThreeDayTask.getTaskReward().add(msg.getIdx());
        promotion061ThreeDayTaskService.updatePromotion(promotion061ThreeDayTask);

        thingService.add(playerContext.getId(), config.getReward(), GameEvent.PROMOTION_THREE_DAY_TASK_REWARD);

        Promotion061GMsg.GResThreeDayTaskReward.Builder builder = Promotion061GMsg.GResThreeDayTaskReward.newBuilder();
        builder.addAllIdx(promotion061ThreeDayTask.getTaskReward());
        playerContext.write(CmdCode._13231, builder.build());

    }

    @CMD(id = CmdCode._13232)
    public void getThreeDayUltimateReward(PlayerContext playerContext, Promotion061GMsg.GReqThreeDayTaskUltimateReward msg) {

        Asserts.isTrue(promotionControlService.isPromotionRunning(PromotionType.SAN_RI_REN_WU), ErrorCode.PROMOTION_NOT_RUNNING.getValue(), "活动已结束");

        Promotion061ThreeDayTask promotion061ThreeDayTask = promotion061ThreeDayTaskService.getPromotionInfo(playerContext.getId());

        Asserts.isTrue(!promotion061ThreeDayTask.getUltimateReward().contains(msg.getDay()), ErrorCode.PROMOTION_THREE_DAY_ULTIMATE.getValue(), "该终极奖励已领取");

        int day = promotion061ThreeDayTaskService.getPromotionDay();
        Asserts.isTrue(msg.getDay() <= day, ErrorCode.PROMOTION_THREE_DAY_NOT_DAY_REWARD.getValue(),"不可提前领取终极奖励");

        List<CPromotion061ThreeDayTask> configList = promotion061ThreeDayTaskSysCache.getTurnsDayTask(promotion061ThreeDayTask.getTurns(), msg.getDay());
        for (CPromotion061ThreeDayTask config : configList) {
            Asserts.isTrue(promotion061ThreeDayTask.getTaskReward().contains(config.getIdx()),ErrorCode.PROMOTION_THREE_DAY_NOT_GET.getValue(), "任务未全部领取无法领取终极奖励");
        }

        CPromotion061ThreeDayTaskReward cPromotion061ThreeDayTaskReward = promotion061ThreeDayTaskRewardSysCache.getTurnsDay(promotion061ThreeDayTask.getTurns(),msg.getDay());

        promotion061ThreeDayTask.getUltimateReward().add(msg.getDay());
        promotion061ThreeDayTaskService.updatePromotion(promotion061ThreeDayTask);

        thingService.add(playerContext.getId(),cPromotion061ThreeDayTaskReward.getReward(),GameEvent.PROMOTION_THREE_DAY_ULTIMATE_REWARD);

        Promotion061GMsg.GResThreeDayTaskUltimateReward.Builder builder = Promotion061GMsg.GResThreeDayTaskUltimateReward.newBuilder();
        builder.addAllDay(promotion061ThreeDayTask.getUltimateReward());
        playerContext.write(CmdCode._13232, builder.build());
    }
}
