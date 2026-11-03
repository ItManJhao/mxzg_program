package com.ayjs.mxzg.gameserver.module.promotionNew.handler;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.GJsonUtils;
import com.ayjs.mxzg.common.util.JsonUtil;
import com.ayjs.mxzg.common.util.gson.GsonUtils;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.promotion070.Promotion070Const;
import com.ayjs.mxzg.config.excel.cache.promotion070.Promotion070MissionBoxRewardSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion070.Promotion070MissionSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion070.Promotion070OpenCountRewardSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion070.Promotion070TypeSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion070.CPromotion070Mission;
import com.ayjs.mxzg.config.excel.entity.promotion070.CPromotion070MissionBoxReward;
import com.ayjs.mxzg.config.excel.entity.promotion070.CPromotion070OpenCountReward;
import com.ayjs.mxzg.config.excel.entity.promotion070.CPromotion070Type;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.gm.GMCommand;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.GMCmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.converter.Promotion070Converter;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion070;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion070Service;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.gameserver.module.promotionNew.struct.MissionInfo;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.gameserver.web.activity.config.Promotion070RewardConfig;
import com.ayjs.mxzg.protocol.Promotion070GMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.google.common.collect.ImmutableList;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.stream.Collectors;

/**
 * cwj
 */
@Controller
@Slf4j
public class Promotion070Handler extends ProtocolHandler {

    @Autowired
    private Promotion070TypeSysCache promotion070TypeSysCache;
    @Autowired
    private Promotion070MissionSysCache promotion070MissionSysCache;
    @Autowired
    private Promotion070OpenCountRewardSysCache promotion070OpenCountRewardSysCache;
    @Autowired
    private Promotion070Const promotion070Const;
    @Autowired
    private Promotion070MissionBoxRewardSysCache promotion070MissionBoxRewardSysCache;

    @Autowired
    private Promotion070Service promotion070Service;
    @Autowired
    private PromotionControlService promotionControlService;
    @Autowired
    private ThingService thingService;

    @CMD(id = CmdCode._75001)
    public void getData(PlayerContext playerContext, Promotion070GMsg.GReqGetDataInfo req) {
        if (!promotion070Service.isOpening()) {
            playerContext.write(CmdCode._75001, Promotion070GMsg.GResGetDataInfo.getDefaultInstance());
            return;
        }

        Promotion070 promotionInfo = promotion070Service.getPromotionInfo(playerContext.getId());
        Promotion070GMsg.GResGetDataInfo.Builder builder = Promotion070GMsg.GResGetDataInfo.newBuilder();
        builder.addAllCountReward(promotionInfo.getCountReward());

        promotion070Service.getMissionConfigsByDay().forEach(config -> {
            MissionInfo missionInfo = promotionInfo.getMissionInfoMap().get(config.getIdx());
            if (Objects.nonNull(missionInfo)) {
                builder.addMission(Promotion070Converter.builderMission(missionInfo));
            }
        });
        promotionInfo.getSelectInfo().forEach((key, value) -> {
            builder.addSelectInfo(Promotion070Converter.builderSelectInfo(key, value));
        });
        builder.setOpenCount(promotionInfo.getOpenCount());
        promotionInfo.getOpenRecord().forEach((key, value) -> {
            builder.addOpenRecord(PbUtil.builderMap(key, value));
        });
        builder.setGoodBuyCount(promotionInfo.getGoodBuyCount());
        builder.addAllMissionBoxRewardRecord(promotionInfo.getMissionBoxRecord());
        builder.setOpenDay(promotion070Service.getOpenDay());
        playerContext.write(CmdCode._75001, builder.build());
    }

    @CMD(id = CmdCode._75002)
    public void select(PlayerContext playerContext, Promotion070GMsg.GReqSelect req) {

        Asserts.isTrue(promotion070Service.isOpening(), ErrorCode.PROMOTION_NOT_RUNNING.getValue(), String.format("活动为开启！"));

        List<CPromotion070Type> needSelectConfigs = promotion070TypeSysCache.getAll().stream().filter(config ->
                config.getClient() == 1).collect(Collectors.toList());

        Promotion070 promotionInfo = promotion070Service.getPromotionInfo(playerContext.getId());
        Asserts.isTrue(promotionInfo.getSelectInfo().size() <= 0, ErrorCode.PROMOTION_070_HAD_SELECT.getValue(),
                String.format("已经选择了奖励{%s}", promotionInfo.getSelectInfo().size()));

        Asserts.isTrue(req.getSelectInfoCount() == needSelectConfigs.size(), ErrorCode.PROMOTION_070_TYPE_NUM_LOW.getValue(),
                String.format("奖励选择类型数量不够{%s}", req.getSelectInfoCount(), needSelectConfigs.size()));

        needSelectConfigs.forEach(config -> {
            Promotion070GMsg.PSSelectInfo psSelectInfo = req.getSelectInfoList().stream().
                    filter(selectInfo -> selectInfo.getIdx() == config.getIdx()).findFirst().orElse(null);
            Asserts.isTrue(Objects.nonNull(psSelectInfo), ErrorCode.PROMOTION_070_TYPE_NOT_SELECT.getValue(),
                    String.format("没有选择奖励{%s}", config.getIdx()));

            Asserts.isTrue(psSelectInfo.getRewardIdCount() == config.getNum(), ErrorCode.PROMOTION_070_TYPE_REWARD_NUM_LOW.getValue(),
                    String.format("选择数量不对{%s}-{%s}", psSelectInfo.getRewardIdCount(), config.getNum()));

            psSelectInfo.getRewardIdList().forEach(rewardId -> {
                Promotion070RewardConfig rewardConfig = promotion070Service.getRewardConfigByIdx(rewardId);
                Asserts.isTrue(rewardConfig.getType() == config.getIdx(), ErrorCode.PROMOTION_070_REWARD_ID_ERROR.getValue(),
                        String.format("奖励id错误{%s}-{%s}", rewardConfig.getType(), config.getIdx()));
            });
        });


        req.getSelectInfoList().forEach(psSelectInfo -> {
            promotionInfo.getSelectInfo().put(psSelectInfo.getIdx(), ImmutableList.copyOf(psSelectInfo.getRewardIdList()));
        });
        promotion070Service.updatePromotion(promotionInfo);

        Promotion070GMsg.GResSelect.Builder builder = Promotion070GMsg.GResSelect.newBuilder();
        promotionInfo.getSelectInfo().forEach((key, value) -> {
            builder.addSelectInfo(Promotion070Converter.builderSelectInfo(key, value));
        });
        playerContext.write(CmdCode._75002, builder.build());

    }


    @CMD(id = CmdCode._75003)
    public void getMission(PlayerContext playerContext, Promotion070GMsg.GReqGetMission req) {
        Asserts.isTrue(promotion070Service.isOpening(), ErrorCode.PROMOTION_NOT_RUNNING.getValue(), String.format("活动为开启！"));

        CPromotion070Mission config = promotion070MissionSysCache.getOrThrow(req.getIdx());

        PromotionControl promotionControl = promotionControlService.getControl(PromotionType.MENG_JING_MI_BAO);
        int startTime = promotionControl.getStartTime();
        int intervalDay = TimeDateUtil.intervalDays(startTime, TimeDateUtil.getCurrentTimeInt());

        Asserts.isTrue(config.getDay() == intervalDay, ErrorCode.PROMOTION_070_MISSION_ERROR.getValue(),
                String.format("任务天数不一致{%s}", req.getIdx()));

        Promotion070 promotionInfo = promotion070Service.getPromotionInfo(playerContext.getId());
        MissionInfo missionInfo = promotionInfo.getMissionInfoMap().get(config.getIdx());
        Asserts.isTrue(Objects.nonNull(missionInfo) && missionInfo.getProcess() >= config.getTarget().getTarget()
                , ErrorCode.PROMOTION_070_MISSION_ERROR.getValue(), String.format("任务进度不足{%s}-{%s}", req.getIdx(), JsonUtil.toJson(missionInfo)));

        Asserts.isTrue(!missionInfo.isHadReward(), ErrorCode.PROMOTION_070_MISSION_ERROR.getValue(),
                String.format("已经领奖{%s}", missionInfo.isHadReward()));

        missionInfo.setHadReward(true);
        promotion070Service.updatePromotion(promotionInfo);

        thingService.add(playerContext.getId(), config.getReward(), GameEvent.PROMOTION_070_MISSION_REWARD);

        Promotion070GMsg.GResGetMission.Builder builder = Promotion070GMsg.GResGetMission.newBuilder();
        builder.setMissionInfo(Promotion070Converter.builderMission(missionInfo));
        playerContext.write(CmdCode._75003, builder.build());
    }

    @CMD(id = CmdCode._75004)
    public void open(PlayerContext playerContext, Promotion070GMsg.GReqOpen req) {
        Asserts.isTrue(promotion070Service.isOpening(), ErrorCode.PROMOTION_NOT_RUNNING.getValue(), String.format("活动为开启！"));
        Promotion070 promotionInfo = promotion070Service.getPromotionInfo(playerContext.getId());
        Asserts.isTrue(thingService.enough(playerContext.getId(), promotion070Const.getOpenCost()), ErrorCode.ITEM_NUM_LOW.getValue(),
                String.format("道具数量不足{%s}", GJsonUtils.toJson(promotion070Const.getOpenCost())));
        Asserts.isTrue(promotionInfo.getSelectInfo().size() > 0, ErrorCode.PROMOTION_070_TYPE_NOT_SELECT.getValue(),
                String.format("未选择奖励{%s}", promotionInfo.getSelectInfo().size()));
        Asserts.isTrue(!promotionInfo.getOpenRecord().containsKey(req.getOpenIndex()), ErrorCode.PROMOTION_070_HAD_OPEN.getValue(),
                String.format("已经开启{%s}-{%s}", GJsonUtils.toJson(promotionInfo.getOpenRecord()), req.getOpenIndex()));
        Asserts.isTrue(promotionInfo.getOpenRecord().size() < promotion070TypeSysCache.getTotalNum(), ErrorCode.PROMOTION_070_OPEN_MAX.getValue(),
                String.format("格子已经开完{%s}-{%s}", promotionInfo.getOpenRecord().size(), promotion070TypeSysCache.getTotalNum()));

        thingService.cost(playerContext.getId(), promotion070Const.getOpenCost(), GameEvent.PROMOTION_070_OPEN_COST);

        Promotion070RewardConfig cPromotion070Reward = promotion070Service.randomReward(promotionInfo);

        promotionInfo.setOpenCount(promotionInfo.getOpenCount() + 1);
        promotionInfo.getOpenRecord().put(req.getOpenIndex(), cPromotion070Reward.getIdx());

        //格子全部开启后，重置奖励
        promotion070Service.updatePromotion(promotionInfo);

        thingService.add(playerContext.getId(), cPromotion070Reward.getRewardThings(), GameEvent.PROMOTION_070_OPEN_REWARD);

        Promotion070GMsg.GResOpen.Builder builder = Promotion070GMsg.GResOpen.newBuilder();
        promotionInfo.getOpenRecord().forEach((key, value) -> {
            builder.addOpenRecord(PbUtil.builderMap(key, value));
        });
        builder.setThisOpenRecord(PbUtil.builderMap(req.getOpenIndex(), cPromotion070Reward.getIdx()));
        playerContext.write(CmdCode._75004, builder.build());

    }

    @CMD(id = CmdCode._75005)
    public void getCountReward(PlayerContext playerContext, Promotion070GMsg.GReqGetCountReward req) {
        Asserts.isTrue(promotion070Service.isOpening(), ErrorCode.PROMOTION_NOT_RUNNING.getValue(), String.format("活动为开启！"));
        CPromotion070OpenCountReward config = promotion070OpenCountRewardSysCache.getOrThrow(req.getIdx());
        Promotion070 promotionInfo = promotion070Service.getPromotionInfo(playerContext.getId());
        Asserts.isTrue(config.getCount() <= promotionInfo.getOpenCount(), ErrorCode.PROMOTION_070_OPEN_COUNT_LOW.getValue(),
                String.format("开箱次数不足{%s}-{%s}", config.getCount(), promotionInfo.getOpenCount()));

        Asserts.isTrue(!promotionInfo.getCountReward().contains(config.getIdx()), ErrorCode.PROMOTION_070_COUNT_HAD_REWARD.getValue(),
                String.format("奖励已经领取{%s}-{%s}", config.getIdx(), GsonUtils.toJson(promotionInfo.getOpenCount())));

        promotionInfo.getCountReward().add(config.getIdx());
        promotion070Service.updatePromotion(promotionInfo);

        thingService.add(playerContext.getId(), config.getReward(), GameEvent.PROMOTION_070_OPEN_COUNT_REWARD);

        Promotion070GMsg.GResGetCountReward.Builder builder = Promotion070GMsg.GResGetCountReward.newBuilder();
        builder.setIdx(req.getIdx());
        playerContext.write(CmdCode._75005, builder.build());
    }

    @CMD(id = CmdCode._75006)
    public void resetSelect(PlayerContext playerContext, Promotion070GMsg.GReqResetSelect req) {
        Promotion070 promotionInfo = promotion070Service.getPromotionInfo(playerContext.getId());
        Asserts.isTrue(promotionInfo.getSelectInfo().size() > 0, ErrorCode.PROMOTION_070_TYPE_NOT_SELECT.getValue(),
                String.format("未选择奖励{%s}", promotionInfo.getSelectInfo().size()));

        promotionInfo.getSelectInfo().clear();
        promotionInfo.getOpenRecord().clear();
        promotion070Service.updatePromotion(promotionInfo);

        playerContext.write(CmdCode._75006, Promotion070GMsg.GResResetSelect.getDefaultInstance());
    }

    @CMD(id = CmdCode._75008)
    public void gtMissionBox(PlayerContext playerContext, Promotion070GMsg.GReqGetMissionBox req) {
        Asserts.isTrue(promotion070Service.isOpening(), ErrorCode.PROMOTION_NOT_RUNNING.getValue(), String.format("活动为开启！"));

        CPromotion070MissionBoxReward config = promotion070MissionBoxRewardSysCache.getOrThrow(req.getIdx());
        Promotion070 promotionInfo = promotion070Service.getPromotionInfo(playerContext.getId());
        Asserts.isTrue(!promotionInfo.getMissionBoxRecord().contains(config.getIdx()), ErrorCode.PROMOTION_070_MISSION_BOX_HAD_REWARD.getValue(),
                String.format("已经领奖{%s}", config.getIdx(), GsonUtils.toJson(promotionInfo.getMissionBoxRecord())));

        int count = (int) promotionInfo.getMissionInfoMap().values().stream().filter(missionInfo -> missionInfo.isHadReward()).count();
        Asserts.isTrue(count >= config.getCount(), ErrorCode.PROMOTION_070_MISSION_REWARD_LOW.getValue(),
                String.format("任务领奖数不足{%s}-{%s}", count, config.getCount()));

        promotionInfo.getMissionBoxRecord().add(config.getIdx());
        promotion070Service.updatePromotion(promotionInfo);

        thingService.add(playerContext.getId(), config.getReward(), GameEvent.PROMOTION_070_MISSION_REWARD);

        Promotion070GMsg.GResGetMissionBox.Builder builder = Promotion070GMsg.GResGetMissionBox.newBuilder();
        builder.setIdx(req.getIdx());
        playerContext.write(CmdCode._75008, builder.build());
    }

    @GMCommand(command = GMCmdCode.PROMOTION070_RANDOM_REWARD)
    public void randomReward(Role role, List<String> params) {
        Promotion070 promotionInfo = promotion070Service.getPromotionInfo(role.getId());
        List<List<Integer>> list = new ArrayList<>();
        for (int i = 0; i < 100; i++) {
            List<Integer> list_ = new ArrayList<>();
            promotionInfo.getOpenRecord().clear();
            for (int j = 0; j < 16; j++) {
                Promotion070RewardConfig promotion070RewardConfig = promotion070Service.randomReward(promotionInfo);
                promotionInfo.getOpenRecord().put(j, promotion070RewardConfig.getIdx());
                list_.add(promotion070RewardConfig.getIdx());
            }
            list.add(list_);
        }
        list.forEach(list_ -> log.error(GsonUtils.toJson(list_)));
    }

}
