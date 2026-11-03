package com.ayjs.mxzg.gameserver.module.promotionNew.promotion081;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.JsonUtil;
import com.ayjs.mxzg.common.util.gson.GsonUtils;
import com.ayjs.mxzg.config.excel.cache.promotion081.Promotion081MissionBoxRewardSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion081.Promotion081MissionSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion081.CPromotion081Mission;
import com.ayjs.mxzg.config.excel.entity.promotion081.CPromotion081MissionBoxReward;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion081.converter.Promotion081PB;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion081.domain.Promotion081;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion081.service.Promotion081Service;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.gameserver.module.promotionNew.struct.MissionInfo;
import com.ayjs.mxzg.protocol.Promotion081GMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.Objects;

/**
 * @Author: CWJ
 * @Date: 2020/9/22
 **/
@Component
public class Promotion081Handler extends ProtocolHandler {

    @Autowired
    private Promotion081Service promotion081Service;
    @Autowired
    private Promotion081PB promotion081PB;
    @Autowired
    private PromotionControlService promotionControlService;
    @Autowired
    private ThingService thingService;

    @Autowired
    private Promotion081MissionSysCache promotion081MissionSysCache;
    @Autowired
    private Promotion081MissionBoxRewardSysCache promotion081MissionBoxRewardSysCache;

    @CMD(id = CmdCode._76001)
    public void getData(PlayerContext playerContext, Promotion081GMsg.GReqBlackFiveMissionGetDataInfo req) {
        if (!promotion081Service.isOpening()) {
            playerContext.write(CmdCode._76001, Promotion081GMsg.GResBlackFiveMissionGetDataInfo.getDefaultInstance());
            return;
        }
        playerContext.write(CmdCode._76001, promotion081PB.buildData(promotion081Service.getPromotionInfo(playerContext.getId())));
    }

    @CMD(id = CmdCode._76002)
    public void getMission(PlayerContext playerContext, Promotion081GMsg.GReqBlackFiveMissionGetMission req) {
        Asserts.isTrue(promotion081Service.isOpening(), ErrorCode.PROMOTION_NOT_RUNNING.getValue(), String.format("活动为开启！"));

        CPromotion081Mission config = promotion081MissionSysCache.getOrThrow(req.getIdx());

        Promotion081 promotionInfo = promotion081Service.getPromotionInfo(playerContext.getId());
        MissionInfo missionInfo = promotionInfo.getMissionInfoMap().get(config.getIdx());
        Asserts.isTrue(Objects.nonNull(missionInfo) && missionInfo.getProcess() >= config.getTarget().getTarget(),
                ErrorCode.PROMOTION_081_PROCESS_LOW.getValue(),
                String.format("任务进度不足{%s}-{%s}", req.getIdx(), JsonUtil.toJson(missionInfo)));

        Asserts.isTrue(!missionInfo.isHadReward(),
                ErrorCode.PROMOTION_081_MISSION_ERROR.getValue(),
                String.format("已经领奖{%s}", missionInfo.isHadReward()));

        missionInfo.setHadReward(true);
        promotionInfo.setMissionRewardCount(promotionInfo.getMissionRewardCount() + 1);
        promotion081Service.updatePromotion(promotionInfo);

        thingService.add(playerContext.getId(), config.getReward(), GameEvent.PROMOTION_081_MISSION_REWARD);

        playerContext.write(CmdCode._76002, promotion081PB.builderGetMission(missionInfo, promotionInfo.getMissionRewardCount()));
    }

    @CMD(id = CmdCode._76004)
    public void getMissionBox(PlayerContext playerContext, Promotion081GMsg.GReqBlackFiveMissionGetMissionBox req) {
        Asserts.isTrue(promotion081Service.isOpening(), ErrorCode.PROMOTION_NOT_RUNNING.getValue(), String.format("活动为开启！"));

        CPromotion081MissionBoxReward config = promotion081MissionBoxRewardSysCache.getOrThrow(req.getIdx());
        Promotion081 promotionInfo = promotion081Service.getPromotionInfo(playerContext.getId());
        Asserts.isTrue(!promotionInfo.getMissionBoxRecord().contains(config.getIdx()),
                ErrorCode.PROMOTION_081_MISSION_BOX_HAD_REWARD.getValue(),
                String.format("已经领奖{%s}-{%s}", config.getIdx(), GsonUtils.toJson(promotionInfo.getMissionBoxRecord())));

        int count = (int) promotionInfo.getMissionInfoMap().values().stream().filter(missionInfo -> missionInfo.isHadReward()).count();
        Asserts.isTrue(count >= config.getCount(),
                ErrorCode.PROMOTION_081_MISSION_REWARD_LOW.getValue(),
                String.format("任务领奖数不足{%s}-{%s}", count, config.getCount()));

        promotionInfo.getMissionBoxRecord().add(config.getIdx());
        promotion081Service.updatePromotion(promotionInfo);

        thingService.add(playerContext.getId(), config.getReward(), GameEvent.PROMOTION_081_MISSION_BOX_REWARD);

        playerContext.write(CmdCode._76004, promotion081PB.buildGetMissionBox(config.getIdx()));
    }


}
