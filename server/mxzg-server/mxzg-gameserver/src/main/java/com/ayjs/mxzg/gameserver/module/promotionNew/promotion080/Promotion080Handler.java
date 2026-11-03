package com.ayjs.mxzg.gameserver.module.promotionNew.promotion080;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.JsonUtil;
import com.ayjs.mxzg.common.util.gson.GsonUtils;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.promotion080.Promotion080MissionBoxRewardSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion080.Promotion080MissionSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion080.CPromotion080Mission;
import com.ayjs.mxzg.config.excel.entity.promotion080.CPromotion080MissionBoxReward;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion080.converter.Promotion080PB;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion080.domain.Promotion080;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion080.service.Promotion080Service;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.gameserver.module.promotionNew.struct.MissionInfo;
import com.ayjs.mxzg.protocol.Promotion080GMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Objects;

/**
 * @Author: CWJ
 * @Date: 2020/9/22
 **/
@Component
public class Promotion080Handler extends ProtocolHandler {

    @Autowired
    private Promotion080Service promotion080Service;
    @Autowired
    private Promotion080PB promotion080PB;
    @Autowired
    private PromotionControlService promotionControlService;
    @Autowired
    private ThingService thingService;

    @Autowired
    private Promotion080MissionSysCache promotion080MissionSysCache;
    @Autowired
    private Promotion080MissionBoxRewardSysCache promotion080MissionBoxRewardSysCache;

    @CMD(id = CmdCode._75941)
    public void getData(PlayerContext playerContext, Promotion080GMsg.GReqHalloweenMissionGetDataInfo req) {
        if (!promotion080Service.isOpening()) {
            playerContext.write(CmdCode._75941, Promotion080GMsg.GResHalloweenMissionGetDataInfo.getDefaultInstance());
            return;
        }
        playerContext.write(CmdCode._75941, promotion080PB.buildData(promotion080Service.getPromotionInfo(playerContext.getId())));
    }

    @CMD(id = CmdCode._75942)
    public void getMission(PlayerContext playerContext, Promotion080GMsg.GReqHalloweenMissionGetMission req) {
        Asserts.isTrue(promotion080Service.isOpening(), ErrorCode.PROMOTION_NOT_RUNNING.getValue(), String.format("活动为开启！"));

        CPromotion080Mission config = promotion080MissionSysCache.getOrThrow(req.getIdx());

        PromotionControl promotionControl = promotionControlService.getControl(PromotionType.WAN_SHENG_MISSION);
        int startTime = promotionControl.getStartTime();
        int intervalDay = TimeDateUtil.intervalDays(startTime, TimeDateUtil.getCurrentTimeInt());

        Asserts.isTrue(config.getDay() == intervalDay,
                ErrorCode.PROMOTION_080_MISSION_ERROR.getValue(),
                String.format("任务天数不一致{%s}", req.getIdx()));

        Promotion080 promotionInfo = promotion080Service.getPromotionInfo(playerContext.getId());
        MissionInfo missionInfo = promotionInfo.getMissionInfoMap().get(config.getIdx());
        Asserts.isTrue(Objects.nonNull(missionInfo) && missionInfo.getProcess() >= config.getTarget().getTarget(),
                ErrorCode.PROMOTION_080_PROCESS_LOW.getValue(),
                String.format("任务进度不足{%s}-{%s}", req.getIdx(), JsonUtil.toJson(missionInfo)));

        Asserts.isTrue(!missionInfo.isHadReward(),
                ErrorCode.PROMOTION_080_MISSION_ERROR.getValue(),
                String.format("已经领奖{%s}", missionInfo.isHadReward()));

        missionInfo.setHadReward(true);
        promotion080Service.updatePromotion(promotionInfo);

        thingService.add(playerContext.getId(), config.getReward(), GameEvent.PROMOTION_080_MISSION_REWARD);

        playerContext.write(CmdCode._75942, promotion080PB.builderGetMission(missionInfo));
    }

    @CMD(id = CmdCode._75944)
    public void getMissionBox(PlayerContext playerContext, Promotion080GMsg.GReqHalloweenMissionGetMissionBox req) {
        Asserts.isTrue(promotion080Service.isOpening(), ErrorCode.PROMOTION_NOT_RUNNING.getValue(), String.format("活动为开启！"));

        CPromotion080MissionBoxReward config = promotion080MissionBoxRewardSysCache.getOrThrow(req.getIdx());
        Promotion080 promotionInfo = promotion080Service.getPromotionInfo(playerContext.getId());
        Asserts.isTrue(!promotionInfo.getMissionBoxRecord().contains(config.getIdx()),
                ErrorCode.PROMOTION_080_MISSION_BOX_HAD_REWARD.getValue(),
                String.format("已经领奖{%s}", config.getIdx(), GsonUtils.toJson(promotionInfo.getMissionBoxRecord())));

        int count = (int) promotionInfo.getMissionInfoMap().values().stream().filter(missionInfo -> missionInfo.isHadReward()).count();
        Asserts.isTrue(count >= config.getCount(),
                ErrorCode.PROMOTION_080_MISSION_REWARD_LOW.getValue(),
                String.format("任务领奖数不足{%s}-{%s}", count, config.getCount()));

        promotionInfo.getMissionBoxRecord().add(config.getIdx());
        promotion080Service.updatePromotion(promotionInfo);

        thingService.add(playerContext.getId(), config.getReward(), GameEvent.PROMOTION_080_MISSION_BOX_REWARD);

        playerContext.write(CmdCode._75944, promotion080PB.buildGetMissionBox(config.getIdx()));
    }


}
