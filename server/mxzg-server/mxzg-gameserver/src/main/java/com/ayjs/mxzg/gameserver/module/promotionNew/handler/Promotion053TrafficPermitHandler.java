package com.ayjs.mxzg.gameserver.module.promotionNew.handler;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.time.TimeConstants;
import com.ayjs.mxzg.config.excel.cache.PromotionTrafficPermitRewardSysCache;
import com.ayjs.mxzg.config.excel.cache.PromotionTrafficPermitSysCache;
import com.ayjs.mxzg.config.excel.entity.CPromotionTrafficPermit;
import com.ayjs.mxzg.config.excel.entity.CPromotionTrafficPermitReward;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion053TrafficPermit;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion053TrafficPermitService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.gameserver.module.promotionNew.struct.TrafficPermitTaskProgress;
import com.ayjs.mxzg.gameserver.module.promotionNew.struct.TrafficPermitTaskType;
import com.ayjs.mxzg.protocol.Promotion053GMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

/**
 * 活动通行证
 *
 * @author hyx
 */
@Component
public class Promotion053TrafficPermitHandler extends ProtocolHandler {

    @Autowired
    private Promotion053TrafficPermitService promotion053TrafficPermitService;
    @Autowired
    private PromotionTrafficPermitSysCache promotionTrafficPermitSysCache;
    @Autowired
    private PromotionTrafficPermitRewardSysCache promotionTrafficPermitRewardSysCache;
    @Autowired
    private ThingService thingService;
    @Autowired
    private PromotionControlService promotionControlService;

    //一个活动周的秒数
    private final static int ONE_WEEK_TIME = TimeConstants.ONE_DAY_SECOND * 7;

    /**
     * 活动通行证数据
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._13190)
    public void trafficPermitInfo(PlayerContext playerContext, Promotion053GMsg.GReqTrafficPermitList msg) {
        Promotion053TrafficPermit promotion053TrafficPermit = promotion053TrafficPermitService.getPromotionOrRefresh(playerContext.getId());
        promotion053TrafficPermitService.sendPromotionInfo(promotion053TrafficPermit);
    }


    /**
     * 购买通行证等级
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._13191)
    public void buyTrafficPermitLevel(PlayerContext playerContext, Promotion053GMsg.GReqBuyTrafficPermitLevel msg) {
        Promotion053GMsg.GResBuyTrafficPermitLevel.Builder builder = Promotion053GMsg.GResBuyTrafficPermitLevel.newBuilder();
        Promotion053TrafficPermit promotion053TrafficPermit = promotion053TrafficPermitService.getPromotionOrRefresh(playerContext.getId());

        int level = msg.getLevel() + promotion053TrafficPermit.getLevel();

        Asserts.isTrue(level <= promotionTrafficPermitRewardSysCache.getMaxLevel(), ErrorCode.TRAFFIC_PERMIT_MAX_LEVEL.getValue(),
                String.format("超过活动等级上限,当前等级{%s},购买等级{%s},上限等级{%s}", promotion053TrafficPermit.getLevel(), msg.getLevel(), promotionTrafficPermitRewardSysCache.getMaxLevel()));
        PromotionControl control = promotionControlService.getControl(PromotionType.TONG_XING_XHENG);

        List<ImmutableThing> immutableList = new ArrayList<>();
        promotionTrafficPermitRewardSysCache.getByRound(control.getTurns()).forEach(config -> {
            if (config.getLevel() > promotion053TrafficPermit.getLevel() && config.getLevel() <= level) {
                immutableList.addAll(config.getLevel_cost());
            }
        });
        thingService.cost(playerContext.getId(), immutableList, GameEvent.TRAFFIC_PERMIT_UP_LEVEL);

        CPromotionTrafficPermitReward config = promotionTrafficPermitRewardSysCache.getOrThrow(level);
        promotion053TrafficPermit.setLevel(level);
        promotion053TrafficPermit.setExp(config.getExp());
        promotion053TrafficPermitService.updatePromotion(promotion053TrafficPermit);

        builder.setExp(promotion053TrafficPermit.getExp());
        builder.setLevel(promotion053TrafficPermit.getLevel());
        playerContext.write(CmdCode._13191, builder.build());
    }

    /**
     * 领取通行证等级奖励（单个）
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._13192)
    public void getTrafficPermitLevelReward(PlayerContext playerContext, Promotion053GMsg.GReqTrafficPermitLevelReward msg) {
        Promotion053GMsg.GResTrafficPermitLevelReward.Builder builder = Promotion053GMsg.GResTrafficPermitLevelReward.newBuilder();
        PromotionControl controller = promotionControlService.getControl(PromotionType.TONG_XING_XHENG);


        Promotion053TrafficPermit promotionInfo = promotion053TrafficPermitService.getPromotionOrRefresh(playerContext.getId());
        int turns = controller.getTurns();

        Asserts.isTrue(promotionInfo.getLevel() >= msg.getLevel(), ErrorCode.TRAFFIC_PERMIT_LEVEL_LOW.getValue(),
                "通行证等级不足以领取该奖励" + msg.getLevel());

        Asserts.isTrue(!(promotionInfo.getFinishList().contains(msg.getLevel()) &&
                        promotionInfo.getPrivilegeList().contains(msg.getLevel())), ErrorCode.TRAFFIC_PERMIT_LEVEL_REWARD.getValue(),
                "通行证等级奖励已领取。" + msg.getLevel());

        CPromotionTrafficPermitReward config = promotionTrafficPermitRewardSysCache.getByRound(turns).stream().
                filter(configTemp -> configTemp.getLevel() == msg.getLevel()).findAny().orElse(null);

        Asserts.isTrue(config != null,
                ErrorCode.CONFIG_NOT_EXIST.getValue(),
                "通行证等级对应的奖励不存在：" + msg.getLevel());

        List<ImmutableThing> rewardList = new ArrayList<>();
        if (!promotionInfo.getFinishList().contains(msg.getLevel())) {
            rewardList.addAll(config.getFinish_reward());
            promotionInfo.getFinishList().add(msg.getLevel());
        }
        if (!promotionInfo.getPrivilegeList().contains(msg.getLevel()) && promotionInfo.getBuyPrivilege() == 1) {
            rewardList.addAll(config.getPrivilege_reward());
            promotionInfo.getPrivilegeList().add(msg.getLevel());
        }
        promotion053TrafficPermitService.updatePromotion(promotionInfo);

        Asserts.isTrue(rewardList.size() > 0, ErrorCode.TRAFFIC_PERMIT_ALL_LEVEL_REWARD.getValue(), "通行证等级奖励已领取");
        rewardList = ImmutableThingUtil.mergeThing(rewardList);//整合道具
        thingService.add(playerContext.getId(), rewardList, GameEvent.TRAFFIC_PERMIT_LEVEL_REWARD);

        builder.addAllFinishReward(promotionInfo.getFinishList());
        builder.addAllPrivilegeReward(promotionInfo.getPrivilegeList());
        playerContext.write(CmdCode._13192, builder.build());
    }

    /**
     * 一键领取通行证等级奖励
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._13193)
    public void allTrafficPermitLevelReward(PlayerContext playerContext, Promotion053GMsg.GResTrafficPermitAllReward msg) {
        Promotion053GMsg.GResTrafficPermitAllReward.Builder builder = Promotion053GMsg.GResTrafficPermitAllReward.newBuilder();

        Promotion053TrafficPermit promotionInfo = promotion053TrafficPermitService.getPromotionOrRefresh(playerContext.getId());

        List<ImmutableThing> rewardList = new ArrayList<>();
        for (CPromotionTrafficPermitReward config : promotionTrafficPermitRewardSysCache.getAll()) {
            if (config.getLevel() <= promotionInfo.getLevel() && !promotionInfo.getFinishList().contains(config.getLevel())) {
                rewardList.addAll(config.getFinish_reward());
                promotionInfo.getFinishList().add(config.getLevel());
            }
            if (promotionInfo.getBuyPrivilege() == 1 && config.getLevel() <= promotionInfo.getLevel()
                    && !promotionInfo.getPrivilegeList().contains(config.getLevel())) {
                rewardList.addAll(config.getPrivilege_reward());
                promotionInfo.getPrivilegeList().add(config.getLevel());
            }
        }

        Asserts.isTrue(rewardList.size() > 0, ErrorCode.TRAFFIC_PERMIT_ALL_LEVEL_REWARD.getValue(), "通行证等级奖励已全部领取");
        rewardList = ImmutableThingUtil.mergeThing(rewardList);//整合道具

        promotion053TrafficPermitService.updatePromotion(promotionInfo);

        thingService.add(playerContext.getId(), rewardList, GameEvent.TRAFFIC_PERMIT_LEVEL_REWARD);

        builder.addAllFinishReward(promotionInfo.getFinishList());
        builder.addAllPrivilegeReward(promotionInfo.getPrivilegeList());
        playerContext.write(CmdCode._13193, builder.build());
    }

    /**
     * 领取通行证任务奖励
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._13194)
    public void getTrafficPermitTask(PlayerContext playerContext, Promotion053GMsg.GReqTrafficPermitTaskReward msg) {
        Promotion053GMsg.GResTrafficPermitTaskReward.Builder builder = Promotion053GMsg.GResTrafficPermitTaskReward.newBuilder();

        CPromotionTrafficPermit cPromotionTrafficPermit = promotionTrafficPermitSysCache.getOrThrow(msg.getIdx());

        Promotion053TrafficPermit promotionInfo = promotion053TrafficPermitService.getPromotionOrRefresh(playerContext.getId());
        TrafficPermitTaskProgress trafficPermitTaskProgress = null;
        if (cPromotionTrafficPermit.getTask_type() == TrafficPermitTaskType.DAY_TASK.getValue()) {
            trafficPermitTaskProgress = promotionInfo.getDayTask().get(msg.getIdx());
        } else if (cPromotionTrafficPermit.getTask_type() == TrafficPermitTaskType.WEEK_TASK.getValue()) {
            trafficPermitTaskProgress = promotionInfo.getWeekTask().get(msg.getIdx());
        } else if (cPromotionTrafficPermit.getTask_type() == TrafficPermitTaskType.Month_TASK.getValue()) {
            trafficPermitTaskProgress = promotionInfo.getUltimateTask().get(msg.getIdx());
        }

        Asserts.notNull(trafficPermitTaskProgress, ErrorCode.TRAFFIC_PERMIT_TASK_NOT_EXIST.getValue(), "当前轮次无该通行证活动任务");

        Asserts.isTrue(trafficPermitTaskProgress.getProgress() >= cPromotionTrafficPermit.getMission().getTarget(),
                ErrorCode.TRAFFIC_PERMIT_TASK_NOT_TARGET.getValue(), "通行证任务未达标");

        Asserts.isTrue(trafficPermitTaskProgress.getStatus() == 0, ErrorCode.TRAFFIC_PERMIT_TASK_REWARD.getValue(), "通行证任务奖励已领取");

        trafficPermitTaskProgress.setStatus(1);
        promotion053TrafficPermitService.updatePromotion(promotionInfo);

        promotion053TrafficPermitService.addExp(promotionInfo, (int) cPromotionTrafficPermit.getExp().get(0).getItem_num());
        thingService.add(playerContext.getId(), cPromotionTrafficPermit.getExp(), GameEvent.TRAFFIC_PERMIT_TASK_REWARD_EXP, NoticeType.NORMAL);

        builder.setLevel(promotionInfo.getLevel());
        builder.setExp(promotionInfo.getExp());
        builder.setIdx(msg.getIdx());
        playerContext.write(CmdCode._13194, builder.build());
    }

    /**
     * 修改弹窗
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._13197)
    public void editRemind(PlayerContext playerContext, Promotion053GMsg.GReqTrafficPermitRemind msg) {
        Promotion053TrafficPermit promotionInfo = promotion053TrafficPermitService.getPromotionOrRefresh(playerContext.getId());
        promotionInfo.setRemind(1);
        promotion053TrafficPermitService.updatePromotion(promotionInfo);
    }

}
