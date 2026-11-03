package com.ayjs.mxzg.gameserver.module.headPortrait.observer;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.config.excel.cache.HeadUnlockSysCache;
import com.ayjs.mxzg.config.excel.entity.CHeadUnlock;
import com.ayjs.mxzg.config.struct.TargetType;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.fetter.event.GoddessVipLevelUpEvent;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.event.FashionActiveEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.FashionExpiresEvent;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.event.RoleLvUpEvent;
import com.ayjs.mxzg.gameserver.module.headPortrait.domain.RoleHeadPortrait;
import com.ayjs.mxzg.gameserver.module.headPortrait.service.RoleHeadPortraitService;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroGetEvent;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.protocol.HeadPortraitGMsg;
import org.springframework.beans.factory.annotation.Autowired;
import com.ayjs.mxzg.common.event.annotation.Subscribe;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 头像解锁监听
 *
 * @author hyx
 */
@Observer
public class HeadPortraitObserver {

    @Autowired
    private HeadUnlockSysCache headUnlockSysCache;
    @Autowired
    private RoleHeadPortraitService roleHeadPortraitService;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private RoleService roleService;

    /**
     * 获得英雄解锁头像
     *
     * @param event
     */
    @Subscribe
    public void unlockHeroPortrait(HeroGetEvent event) {

        List<CHeadUnlock> unlockList = headUnlockSysCache.getUnlockHeadId(TargetType.GET_NEW_HERO);
        RoleHeadPortrait roleHeadPortrait = roleHeadPortraitService.select(event.getRid());
        List<Integer> unlockHeadList = new ArrayList<>();

        unlockList.stream().filter(config -> !roleHeadPortrait.getHeadIds().contains(config.getIcon())).forEach(config -> {
            for (Hero hero : event.getHeros()) {
                if (hero.getType() == config.getUnlock_task().getCondition()) {
                    roleHeadPortrait.getHeadIds().add(config.getIcon());
                    roleHeadPortraitService.update(roleHeadPortrait);
                    unlockHeadList.add(config.getIcon());
                }
            }
        });

        sendUnlockHeadPortrait(event.getRid(), unlockHeadList);
    }

    /**
     * 激活皮肤获得头像
     *
     * @param event
     */
    @Subscribe
    public void listen(FashionActiveEvent event) {
        List<CHeadUnlock> unlockList = headUnlockSysCache.getUnlockHeadId(TargetType.GET_NEW_FASHION);
        RoleHeadPortrait roleHeadPortrait = roleHeadPortraitService.select(event.getRid());
        List<Integer> unlockHeadList = new ArrayList<>();

        unlockList.stream().filter(config -> !roleHeadPortrait.getHeadIds().contains(config.getIcon())).forEach(config -> {
            if (event.getFashionId() == config.getUnlock_task().getCondition()) {
                roleHeadPortrait.getHeadIds().add(config.getIcon());
                roleHeadPortraitService.update(roleHeadPortrait);
                unlockHeadList.add(config.getIcon());
            }
        });

        sendUnlockHeadPortrait(event.getRid(), unlockHeadList);
    }

    private void sendUnlockHeadPortrait(long rid, List<Integer> headIds) {
        if (headIds.size() > 0) {
            HeadPortraitGMsg.GResUnlockHeadPortrait.Builder builder = HeadPortraitGMsg.GResUnlockHeadPortrait.newBuilder();
            builder.addAllIdxs(headIds);
            contextManager.write(rid, CmdCode._34003, builder.build());
        }
    }

    /**
     * 皮肤过期,清除头像
     *
     * @param event
     */
    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(FashionExpiresEvent event) {

        List<CHeadUnlock> unlockList = headUnlockSysCache.getUnlockHeadId(TargetType.GET_NEW_FASHION).stream().
                filter(config -> event.getFashionList().contains(config.getUnlock_task().getCondition())).collect(Collectors.toList());
        List<Integer> headList = new ArrayList<>();

        RoleHeadPortrait roleHeadPortrait = roleHeadPortraitService.select(event.getRid());
        for (CHeadUnlock cHeadUnlock : unlockList) {
            roleHeadPortrait.getHeadIds().remove(cHeadUnlock.getIcon());
            headList.add(cHeadUnlock.getIcon());
        }
        roleHeadPortraitService.update(roleHeadPortrait);

        HeadPortraitGMsg.GResHeadPortraitList.Builder builder = HeadPortraitGMsg.GResHeadPortraitList.newBuilder();
        builder.addAllIdxList(roleHeadPortrait.getHeadIds());
        contextManager.write(event.getRid(), CmdCode._34001, builder.build());

        //玩家头像操作
        Role role = roleService.getOrThrow(event.getRid());
        if (headList.contains(role.getHeadId())) {
            //若装备了已清除的头像则更换头像
            roleHeadPortraitService.sendChangeHead(role, 0);
        }

    }
}
