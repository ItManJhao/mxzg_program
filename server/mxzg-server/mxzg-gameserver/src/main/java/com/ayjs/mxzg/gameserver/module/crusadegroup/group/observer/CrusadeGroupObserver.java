package com.ayjs.mxzg.gameserver.module.crusadegroup.group.observer;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.config.struct.CrusadeGroupStage;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.crusadegroup.group.dao.CrusadeGroupDao;
import com.ayjs.mxzg.gameserver.module.crusadegroup.group.dao.RoleCrusadeGroupDao;
import com.ayjs.mxzg.gameserver.module.crusadegroup.group.domain.CrusadeGroup;
import com.ayjs.mxzg.gameserver.module.crusadegroup.group.domain.RoleCrusadeGroup;
import com.ayjs.mxzg.gameserver.module.crusadegroup.group.handler.CrusadeGroupHelper;
import com.ayjs.mxzg.gameserver.module.crusadegroup.group.service.GroupService;
import com.ayjs.mxzg.gameserver.module.crusadegroup.occupation.event.OccupationUpEvent;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroDeleteEvent;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroSwitchEvent;
import com.ayjs.mxzg.gameserver.module.role.event.LoginEvent;
import com.ayjs.mxzg.gameserver.remote.cross.event.CrossConnectedEvent;
import com.ayjs.mxzg.message.module.crusadegroup.CrusadeGroupReqMessage;
import com.ayjs.mxzg.message.module.crusadegroup.map.KnighthoodSynchMessage;
import com.ayjs.mxzg.protocol.CrusadeGroupGMsg;
import com.ayjs.rpc.dispatcher.MessageDispatcher;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;

@Slf4j
@Observer
public class CrusadeGroupObserver {

    @Autowired
    private MessageDispatcher messageDispatcher;
    @Autowired
    private CrusadeGroupDao crusadeGroupDao;
    @Autowired
    private RoleCrusadeGroupDao roleCrusadeGroupDao;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private GroupService groupService;
    @Autowired
    private CrusadeGroupHelper crusadeGroupHelper;

    @Subscribe
    public void listen(CrossConnectedEvent event) {
        log.info("请求讨伐团信息。。。");
        messageDispatcher.dispatch(CrusadeGroupReqMessage.getInstance());
    }

    /**
     * 登录时检测活动是否开启
     * @param event
     */
    @Subscribe
    public void onLoginEvent(LoginEvent event){
        CrusadeGroup crusadeGroup = crusadeGroupDao.get();
        if(crusadeGroup.getStage() != CrusadeGroupStage.START_BATTLE.ordinal()){
            return;
        }

        RoleCrusadeGroup roleCrusadeGroup = roleCrusadeGroupDao.getOrCreate(event.getRid());
        if(roleCrusadeGroup.isRegistration() && !roleCrusadeGroup.isOpenPush()){
            contextManager.write(event.getRid(), CmdCode._75652, CrusadeGroupGMsg.GCrusadeGroupOpen.getDefaultInstance());
            roleCrusadeGroup.setOpenPush(true);
            roleCrusadeGroupDao.update(roleCrusadeGroup);
        }

    }

    /**
     * 英雄删除时移除英雄
     *
     * @param event
     */
    @Subscribe
    public void onHeroDeleteEvent(HeroDeleteEvent event) {
        CrusadeGroup crusadeGroup = crusadeGroupDao.get();
        if (crusadeGroup.getStage() != CrusadeGroupStage.START_BATTLE.ordinal()) {
            return;
        }

        RoleCrusadeGroup roleCrusadeGroup = roleCrusadeGroupDao.getOrCreate(event.getRid());

        for (Hero hero : event.getHeros()) {
            roleCrusadeGroup.cancelHero(hero.getId(), true);
        }

        groupService.refreshProductivity(roleCrusadeGroup);
        roleCrusadeGroupDao.update(roleCrusadeGroup);
    }

    /**
     * 英雄删除时移除英雄
     *
     * @param event
     */
    @Subscribe
    public void onHeroSwitchEvent(HeroSwitchEvent event) {
        CrusadeGroup crusadeGroup = crusadeGroupDao.get();
        if (crusadeGroup.getStage() != CrusadeGroupStage.START_BATTLE.ordinal()) {
            return;
        }

        RoleCrusadeGroup roleCrusadeGroup = roleCrusadeGroupDao.getOrCreate(event.getHero().getRid());

        roleCrusadeGroup.cancelHero(event.getHero().getId(), false);

        groupService.refreshProductivity(roleCrusadeGroup);
        roleCrusadeGroupDao.update(roleCrusadeGroup);
    }

    /**
     * 进阶时刷新背包
     *
     * @param event
     */
    @Subscribe
    public void onOccupationUpEvent(OccupationUpEvent event) {
        RoleCrusadeGroup roleCrusadeGroup = roleCrusadeGroupDao.getOrCreate(event.getRid());
        crusadeGroupHelper.refreshHeroBackpack(roleCrusadeGroup);
        roleCrusadeGroupDao.update(roleCrusadeGroup);
    }

    /**
     * 进阶时通知跨服
     *
     * @param event
     */
    @Subscribe
    public void onOccupationUpToCross(OccupationUpEvent event) {
        messageDispatcher.dispatch(KnighthoodSynchMessage.valueOf(event.getRid(), event.getKnighthoodId()));
    }

}
