package com.ayjs.mxzg.gameserver.module.promotionNew.promotion085;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.JsonUtil;
import com.ayjs.mxzg.common.util.gson.GsonUtils;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.promotion085.Promotion085MissionSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion085.CPromotion085Mission;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion085.converter.Promotion085PB;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion085.domain.Promotion085;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion085.service.Promotion085Service;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.gameserver.module.promotionNew.struct.MissionInfo;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion085BoxRewardConfig;
import com.ayjs.mxzg.protocol.Promotion085GMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Objects;

/**
 * @Author: CWJ
 * @Date: 2020/9/22
 **/
@Component
public class Promotion085Handler extends ProtocolHandler {

    @Autowired
    private Promotion085Service promotion085Service;
    @Autowired
    private Promotion085PB promotion085PB;
    @Autowired
    private PromotionControlService promotionControlService;
    @Autowired
    private ThingService thingService;

    @Autowired
    private Promotion085MissionSysCache promotion085MissionSysCache;

    @CMD(id = CmdCode._76081)
    public void getData(PlayerContext playerContext, Promotion085GMsg.GReqChristmasMissionGetDataInfo req) {
        if (!promotion085Service.isOpening()) {
            playerContext.write(CmdCode._76081, Promotion085GMsg.GResChristmasMissionGetDataInfo.getDefaultInstance());
            return;
        }
        playerContext.write(CmdCode._76081, promotion085PB.buildData(promotion085Service.getPromotionInfo(playerContext.getId())));
    }

    @CMD(id = CmdCode._76082)
    public void getMission(PlayerContext playerContext, Promotion085GMsg.GReqChristmasMissionGetMission req) {
        Asserts.isTrue(promotion085Service.isOpening(), ErrorCode.PROMOTION_NOT_RUNNING.getValue(), String.format("活动为开启！"));

        CPromotion085Mission config = promotion085MissionSysCache.getOrThrow(req.getIdx());

        PromotionControl promotionControl = promotionControlService.getControl(PromotionType.CHRISTMAS_MISSION);
        int startTime = promotionControl.getStartTime();
        int intervalDay = TimeDateUtil.intervalDays(startTime, TimeDateUtil.getCurrentTimeInt());

        Asserts.isTrue(config.getDay() == intervalDay,
                ErrorCode.PROMOTION_085_MISSION_ERROR.getValue(),
                String.format("任务天数不一致{%s}", req.getIdx()));

        Promotion085 promotionInfo = promotion085Service.getPromotionInfo(playerContext.getId());
        MissionInfo missionInfo = promotionInfo.getMissionInfoMap().get(config.getIdx());
        Asserts.isTrue(Objects.nonNull(missionInfo) && missionInfo.getProcess() >= config.getTarget().getTarget(),
                ErrorCode.PROMOTION_085_PROCESS_LOW.getValue(),
                String.format("任务进度不足{%s}-{%s}", req.getIdx(), JsonUtil.toJson(missionInfo)));

        Asserts.isTrue(!missionInfo.isHadReward(),
                ErrorCode.PROMOTION_085_MISSION_ERROR.getValue(),
                String.format("已经领奖{%s}", missionInfo.isHadReward()));

        missionInfo.setHadReward(true);
        promotion085Service.updatePromotion(promotionInfo);

        thingService.add(playerContext.getId(), config.getReward(), GameEvent.PROMOTION_085_MISSION_REWARD);

        playerContext.write(CmdCode._76082, promotion085PB.builderGetMission(missionInfo));
    }

    @CMD(id = CmdCode._76084)
    public void getMissionBox(PlayerContext playerContext, Promotion085GMsg.GReqChristmasMissionGetMissionBox req) {
        Asserts.isTrue(promotion085Service.isOpening(), ErrorCode.PROMOTION_NOT_RUNNING.getValue(), String.format("活动为开启！"));

        PromotionControl control = promotionControlService.getControl(PromotionType.CHRISTMAS_MISSION);
        Promotion085BoxRewardConfig config = control.getConfig(req.getIdx(), Promotion085BoxRewardConfig.class);
        Promotion085 promotionInfo = promotion085Service.getPromotionInfo(playerContext.getId());
        Asserts.isTrue(!promotionInfo.getMissionBoxRecord().contains(config.getIdx()),
                ErrorCode.PROMOTION_085_MISSION_BOX_HAD_REWARD.getValue(),
                String.format("已经领奖{%s}", config.getIdx(), GsonUtils.toJson(promotionInfo.getMissionBoxRecord())));

        int count = (int) promotionInfo.getMissionInfoMap().values().stream().filter(missionInfo -> missionInfo.isHadReward()).count();
        Asserts.isTrue(count >= config.getCount(),
                ErrorCode.PROMOTION_085_MISSION_REWARD_LOW.getValue(),
                String.format("任务领奖数不足{%s}-{%s}", count, config.getCount()));

        promotionInfo.getMissionBoxRecord().add(config.getIdx());
        promotion085Service.updatePromotion(promotionInfo);

        thingService.add(playerContext.getId(), config.getRewardThings(), GameEvent.PROMOTION_085_MISSION_BOX_REWARD);

        playerContext.write(CmdCode._76084, promotion085PB.buildGetMissionBox(config.getIdx()));
    }


}
