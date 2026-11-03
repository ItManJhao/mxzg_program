package com.ayjs.mxzg.gameserver.module.promotionNew.handler;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion018SevenDayTargetPointSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion018SevenDayTargetSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion018SevenDayTarget;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion018SevenDayTargetPoint;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.TargetCompleteKind;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion018SevenDayTarget;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion018SevenDayTargetService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.protocol.SevenDayTargetGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

/**
 * 七日目标
 *
 * @author hyx
 */
@Controller
public class Promotion018SevenDayTargetHandler extends ProtocolHandler {

    @Autowired
    private Promotion018SevenDayTargetService promotion018SevenDayTargetService;
    @Autowired
    private PromotionControlService promotionControlService;
    @Autowired
    private Promotion018SevenDayTargetSysCache promotion018SevenDayTargetSysCache;
    @Autowired
    private Promotion018SevenDayTargetPointSysCache promotion018SevenDayTargetPointSysCache;
    @Autowired
    private ThingService thingService;

    /**
     * 七日目标数据
     *
     * @param playerContext
     * @param req
     */
    @CMD(id = CmdCode._21010)
    public void getSevenDayTargetList(PlayerContext playerContext, SevenDayTargetGMsg.GReqSevenDayTargetList req) {

        Promotion018SevenDayTarget promotion018SevenDayTarget = promotion018SevenDayTargetService.getOrRefresh(playerContext.getId());

        SevenDayTargetGMsg.GResSevenDayTargetList.Builder builder = SevenDayTargetGMsg.GResSevenDayTargetList.newBuilder();
        builder.addAllRewardBoxIdx(promotion018SevenDayTarget.getBoxRewards());
        builder.setSevenDayValue(promotion018SevenDayTarget.getTaskReward().size());

        PromotionControl promotionControl = promotionControlService.getControl(PromotionType.QI_RI_MU_BIAO);
        int day = TimeDateUtil.intervalDays(promotionControl.getStartTime(), TimeDateUtil.getCurrentTimeInt());
        builder.setCurrDay(day);

        builder.addAllTask(promotion018SevenDayTargetService.builderTask(promotion018SevenDayTarget));

        playerContext.write(CmdCode._21010, builder.build());
    }


    /**
     * 领取七天奖励
     *
     * @param playerContext
     * @param req
     */
    @CMD(id = CmdCode._21011)
    public void reward(PlayerContext playerContext, SevenDayTargetGMsg.GReqSevenDayTargetGetReward req) {

        Asserts.isTrue(promotionControlService.isPromotionRunning(PromotionType.QI_RI_MU_BIAO), ErrorCode.PROMOTION_NOT_RUNNING.getValue(), "活动已结束");

        CPromotion018SevenDayTarget config = promotion018SevenDayTargetSysCache.getOrThrow(req.getTaskId());

        Promotion018SevenDayTarget promotion018SevenDayTarget = promotion018SevenDayTargetService.getOrRefresh(playerContext.getId());

        Asserts.isTrue(promotion018SevenDayTarget.getTask_list().containsKey(req.getTaskId()), ErrorCode.ERROR_PARAM.getValue(),
                String.format("任务不存在,任务id:{%s}", req.getTaskId()));

        Asserts.isTrue(!promotion018SevenDayTarget.getTaskReward().contains(req.getTaskId()), ErrorCode.PROMOTION_ID_HAD_REWARD.getValue(),
                String.format("任务{%s}已领取过奖励", req.getTaskId()));

        Asserts.isTrue(promotion018SevenDayTarget.getTask_list().get(req.getTaskId()) >= config.getTask().getTarget(), ErrorCode.OPERATOR_COUNT_LOW.getValue(),
                String.format("进度不足，当前进度{%s},需求进度{%s}", promotion018SevenDayTarget.getTask_list().get(req.getTaskId()), config.getTask().getTarget()));

        if (config.getKind() == TargetCompleteKind.BUY.getKind()) {
            long allItemNums = ImmutableThingUtil.getAllItemNums(config.getCost());
            if (allItemNums > 0) {
                thingService.cost(playerContext.getId(), config.getCost(), GameEvent.SEVEN_TASK_COST);
            }
        }

        thingService.add(playerContext.getId(), config.getReward(), GameEvent.SEVEN_TASK_REWARD);

        promotion018SevenDayTarget.getTaskReward().add(req.getTaskId());
        promotion018SevenDayTargetService.updatePromotion(promotion018SevenDayTarget);

        SevenDayTargetGMsg.GResSevenDayTargetGetReward.Builder builder = SevenDayTargetGMsg.GResSevenDayTargetGetReward.newBuilder();
        builder.setSevenDayValue(promotion018SevenDayTarget.getTaskReward().size());
        builder.addTask(promotion018SevenDayTargetService.builderTask(req.getTaskId(), promotion018SevenDayTarget));
        playerContext.write(CmdCode._21011, builder.build());

    }

    /**
     * 领取七天宝箱奖励
     *
     * @param playerContext
     * @param req
     */
    @CMD(id = CmdCode._21012)
    public void rewardBox(PlayerContext playerContext, SevenDayTargetGMsg.GReqSevenDayTargetBoxGetReward req) {

        Asserts.isTrue(promotionControlService.isPromotionRunning(PromotionType.QI_RI_MU_BIAO), ErrorCode.PROMOTION_NOT_RUNNING.getValue(), "活动已结束");

        PromotionControl promotionControl = promotionControlService.getControl(PromotionType.QI_RI_MU_BIAO);

        CPromotion018SevenDayTargetPoint cPromotion7DayTargetPoint = promotion018SevenDayTargetPointSysCache.getConfig(promotionControl.getTurns(), req.getBoxId());

        Promotion018SevenDayTarget promotion018SevenDayTarget = promotion018SevenDayTargetService.getOrRefresh(playerContext.getId());

        Asserts.isTrue(!promotion018SevenDayTarget.getBoxRewards().contains(req.getBoxId()), ErrorCode.SEVEN_DAY_TARGET_BOX_HAD_REWARD.getValue(), "该宝箱奖励已领取");

        Asserts.isTrue(cPromotion7DayTargetPoint.getTask_num() <= promotion018SevenDayTarget.getTaskReward().size(),
                ErrorCode.OPERATOR_COUNT_LOW.getValue(), String.format("进度不足，当前进度{%s},需求进度{%s}", promotion018SevenDayTarget.getTaskReward().size(), cPromotion7DayTargetPoint.getTask_num()));


        promotion018SevenDayTarget.getBoxRewards().add(req.getBoxId());
        promotion018SevenDayTargetService.updatePromotion(promotion018SevenDayTarget);
        // 奖励
        thingService.add(playerContext.getId(), cPromotion7DayTargetPoint.getReward(), GameEvent.SEVEN_TASK_BOX_REWARD);

        SevenDayTargetGMsg.GReqSevenDayTargetBoxGetReward.Builder builder = SevenDayTargetGMsg.GReqSevenDayTargetBoxGetReward.newBuilder();
        builder.setBoxId(req.getBoxId());
        playerContext.write(CmdCode._21012, builder.build());
    }

}
