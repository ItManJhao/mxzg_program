package com.ayjs.mxzg.gameserver.module.clan.observer;


import com.ayjs.mxzg.common.convert.ConvertUtils;
import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.gameserver.infrastructure.constant.ServerConfig;
import com.ayjs.mxzg.gameserver.module.clan.domain.Clan;
import com.ayjs.mxzg.gameserver.module.clan.domain.ClanBossBattleInfo;
import com.ayjs.mxzg.gameserver.module.clan.event.ClanChangeEvent;
import com.ayjs.mxzg.gameserver.module.clan.event.ClanDungeonKillEvent;
import com.ayjs.mxzg.gameserver.module.clan.event.ClanFightingUpdateEvent;
import com.ayjs.mxzg.gameserver.module.clan.service.ClanBossService;
import com.ayjs.mxzg.gameserver.module.clan.service.ClanService;
import com.ayjs.mxzg.gameserver.module.hero.event.RoleFightChangeEvent;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.server.constant.ServerParamType;
import com.ayjs.mxzg.gameserver.module.server.domain.ServerParam;
import com.ayjs.mxzg.gameserver.module.server.service.ServerParamService;
import com.ayjs.mxzg.gameserver.remote.cross.event.CrossConnectedEvent;
import com.ayjs.mxzg.message.module.clan.MemberChangeClanMessage;
import com.ayjs.mxzg.message.module.clan.MemberChangeClanMessage.MemberChangeClanMessageBuilder;
import com.ayjs.rpc.dispatcher.MessageDispatcher;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;

/**
 * 公会监听
 *
 * @author hyx
 */
@Observer
public class ClanObserver {

    @Autowired
    private ClanBossService clanBossService;

    @Autowired
    private ClanService clanService;

    @Autowired
    private EventBus eventBus;
    @Autowired
    private RoleService roleService;
    @Autowired
    private MessageDispatcher messageDispatcher;
    @Autowired
    private ServerConfig serverConfig;
    @Autowired
    private ServerParamService serverParamService;


    /**
     * 公会BOSS击杀，成员挑战次数重量置
     *
     * @param event
     */
    @Subscribe
    public void resetClanDungeonBattleNum(ClanDungeonKillEvent event) {
        List<ClanBossBattleInfo> clanBossBattleInfos = clanBossService.selectClanBattleAll(event.getClanId());
        for (ClanBossBattleInfo clanBossBattleInfo : clanBossBattleInfos) {
            clanBossService.remakeClanBossBattleInfo(clanBossBattleInfo);
        }
        clanBossService.updateClanBossBattleInfoAll(clanBossBattleInfos);
    }

    /**
     * 公会成员变动影响公会排行事件
     *
     * @param event
     */
    @Subscribe(async = Subscribe.AsyncType.Async)
    private void clanChange(ClanChangeEvent event) {
        long clanId = 0;
        long newFight = 0;
        Clan clan = null;
        if (event.getNewClanId() > 0) {
            clan = clanService.getOrThrow(event.getNewClanId());
            clan.setClanFighting(clanService.clanFightingAll(event.getNewClanId()));
            clan.setFightingUpdateTime(TimeDateUtil.getCurrentTimeInt());
            clanService.updateClan(clan);

            clanId = event.getNewClanId();
            newFight = clan.getClanFighting();
        } else if (event.getOldClanId() > 0) {
            clanId = event.getOldClanId();
            if (event.isDissolve()) {
                newFight = 0;
            } else {
                clan = clanService.getOrThrow(event.getOldClanId());
                clan.setClanFighting(clanService.clanFightingAll(event.getOldClanId()));
                clan.setFightingUpdateTime(TimeDateUtil.getCurrentTimeInt());
                clanService.updateClan(clan);
                newFight = clan.getClanFighting();
            }
        }
        eventBus.post(ClanFightingUpdateEvent.of(clanId, newFight, event.isDissolve()));
        clanService.addToSendCrossList(clanId);

        MemberChangeClanMessageBuilder builder = MemberChangeClanMessage.builder();
    	builder.rid(event.getRid());
    	builder.newClanId(event.getNewClanId());
    	builder.oldClanId(event.getOldClanId());
    	messageDispatcher.dispatch(builder.build());
    }

    /**
     * 公会成员战力变动影响公会排行事件
     */
    @Subscribe(async = Subscribe.AsyncType.Async)
    public void clanMemberFighting(RoleFightChangeEvent event) {
        Role role = roleService.getOrThrow(event.getRid());
        if (role.getClanId() > 0) {
            Clan clan = clanService.getOrThrow(role.getClanId());
            clan.setClanFighting(clanService.clanFightingAll(role.getClanId()));
            clan.setFightingUpdateTime(TimeDateUtil.getCurrentTimeInt());
            clanService.updateClan(clan);
            eventBus.post(ClanFightingUpdateEvent.of(clan.getId(), clan.getClanFighting(), false));

            clanService.addToSendCrossList(clan.getId());
//            messageDispatcher.dispatch(buildMessage(clan, clan.getId()));

        }
    }


    /**
     * 跨服连接完成之后，上报所有公会
     */
    @Subscribe(async = Subscribe.AsyncType.Async)
    public void crossEvent(CrossConnectedEvent event) {//
        ServerParam serverParam = serverParamService.get(ServerParamType.CROSS_CLAN_SEND);
        if (serverParam == null) {
            serverParam = new ServerParam();
            serverParam.setSpKey(ServerParamType.CROSS_CLAN_SEND.getValue());
            serverParam.setSpValue(0 + "");
            serverParamService.add(serverParam);
        }

        if (ConvertUtils.toInt(serverParam.getSpValue()) == 1) {
            return;
        }
        serverParam.setSpValue(1 + "");
        serverParamService.update(serverParam);
        List<Clan> clanList = clanService.selectAll();
        clanList.forEach(clan -> {
            clanService.addToSendCrossList(clan.getId());
//            messageDispatcher.dispatch(buildMessage(clan, clan.getId()));
        });
    }

}
