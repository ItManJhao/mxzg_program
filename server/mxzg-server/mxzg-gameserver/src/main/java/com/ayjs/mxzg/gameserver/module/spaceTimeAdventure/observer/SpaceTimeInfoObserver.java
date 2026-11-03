package com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.observer;

import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.Faction;
import com.ayjs.mxzg.battle.model.mirror.BattlerVo;
import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.config.excel.cache.spaceTime.SpaceTimeEventSysCache;
import com.ayjs.mxzg.config.excel.entity.spaceTime.CSpaceTimeEvent;
import com.ayjs.mxzg.config.struct.LineUpType;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.battle.BattleHelper;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.event.LoginEvent;
import com.ayjs.mxzg.gameserver.module.role.event.LogoutEvent;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.domain.SpaceTimeInfo;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.event.SailingExploreEvent;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.event.SailingProgressEvent;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.event.SailingStartEvent;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.service.SpaceTimeInfoService;
import com.ayjs.mxzg.message.module.spacetimeAdventure.SpaceTimeUpdateInfoReqMessage;
import com.ayjs.mxzg.message.module.teamArena.message.TeamArenaLineUpReqMessage;
import com.ayjs.mxzg.protocol.SpaceTimeAdventureGMsg;
import com.ayjs.rpc.dispatcher.MessageDispatcher;
import com.ayjs.rpc.dispatcher.MessageHandler;
import com.ayjs.rpc.util.ProtostuffUtil;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 时空冒险航行监听
 *
 * @author hyx
 */
@Observer
public class SpaceTimeInfoObserver {

    @Autowired
    private SpaceTimeInfoService spaceTimeInfoService;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private SpaceTimeEventSysCache spaceTimeEventSysCache;
    @Autowired
    private RoleService roleService;
    @Autowired
    private BattleHelper battleHelper;
    @Autowired
    private MessageDispatcher messageDispatcher;

    @Subscribe
    public void listen(LogoutEvent event) {
        SpaceTimeInfo spaceTimeInfo = spaceTimeInfoService.getInfo(event.getRid());
        if (spaceTimeInfo.getEventId() > 0) {
            spaceTimeInfo.setEventId(0);
            spaceTimeInfoService.update(spaceTimeInfo);
        }
    }

    @Subscribe
    public void listen(LoginEvent event) {
        SpaceTimeInfo spaceTimeInfo = spaceTimeInfoService.getInfo(event.getRid());
        if (spaceTimeInfo.getEventId() > 0) {
            spaceTimeInfo.setEventId(0);
            spaceTimeInfoService.update(spaceTimeInfo);
        }
    }

    @Subscribe
    public void listen(SailingProgressEvent event) {
        SpaceTimeInfo spaceTimeInfo = spaceTimeInfoService.getInfo(event.getRid());
        if (spaceTimeInfo.getRouteId() > 0) {
            SpaceTimeAdventureGMsg.GResUpdateSailingProgress.Builder builder = SpaceTimeAdventureGMsg.GResUpdateSailingProgress.newBuilder();
            builder.setEndTime(spaceTimeInfoService.getSailingEndTime(spaceTimeInfo));
            builder.setNotProgress(spaceTimeInfoService.getSailingProgress(spaceTimeInfo));
            contextManager.write(event.getRid(), CmdCode._74143, builder.build());
        }
    }

  /*  @Subscribe
    public void listen(SailingStartEvent event) {
        SpaceTimeInfo spaceTimeInfo = spaceTimeInfoService.getInfo(event.getRid());

        SpaceTimeAdventureGMsg.GResUpdateSailingProgress.Builder builder = SpaceTimeAdventureGMsg.GResUpdateSailingProgress.newBuilder();
        builder.setEndTime(spaceTimeInfoService.getSailingEndTime(spaceTimeInfo));
        builder.setNotProgress(spaceTimeInfoService.getSailingProgress(spaceTimeInfo));
        contextManager.write(event.getRid(), CmdCode._74143, builder.build());
    }*/

    @Subscribe
    public void upload(SailingStartEvent event) {
        //上传航行英雄阵容数据
        SpaceTimeUpdateInfoReqMessage message = new SpaceTimeUpdateInfoReqMessage();
        Role role = roleService.getOrThrow(event.getRid());
        message.setRid(role.getId());
        message.setNick(role.getNick());
        message.setServerId(role.getServerId());
        message.setMaxFighting(role.getMaxFighting());
        message.setBattlerMap(uploadingInfo(role));
        messageDispatcher.dispatch(message);
    }

    private Map<Integer, byte[]> uploadingInfo(Role role) {
        Map<Integer, byte[]> battlerMap = new HashMap<>();
        //武器系统
        BattlerDo battlerDo = battleHelper.queryPlayerBattler(LineUpType.SPACE_TIME_WEAPON, role.getId(), Faction.ATTACKER);
        battlerDo.setRoleInfo(role.getServerId(), role.getHeadId(), role.getBorderId(), role.getLevel(), role.getFighting());
        battlerMap.put(LineUpType.SPACE_TIME_WEAPON.getValue(), ProtostuffUtil.serialize(battlerDo.toBattlerVo()));
        //动力系统
        BattlerDo battlerDo2 = battleHelper.queryPlayerBattler(LineUpType.SPACE_TIME_IMPETUS, role.getId(), Faction.ATTACKER);
        battlerDo2.setRoleInfo(role.getServerId(), role.getHeadId(), role.getBorderId(), role.getLevel(), role.getFighting());
        battlerMap.put(LineUpType.SPACE_TIME_IMPETUS.getValue(), ProtostuffUtil.serialize(battlerDo2.toBattlerVo()));
        return battlerMap;
    }

    @Subscribe
    public void listen(SailingExploreEvent event) {
        CSpaceTimeEvent cSpaceTimeEvent = spaceTimeEventSysCache.getOrThrow(event.getEventId());
        if (cSpaceTimeEvent.getIs_show() == 1) {//只有在图鉴中展示的事件才需要记录
            SpaceTimeInfo spaceTimeInfo = spaceTimeInfoService.getInfo(event.getRid());
            if (!spaceTimeInfo.getUnlockEvent().contains(event.getEventId())) {
                spaceTimeInfo.getUnlockEvent().add(event.getEventId());
                spaceTimeInfoService.update(spaceTimeInfo);

                SpaceTimeAdventureGMsg.GResUpdateIllustrate.Builder builder = SpaceTimeAdventureGMsg.GResUpdateIllustrate.newBuilder();
                builder.setEventId(event.getEventId());
                contextManager.write(event.getRid(), CmdCode._74145, builder.build());
            }
        }
    }

}
