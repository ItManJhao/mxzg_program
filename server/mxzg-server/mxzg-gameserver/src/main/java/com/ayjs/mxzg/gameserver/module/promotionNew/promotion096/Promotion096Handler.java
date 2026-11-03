package com.ayjs.mxzg.gameserver.module.promotionNew.promotion096;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.JsonUtil;
import com.ayjs.mxzg.common.util.gson.GsonUtils;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.promotion096.Promotion096MissionSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion096.CPromotion096Mission;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion096.converter.Promotion096PB;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion096.domain.Promotion096;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion096.service.Promotion096Service;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.gameserver.module.promotionNew.struct.MissionInfo;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion096BoxRewardConfig;
import com.ayjs.mxzg.protocol.Promotion096GMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Objects;

/**
 * @Author: CWJ
 * @Date: 2020/9/22
 **/
@Component
public class Promotion096Handler extends ProtocolHandler {

    @Autowired
    private Promotion096Service promotion096Service;
    @Autowired
    private Promotion096PB promotion096PB;
    @Autowired
    private PromotionControlService promotionControlService;
    @Autowired
    private ThingService thingService;

    @Autowired
    private Promotion096MissionSysCache promotion096MissionSysCache;

    @CMD(id = CmdCode._76301)
    public void getData(PlayerContext playerContext, Promotion096GMsg.GReqSpringOutingMissionGetDataInfo req) {
        if (!promotion096Service.isOpening()) {
            playerContext.write(CmdCode._76301, Promotion096GMsg.GResSpringOutingMissionGetDataInfo.getDefaultInstance());
            return;
        }
        playerContext.write(CmdCode._76301, promotion096PB.buildData(promotion096Service.getPromotionInfo(playerContext.getId())));
    }

    @CMD(id = CmdCode._76302)
    public void getMission(PlayerContext playerContext, Promotion096GMsg.GReqSpringOutingMissionGetMission req) {
        Asserts.isTrue(promotion096Service.isOpening(), ErrorCode.PROMOTION_NOT_RUNNING.getValue(), String.format("活动为开启！"));

        CPromotion096Mission config = promotion096MissionSysCache.getOrThrow(req.getIdx());

        PromotionControl promotionControl = promotionControlService.getControl(PromotionType.CHU_YOU_XUN_CHUN);
        int startTime = promotionControl.getStartTime();
        int intervalDay = TimeDateUtil.intervalDays(startTime, TimeDateUtil.getCurrentTimeInt());

        Asserts.isTrue(config.getDay() == intervalDay,
                ErrorCode.PROMOTION_096_MISSION_ERROR.getValue(),
                String.format("任务天数不一致{%s}", req.getIdx()));

        Promotion096 promotionInfo = promotion096Service.getPromotionInfo(playerContext.getId());
        MissionInfo missionInfo = promotionInfo.getMissionInfoMap().get(config.getIdx());
        Asserts.isTrue(Objects.nonNull(missionInfo) && missionInfo.getProcess() >= config.getTarget().getTarget(),
                ErrorCode.PROMOTION_096_PROCESS_LOW.getValue(),
                String.format("任务进度不足{%s}-{%s}", req.getIdx(), JsonUtil.toJson(missionInfo)));

        Asserts.isTrue(!missionInfo.isHadReward(),
                ErrorCode.PROMOTION_096_MISSION_ERROR.getValue(),
                String.format("已经领奖{%s}", missionInfo.isHadReward()));

        missionInfo.setHadReward(true);
        promotion096Service.updatePromotion(promotionInfo);

        thingService.add(playerContext.getId(), config.getReward(), GameEvent.PROMOTION_096_MISSION_REWARD);

        playerContext.write(CmdCode._76302, promotion096PB.builderGetMission(missionInfo));
    }

    @CMD(id = CmdCode._76304)
    public void getMissionBox(PlayerContext playerContext, Promotion096GMsg.GReqSpringOutingMissionGetMissionBox req) {
        Asserts.isTrue(promotion096Service.isOpening(), ErrorCode.PROMOTION_NOT_RUNNING.getValue(), String.format("活动为开启！"));

        PromotionControl control = promotionControlService.getControl(PromotionType.CHU_YOU_XUN_CHUN);
        Promotion096BoxRewardConfig config = control.getConfig(req.getIdx(), Promotion096BoxRewardConfig.class);
        Promotion096 promotionInfo = promotion096Service.getPromotionInfo(playerContext.getId());
        Asserts.isTrue(!promotionInfo.getMissionBoxRecord().contains(config.getIdx()),
                ErrorCode.PROMOTION_096_MISSION_BOX_HAD_REWARD.getValue(),
                String.format("已经领奖{%s}", config.getIdx(), GsonUtils.toJson(promotionInfo.getMissionBoxRecord())));

        int count = (int) promotionInfo.getMissionInfoMap().values().stream().filter(missionInfo -> missionInfo.isHadReward()).count();
        Asserts.isTrue(count >= config.getCount(),
                ErrorCode.PROMOTION_096_MISSION_REWARD_LOW.getValue(),
                String.format("任务领奖数不足{%s}-{%s}", count, config.getCount()));

        promotionInfo.getMissionBoxRecord().add(config.getIdx());
        promotion096Service.updatePromotion(promotionInfo);

        thingService.add(playerContext.getId(), config.getRewardThings(), GameEvent.PROMOTION_096_MISSION_BOX_REWARD);

        playerContext.write(CmdCode._76304, promotion096PB.buildGetMissionBox(config.getIdx()));
    }


}
