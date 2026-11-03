package com.ayjs.mxzg.gameserver.module.promotionNew.promotion077;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.JsonUtil;
import com.ayjs.mxzg.common.util.gson.GsonUtils;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.promotion077.Promotion077MissionBoxRewardSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion077.Promotion077MissionSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion077.CPromotion077Mission;
import com.ayjs.mxzg.config.excel.entity.promotion077.CPromotion077MissionBoxReward;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion077.converter.Promotion077PB;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion077.domain.Promotion077;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion077.service.Promotion077Service;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.gameserver.module.promotionNew.struct.MissionInfo;
import com.ayjs.mxzg.protocol.Promotion077GMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Objects;

/**
 * @Author: CWJ
 * @Date: 2020/9/22
 **/
@Component
public class Promotion077Handler extends ProtocolHandler {

    @Autowired
    private Promotion077Service promotion077Service;
    @Autowired
    private Promotion077PB promotion077PB;
    @Autowired
    private PromotionControlService promotionControlService;
    @Autowired
    private ThingService thingService;

    @Autowired
    private Promotion077MissionSysCache promotion077MissionSysCache;
    @Autowired
    private Promotion077MissionBoxRewardSysCache promotion077MissionBoxRewardSysCache;

    @CMD(id = CmdCode._75841)
    public void getData(PlayerContext playerContext, Promotion077GMsg.GReqMidMissionGetDataInfo req) {
        if (!promotion077Service.isOpening()) {
            playerContext.write(CmdCode._75841, Promotion077GMsg.GResMidMissionGetDataInfo.getDefaultInstance());
            return;
        }
        playerContext.write(CmdCode._75841, promotion077PB.buildData(promotion077Service.getPromotionInfo(playerContext.getId())));
    }

    @CMD(id = CmdCode._75842)
    public void getMission(PlayerContext playerContext, Promotion077GMsg.GReqMidMissionGetMission req) {
        Asserts.isTrue(promotion077Service.isOpening(), ErrorCode.PROMOTION_NOT_RUNNING.getValue(), String.format("活动为开启！"));

        CPromotion077Mission config = promotion077MissionSysCache.getOrThrow(req.getIdx());

        PromotionControl promotionControl = promotionControlService.getControl(PromotionType.GUANG_YUE_REN_WU);
        int startTime = promotionControl.getStartTime();
        int intervalDay = TimeDateUtil.intervalDays(startTime, TimeDateUtil.getCurrentTimeInt());

        Asserts.isTrue(config.getDay() == intervalDay,
                ErrorCode.PROMOTION_074_MISSION_ERROR.getValue(),
                String.format("任务天数不一致{%s}", req.getIdx()));

        Promotion077 promotionInfo = promotion077Service.getPromotionInfo(playerContext.getId());
        MissionInfo missionInfo = promotionInfo.getMissionInfoMap().get(config.getIdx());
        Asserts.isTrue(Objects.nonNull(missionInfo) && missionInfo.getProcess() >= config.getTarget().getTarget(),
                ErrorCode.PROMOTION_074_PROCESS_LOW.getValue(),
                String.format("任务进度不足{%s}-{%s}", req.getIdx(), JsonUtil.toJson(missionInfo)));

        Asserts.isTrue(!missionInfo.isHadReward(),
                ErrorCode.PROMOTION_074_MISSION_ERROR.getValue(),
                String.format("已经领奖{%s}", missionInfo.isHadReward()));

        missionInfo.setHadReward(true);
        promotion077Service.updatePromotion(promotionInfo);

        thingService.add(playerContext.getId(), config.getReward(), GameEvent.PROMOTION_074_MISSION_REWARD);

        playerContext.write(CmdCode._75842, promotion077PB.builderGetMission(missionInfo));
    }

    @CMD(id = CmdCode._75844)
    public void getMissionBox(PlayerContext playerContext, Promotion077GMsg.GReqMidMissionGetMissionBox req) {
        Asserts.isTrue(promotion077Service.isOpening(), ErrorCode.PROMOTION_NOT_RUNNING.getValue(), String.format("活动为开启！"));

        CPromotion077MissionBoxReward config = promotion077MissionBoxRewardSysCache.getOrThrow(req.getIdx());
        Promotion077 promotionInfo = promotion077Service.getPromotionInfo(playerContext.getId());
        Asserts.isTrue(!promotionInfo.getMissionBoxRecord().contains(config.getIdx()),
                ErrorCode.PROMOTION_074_MISSION_BOX_HAD_REWARD.getValue(),
                String.format("已经领奖{%s}", config.getIdx(), GsonUtils.toJson(promotionInfo.getMissionBoxRecord())));

        int count = (int) promotionInfo.getMissionInfoMap().values().stream().filter(missionInfo -> missionInfo.isHadReward()).count();
        Asserts.isTrue(count >= config.getCount(),
                ErrorCode.PROMOTION_074_MISSION_REWARD_LOW.getValue(),
                String.format("任务领奖数不足{%s}-{%s}", count, config.getCount()));

        promotionInfo.getMissionBoxRecord().add(config.getIdx());
        promotion077Service.updatePromotion(promotionInfo);

        thingService.add(playerContext.getId(), config.getReward(), GameEvent.PROMOTION_074_MISSION_BOX_REWARD);

        playerContext.write(CmdCode._75844, promotion077PB.buildGetMissionBox(config.getIdx()));
    }


}
