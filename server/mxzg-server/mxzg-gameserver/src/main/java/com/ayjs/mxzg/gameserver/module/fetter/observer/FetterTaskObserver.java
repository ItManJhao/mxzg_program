package com.ayjs.mxzg.gameserver.module.fetter.observer;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.config.excel.cache.GoddessMissionSysCache;
import com.ayjs.mxzg.config.excel.cache.GoddessVipSysCache;
import com.ayjs.mxzg.config.excel.entity.CGoddessMission;
import com.ayjs.mxzg.config.excel.entity.CGoddessVip;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.TargetStruct;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.battle.service.RoleMissionService;
import com.ayjs.mxzg.gameserver.module.fetter.domain.FetterTaskReward;
import com.ayjs.mxzg.gameserver.module.fetter.event.GoddessBreakEvent;
import com.ayjs.mxzg.gameserver.module.fetter.event.GoddessLevelUpOperatorEvent;
import com.ayjs.mxzg.gameserver.module.fetter.event.GoddessRefineEvent;
import com.ayjs.mxzg.gameserver.module.fetter.event.GoddessSoulEvent;
import com.ayjs.mxzg.gameserver.module.fetter.event.GoddessVipLevelUpEvent;
import com.ayjs.mxzg.gameserver.module.fetter.event.GoddessWashLevelEvent;
import com.ayjs.mxzg.gameserver.module.fetter.service.FetterService;
import com.ayjs.mxzg.gameserver.module.fetter.service.GoddessFashionService;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.role.event.LoginEvent;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.shop.constant.ShopType;
import com.ayjs.mxzg.gameserver.module.shop.service.ShopService;
import com.ayjs.mxzg.gameserver.module.targetCounter.event.TaskCountChangeEvent;
import com.ayjs.mxzg.gameserver.module.targetCounter.service.TargetCounterService;
import com.ayjs.mxzg.protocol.FetterGMsg;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;

@Observer
public class FetterTaskObserver {
    @Autowired
    private RoleService roleService;
    @Autowired
    private FetterService fetterService;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private GoddessMissionSysCache goddessMissionSysCache;
    @Autowired
    private GoddessVipSysCache goddessVipSysCache;
    @Autowired
    private ShopService shopService;
    @Autowired
    private RoleMissionService roleMissionService;
    @Autowired
    private TargetCounterService targetCounterService;
    @Autowired
    private HeroService heroService;
    @Autowired
    private GoddessFashionService goddessFashionService;

    /**
     * 同步前端任务进度
     *
     * @param event
     */
    @Subscribe
    public void updateProgress(TaskCountChangeEvent event) {
        List<CGoddessMission> list = goddessMissionSysCache.getGoddessMissionList(event.getTargetType());
        if (list != null && list.size() > 0) {
            fetterService.updateFetterTask(event.getRid(), list);
        }
        goddessFashionService.updateTaskToClient(event.getRid(), TargetStruct.of(event.getTargetType(), event.getCondition(),
                event.getSubCondition()));
    }

    /**
     * 羁绊任务事件
     *
     * @param event
     */
    @Subscribe
    public void goddessTaskData(LoginEvent event) {
        FetterGMsg.GResFetterInitTask.Builder builder = FetterGMsg.GResFetterInitTask.newBuilder();

        long rid = event.getRid();
        List<CGoddessMission> missionList = goddessMissionSysCache.getAll();//任务进度
        FetterTaskReward fetterTaskReward = fetterService.getFetterTask(rid);
        List<Integer> taskList = fetterTaskReward.getTaskId();//任务领取
        for (CGoddessMission cModel : missionList) {
            FetterGMsg.PSFetterProgress.Builder progress = FetterGMsg.PSFetterProgress.newBuilder();
            progress.setIdx(cModel.getIdx());
            progress.setNum((int) targetCounterService.calcTaskCount(rid, cModel.getTask()));
            builder.addProgressList(progress.build());
            FetterGMsg.PSFetterStatus.Builder statusTask = FetterGMsg.PSFetterStatus.newBuilder();
            statusTask.setIdx(cModel.getIdx());
            if (taskList.contains(cModel.getIdx())) {
                statusTask.setStatus(1);
            } else {
                statusTask.setStatus(0);
            }
            builder.addStatusList(statusTask.build());
        }
        contextManager.write(rid, CmdCode._28000, builder.build());


        FetterGMsg.GResFetterInitVip.Builder builder2 = FetterGMsg.GResFetterInitVip.newBuilder();
        builder2.setVipLevel(roleService.getOrThrow(rid).getGoddessVip());
        contextManager.write(rid, CmdCode._28103, builder2.build());
    }

    /**
     * Vip权益解锁
     *
     * @param event
     */
    @Subscribe
    public void goddessVipAddition(GoddessVipLevelUpEvent event) {
        CGoddessVip cGoddessVip = goddessVipSysCache.getOrThrow(event.getNewGoddessVip());
        if (cGoddessVip.getExtra_market_times() > 0) {//市场刷新
            shopService.sendOneShopData(event.getRid(), ShopType.MARKET);
        }
        if (cGoddessVip.getExtra_idle_time() > 0) {//离线挂机刷新时长
            roleMissionService.sendIdleList(event.getRid());
        }
    }

    /**
     * 羁绊升级事件
     *
     * @param event
     */
    @Subscribe
    public void on(GoddessLevelUpOperatorEvent event) {
        List<Hero> heroList = heroService.getHeros(event.getRid());
        heroService.computeStrength(event.getRid(), heroList, GameEvent.GODDESS_UP_LEVEL);
    }

    /**
     * 羁绊突破事件
     *
     * @param event
     */
    @Subscribe
    public void on(GoddessBreakEvent event) {
        List<Hero> heroList = heroService.getHeros(event.getRid());
        heroService.computeStrength(event.getRid(), heroList, GameEvent.GODDESS_BREAK);
    }

    /**
     * 羁绊铸魂事件
     *
     * @param event
     */
    @Subscribe
    public void on(GoddessSoulEvent event) {
        List<Hero> heroList = heroService.getHeros(event.getRid());
        heroService.computeStrength(event.getRid(), heroList, GameEvent.GODDESS_SOUL);
    }

    @Subscribe
    public void on(GoddessRefineEvent event) {
        List<Hero> heroList = heroService.getHeros(event.getRid());
        heroService.computeStrength(event.getRid(), heroList, GameEvent.GODDESS_REFINE);
    }

    @Subscribe
    public void on(GoddessWashLevelEvent event) {
        List<Hero> heroList = heroService.getHeros(event.getRid());
        heroService.computeStrength(event.getRid(), heroList, GameEvent.GODDESS_WASH);
    }
}
