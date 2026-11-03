package com.ayjs.mxzg.gameserver.module.promotionNew.promotion090;

import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.config.excel.cache.promotion090.Promotion090TrafficPermitRewardSysCache;
import com.ayjs.mxzg.config.excel.cache.promotion090.Promotion090TrafficPermitSysCache;
import com.ayjs.mxzg.config.excel.entity.promotion090.CPromotion090TrafficPermit;
import com.ayjs.mxzg.config.excel.entity.promotion090.CPromotion090TrafficPermitReward;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion090.domain.Promotion090TrafficPermit;
import com.ayjs.mxzg.gameserver.module.promotionNew.promotion090.service.Promotion090TrafficPermitService;
import com.ayjs.mxzg.gameserver.module.promotionNew.struct.TrafficPermitTaskProgress;
import com.ayjs.mxzg.gameserver.module.promotionNew.struct.TrafficPermitTaskType;
import com.ayjs.mxzg.protocol.Promotion090GMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.ArrayList;
import java.util.List;

/**
 * 圣诞感恩信
 */
@Controller
public class Promotion090Handler extends ProtocolHandler {

    @Autowired
    private Promotion090TrafficPermitService promotion090TrafficPermitService;
    @Autowired
    private Promotion090TrafficPermitSysCache promotion090TrafficPermitSysCache;
    @Autowired
    private Promotion090TrafficPermitRewardSysCache promotion090TrafficPermitRewardSysCache;
    @Autowired
    private ThingService thingService;

    /**
     * 活动通行证2数据
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._76190)
    public void trafficPermitInfo(PlayerContext playerContext, Promotion090GMsg.GReqTPermitList msg) {
        Promotion090TrafficPermit promotion090TrafficPermit = promotion090TrafficPermitService.getPromotionOrRefresh(playerContext.getId());
        promotion090TrafficPermitService.sendPromotionInfo(promotion090TrafficPermit);
    }


    /**
     * 购买通行证2等级
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._76191)
    public void BuyTrafficPermitLevel(PlayerContext playerContext, Promotion090GMsg.GReqTPermitBuyLevel msg) {
        Promotion090GMsg.GResTPermitBuyLevel.Builder builder = Promotion090GMsg.GResTPermitBuyLevel.newBuilder();
        Promotion090TrafficPermit promotion090TrafficPermit = promotion090TrafficPermitService.getPromotionOrRefresh(playerContext.getId());

        int level = msg.getLevel() + promotion090TrafficPermit.getLevel();

        Asserts.isTrue(level <= promotion090TrafficPermitRewardSysCache.getMaxLevel(), ErrorCode.T_PERMIT_MAX_LEVEL.getValue(),
                String.format("超过活动等级上限,当前等级{%s},购买等级{%s},上限等级{%s}", promotion090TrafficPermit.getLevel(), msg.getLevel(), promotion090TrafficPermitRewardSysCache.getMaxLevel()));

        List<ImmutableThing> immutableList = new ArrayList<>();
        for (CPromotion090TrafficPermitReward config : promotion090TrafficPermitRewardSysCache.getAll()) {
            if (config.getLevel() > promotion090TrafficPermit.getLevel() && config.getLevel() <= level) {
                immutableList.addAll(config.getLevel_cost());
            }
        }
        immutableList = ImmutableThingUtil.mergeThing(immutableList);
        thingService.cost(playerContext.getId(), immutableList, GameEvent.T_PERMIT_UP_LEVEL);

        CPromotion090TrafficPermitReward config = promotion090TrafficPermitRewardSysCache.getOrThrow(level);
        promotion090TrafficPermit.setLevel(level);
        promotion090TrafficPermit.setExp(config.getExp());
        promotion090TrafficPermitService.updatePromotion(promotion090TrafficPermit);

        builder.setExp(promotion090TrafficPermit.getExp());
        builder.setLevel(promotion090TrafficPermit.getLevel());
        playerContext.write(CmdCode._76191, builder.build());
    }

    /**
     * 领取通行证2等级奖励（单个）
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._76192)
    public void getTrafficPermitLevelReward(PlayerContext playerContext, Promotion090GMsg.GReqTPermitLevelReward msg) {
        Promotion090GMsg.GResTPermitLevelReward.Builder builder = Promotion090GMsg.GResTPermitLevelReward.newBuilder();

        Promotion090TrafficPermit promotionInfo = promotion090TrafficPermitService.getPromotionOrRefresh(playerContext.getId());

        Asserts.isTrue(promotionInfo.getLevel() >= msg.getLevel(), ErrorCode.T_PERMIT_LEVEL_LOW.getValue(),
                "通行证2等级不足以领取该奖励" + msg.getLevel());

        Asserts.isTrue(!(promotionInfo.getFinishList().contains(msg.getLevel()) &&
                        promotionInfo.getPrivilegeList().contains(msg.getLevel())), ErrorCode.T_PERMIT_LEVEL_REWARD.getValue(),
                "通行证2等级奖励已领取。" + msg.getLevel());

        CPromotion090TrafficPermitReward config = promotion090TrafficPermitRewardSysCache.getOrThrow(msg.getLevel());

        List<ImmutableThing> rewardList = new ArrayList<>();
        if (!promotionInfo.getFinishList().contains(msg.getLevel())) {
            rewardList.addAll(config.getFinish_reward());
            promotionInfo.getFinishList().add(msg.getLevel());
        }
        if (!promotionInfo.getPrivilegeList().contains(msg.getLevel()) && promotionInfo.getBuyPrivilege() == 1) {
            rewardList.addAll(config.getPrivilege_reward());
            promotionInfo.getPrivilegeList().add(msg.getLevel());
        }
        promotion090TrafficPermitService.updatePromotion(promotionInfo);

        Asserts.isTrue(rewardList.size() > 0, ErrorCode.T_PERMIT_ALL_LEVEL_REWARD.getValue(), "通行证2等级奖励已领取");
        rewardList = ImmutableThingUtil.mergeThing(rewardList);//整合道具
        thingService.add(playerContext.getId(), rewardList, GameEvent.T_PERMIT_LEVEL_REWARD);

        builder.addAllFinishReward(promotionInfo.getFinishList());
        builder.addAllPrivilegeReward(promotionInfo.getPrivilegeList());
        playerContext.write(CmdCode._76192, builder.build());
    }

    /**
     * 一键领取通行证2等级奖励
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._76193)
    public void allTrafficPermitLevelReward(PlayerContext playerContext, Promotion090GMsg.GResTPermitAllReward msg) {
        Promotion090GMsg.GResTPermitAllReward.Builder builder = Promotion090GMsg.GResTPermitAllReward.newBuilder();

        Promotion090TrafficPermit promotionInfo = promotion090TrafficPermitService.getPromotionOrRefresh(playerContext.getId());

        List<ImmutableThing> rewardList = new ArrayList<>();
        for (CPromotion090TrafficPermitReward config : promotion090TrafficPermitRewardSysCache.getAll()) {
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

        Asserts.isTrue(rewardList.size() > 0, ErrorCode.T_PERMIT_ALL_LEVEL_REWARD.getValue(), "通行证2等级奖励已全部领取");
        rewardList = ImmutableThingUtil.mergeThing(rewardList);//整合道具

        promotion090TrafficPermitService.updatePromotion(promotionInfo);

        thingService.add(playerContext.getId(), rewardList, GameEvent.T_PERMIT_LEVEL_REWARD);

        builder.addAllFinishReward(promotionInfo.getFinishList());
        builder.addAllPrivilegeReward(promotionInfo.getPrivilegeList());
        playerContext.write(CmdCode._76193, builder.build());
    }

    /**
     * 领取通行证2任务奖励
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._76194)
    public void getTrafficPermitTask(PlayerContext playerContext, Promotion090GMsg.GReqTPermitTaskReward msg) {
        Promotion090GMsg.GResTPermitTaskReward.Builder builder = Promotion090GMsg.GResTPermitTaskReward.newBuilder();

        CPromotion090TrafficPermit cPromotionTrafficPermit = promotion090TrafficPermitSysCache.getOrThrow(msg.getIdx());

        Promotion090TrafficPermit promotionInfo = promotion090TrafficPermitService.getPromotionOrRefresh(playerContext.getId());
        TrafficPermitTaskProgress trafficPermitTaskProgress = null;
        if (cPromotionTrafficPermit.getTask_type() == TrafficPermitTaskType.DAY_TASK.getValue()) {
            trafficPermitTaskProgress = promotionInfo.getDayTask().get(msg.getIdx());
        } else if (cPromotionTrafficPermit.getTask_type() == TrafficPermitTaskType.WEEK_TASK.getValue()) {
            trafficPermitTaskProgress = promotionInfo.getWeekTask().get(msg.getIdx());
        } else if (cPromotionTrafficPermit.getTask_type() == TrafficPermitTaskType.Month_TASK.getValue()) {
            trafficPermitTaskProgress = promotionInfo.getUltimateTask().get(msg.getIdx());
        }

        Asserts.notNull(trafficPermitTaskProgress, ErrorCode.T_PERMIT_TASK_NOT_EXIST.getValue(), "当前轮次无该通行证2活动任务");

        Asserts.isTrue(trafficPermitTaskProgress.getProgress() >= cPromotionTrafficPermit.getMission().getTarget(),
                ErrorCode.T_PERMIT_TASK_NOT_TARGET.getValue(), "通行证2任务未达标");

        Asserts.isTrue(trafficPermitTaskProgress.getStatus() == 0, ErrorCode.T_PERMIT_TASK_REWARD.getValue(), "通行证2任务奖励已领取");

        trafficPermitTaskProgress.setStatus(1);
        promotion090TrafficPermitService.updatePromotion(promotionInfo);

        promotion090TrafficPermitService.addExp(promotionInfo, (int) cPromotionTrafficPermit.getExp().get(0).getItem_num());
        thingService.add(playerContext.getId(), cPromotionTrafficPermit.getExp(), GameEvent.T_PERMIT_TASK_REWARD_EXP, NoticeType.NORMAL);

        builder.setLevel(promotionInfo.getLevel());
        builder.setExp(promotionInfo.getExp());
        builder.setIdx(msg.getIdx());
        playerContext.write(CmdCode._76194, builder.build());
    }

    /**
     * 修改弹窗
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._76197)
    public void editRemind(PlayerContext playerContext, Promotion090GMsg.GReqTPermitRemind msg) {
        Promotion090TrafficPermit promotionInfo = promotion090TrafficPermitService.getPromotionOrRefresh(playerContext.getId());
        promotionInfo.setRemind(1);
        promotion090TrafficPermitService.updatePromotion(promotionInfo);
    }
}
