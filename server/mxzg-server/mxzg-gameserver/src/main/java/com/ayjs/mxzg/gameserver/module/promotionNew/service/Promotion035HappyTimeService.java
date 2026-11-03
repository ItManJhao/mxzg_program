package com.ayjs.mxzg.gameserver.module.promotionNew.service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.lifecycle.Lifecycle;
import com.ayjs.mxzg.common.lifecycle.LifecycleInfo;
import com.ayjs.mxzg.common.persistence.repository.IRepository;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.JsonUtil;
import com.ayjs.mxzg.config.excel.cache.promotion.Promotion035HappyTimeSysCache;
import com.ayjs.mxzg.config.excel.entity.CBuyGem;
import com.ayjs.mxzg.config.excel.entity.promotion.CPromotion035HappyTime;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.dao.Promotion035HappyTimeDao;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion031Arena;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion032Tavern;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion033HeroCombine;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion035HappyTime;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.promotionNew.event.ActivityRewardEvent;
import com.ayjs.mxzg.gameserver.module.promotionNew.event.Promotion032TavernRewardEvent;
import com.ayjs.mxzg.gameserver.module.promotionNew.event.ZhuShenPassEvent;
import com.ayjs.mxzg.gameserver.module.promotionNew.struct.GetPrivilegeStruct;
import com.ayjs.mxzg.gameserver.module.promotionNew.struct.PrivilegeBuyStruct;
import com.ayjs.mxzg.gameserver.module.recharge.constant.BuyGemType;
import com.ayjs.mxzg.gameserver.module.recharge.service.IRechargeBuyingService;
import com.ayjs.mxzg.protocol.Task4GMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2019/10/21
 **/
@Service
@Slf4j
@Observer
public class Promotion035HappyTimeService extends BasePromotionService<Promotion035HappyTime> implements IRechargeBuyingService, Lifecycle {

    @Autowired
    private Promotion035HappyTimeDao promotion035HappyTimeDao;
    @Autowired
    private PromotionControlService promotionControlService;
    @Autowired
    private Promotion035HappyTimeSysCache promotion035HappyTimeSysCache;
    @Autowired
    private ThingService thingService;
    @Autowired
    private ContextManager contextManager;

    @Autowired
    private Promotion032TavernService promotion032TavernService;

    @Autowired
    private Promotion031ArenaService promotion031ArenaService;

    @Autowired
    private Promotion033HeroCombineService promotion033HeroCombineService;

    @Override
    protected PromotionType thisPromotionType() {
        return PromotionType.KUANG_HUAN_SHI_KE;
    }

    @Override
    public IRepository<Promotion035HappyTime> getRepository() {
        return promotion035HappyTimeDao;
    }

    @Override
    protected void resetOnNewTurns(Promotion035HappyTime promotion, PromotionControl control) {
        promotion.getRewardRecord().clear();
        promotion.getPrivilegeRewardRecord().clear();
        promotion.getProcessMap().clear();
        promotion.setBuyPrivilege(false);
    }

    @Override
    public Task4GMsg.PSActivityInfo sendActivityData(long rid) {
        Task4GMsg.PSActivityInfo.Builder builder = Task4GMsg.PSActivityInfo.newBuilder();
        PromotionControl control = promotionControlService.getControl(thisPromotionType());
        Promotion035HappyTime promotionInfo = getPromotionInfo(rid);

        builder.setEndTime(control.getEndTime());
        builder.setStartTime(control.getStartTime());
        builder.setTurns(control.getTurns());
        builder.setIdx(thisPromotionType().getId());
        builder.setClearTime(control.getClearTime());

        builder.setExtInfo(JsonUtil.toJson(PrivilegeBuyStruct.of(promotionInfo.isBuyPrivilege())));
        promotion035HappyTimeSysCache.getConfigsByTurn(control.getTurns()).forEach(config -> {
            Task4GMsg.PSActivityUnit.Builder unitBuilder = builderUnit(promotionInfo, config);
            builder.addList(unitBuilder);
        });
        return builder.build();
    }

    private void repairHappyTimeData(Promotion035HappyTime promotionInfo) {
        long rid = promotionInfo.getRid();
        Promotion031Arena promotionInfo031 = promotion031ArenaService.getPromotionInfo(rid);
        if (promotionInfo.getProcessMap().getOrDefault(1001, 0) != promotionInfo031.getRewardRecord().size()) {
            promotionInfo.getProcessMap().put(1001, promotionInfo031.getRewardRecord().size());
            updatePromotion(promotionInfo);
        }
        Promotion032Tavern promotionInfo032 = promotion032TavernService.getPromotionInfo(rid);
        if (promotionInfo.getProcessMap().getOrDefault(1002, 0) != promotionInfo032.getRewardMap().size()) {
            promotionInfo.getProcessMap().put(1002, promotionInfo032.getRewardMap().size());
            updatePromotion(promotionInfo);
        }
        Promotion033HeroCombine promotionInfo033 = promotion033HeroCombineService.getPromotionInfo(rid);
        int rewardCount = 0;
        if (!promotionInfo033.getRewardRecord().isEmpty()) {
            for (Integer value : promotionInfo033.getRewardRecord().values()) {
                rewardCount += value;
            }
        }

        if (promotionInfo.getProcessMap().getOrDefault(1003, 0) != rewardCount) {
            promotionInfo.getProcessMap().put(1003, rewardCount);
            updatePromotion(promotionInfo);
        }
    }

    @Override
    public boolean getActivityReward(long rid, int idx) {
        Asserts.isTrue(promotionControlService.isPromotionRunning(thisPromotionType()), ErrorCode.HERO_ARRIVE_END.getValue(), "活动已关闭！");

        CPromotion035HappyTime config = promotion035HappyTimeSysCache.getOrThrow(idx);
        Promotion035HappyTime promotionInfo = getPromotionInfo(rid);

        Asserts.isTrue(config.getTarget_num() <= promotionInfo.getProcessMap().getOrDefault(idx, 0), ErrorCode.ACHIEVEMENT_PROCESS_LOW.getValue(),
                String.format("进度值不够，领取失败！[%s]-[%s]", config.getTarget_num(), promotionInfo.getProcessMap().getOrDefault(idx, 0)));

        if (promotionInfo.isBuyPrivilege()) {
            Asserts.isTrue(!promotionInfo.getRewardRecord().contains(idx)
                    || !promotionInfo.getPrivilegeRewardRecord().contains(idx), ErrorCode.PROMOTION_ID_HAD_REWARD.getValue(), String.format("该奖励已经领取！"));
        } else {
            Asserts.isTrue(!promotionInfo.getRewardRecord().contains(idx), ErrorCode.PROMOTION_ID_HAD_REWARD.getValue(), String.format("该奖励已经领取！"));
        }

        //领取普通奖励
        List<ImmutableThing> rewards = new ArrayList<>();
        if (!promotionInfo.getRewardRecord().contains(idx)) {
            promotionInfo.getRewardRecord().add(idx);
            rewards.addAll(config.getFinish_reward());
        }
        if (promotionInfo.isBuyPrivilege() && !promotionInfo.getPrivilegeRewardRecord().contains(idx)) {
            promotionInfo.getPrivilegeRewardRecord().add(idx);
            rewards.addAll(config.getPrivilege_reward());
        }
        rewards = ImmutableThingUtil.mergeThing(rewards);
        thingService.add(rid, rewards, GameEvent.HAPPY_TIME);
        updatePromotion(promotionInfo);

        updateToClient(rid, promotionInfo, config);

        return true;
    }

    @Subscribe
    public void reward(ActivityRewardEvent event) {
        if (!promotionControlService.isPromotionRecording(thisPromotionType())) {
            return;
        }
        PromotionControl control = promotionControlService.getControl(thisPromotionType());
        List<CPromotion035HappyTime> configs = promotion035HappyTimeSysCache.getConfigsByTurn(control.getTurns()).stream()
                .filter(config -> config.getPromotion_id() == event.getType().getId()).collect(Collectors.toList());
        updateCount(configs, event.getRid());
    }

    @Subscribe
    public void zhuShenPass(ZhuShenPassEvent event) {
        if (!promotionControlService.isPromotionRecording(thisPromotionType())) {
            return;
        }
        PromotionControl control = promotionControlService.getControl(thisPromotionType());
        List<CPromotion035HappyTime> configs = promotion035HappyTimeSysCache.getConfigsByTurn(control.getTurns()).stream()
                .filter(config -> config.getPromotion_id() == PromotionType.ZHU_SHEN_ZHI_ZHAN.getId()).collect(Collectors.toList());
        updateCount(configs, event.getRid());
    }

    private void updateCount(List<CPromotion035HappyTime> configs, long rid) {
        Promotion035HappyTime promotionInfo = getPromotionInfo(rid);
        if (configs.isEmpty()) {
            return;
        }
        configs = configs.stream().filter(config -> config.getTarget_num() > promotionInfo.getProcessMap()
                .getOrDefault(config.getIdx(), 0)).collect(Collectors.toList());
        configs.forEach(config -> {
            int process = promotionInfo.getProcessMap().getOrDefault(config.getIdx(), 0);
            promotionInfo.getProcessMap().put(config.getIdx(), process + 1);
        });

        updatePromotion(promotionInfo);

        configs.forEach(config -> {
            updateToClient(rid, promotionInfo, config);
        });
    }

    /***
     * 更新条目变化给客户端
     * @param rid
     * @param promotionInfo
     * @param config
     */
    private void updateToClient(long rid, Promotion035HappyTime promotionInfo, CPromotion035HappyTime config) {
        Task4GMsg.GResActivityItemGet.Builder builder = Task4GMsg.GResActivityItemGet.newBuilder();
        Task4GMsg.PSActivityUnit.Builder unitBuilder = builderUnit(promotionInfo, config);
        builder.setUnit(unitBuilder);
        builder.setActivityIdx(thisPromotionType().getId());
        contextManager.write(rid, CmdCode._13131, builder.build());
    }

    /***
     * 构建条目信息
     * @param promotionInfo
     * @param config
     * @return
     */
    private Task4GMsg.PSActivityUnit.Builder builderUnit(Promotion035HappyTime promotionInfo, CPromotion035HappyTime config) {
        Task4GMsg.PSActivityUnit.Builder unitBuilder = Task4GMsg.PSActivityUnit.newBuilder();
        unitBuilder.setIdx(config.getIdx());
        unitBuilder.setIsGot(promotionInfo.getRewardRecord().contains(config.getIdx()) ? 1 : 0);
        unitBuilder.setExtInfo(JsonUtil.toJson(GetPrivilegeStruct.of(promotionInfo.getPrivilegeRewardRecord().contains(config.getIdx()))));
        unitBuilder.setProgress(promotionInfo.getProcessMap().getOrDefault(config.getIdx(), 0));
        return unitBuilder;
    }

    @Subscribe
    public void promotion032Reward(Promotion032TavernRewardEvent event) {
        if (!promotionControlService.isPromotionRecording(thisPromotionType())) {
            return;
        }
        PromotionControl control = promotionControlService.getControl(thisPromotionType());
        List<CPromotion035HappyTime> configs = promotion035HappyTimeSysCache.getConfigsByTurn(control.getTurns()).stream()
                .filter(config -> config.getPromotion_id() == PromotionType.JIU_GUAN_DA_BIAO.getId()).collect(Collectors.toList());
        updateCount(configs, event.getRid());
    }

    @Override
    public BuyGemType buyGemType() {
        return BuyGemType.HAPPY_TIME;
    }

    @Override
    public boolean canBuy(long rid, int productId) {
        Promotion035HappyTime promotion = getPromotionInfo(rid);
        return !promotion.isBuyPrivilege();
    }

    @Override
    public void buyGoodsSuccess(long rid, CBuyGem cBuyGem, boolean isGm) {
        Promotion035HappyTime promotion = getPromotionInfo(rid);
        promotion.setBuyPrivilege(true);
        updatePromotion(promotion);
    }


    @Override
    public LifecycleInfo getInfo() {
        return LifecycleInfo.valueOf("HAPPY_TIME");
    }

    @Override
    public void start() throws Exception {
//        repairData();
    }
}
