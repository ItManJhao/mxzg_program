package com.ayjs.mxzg.gameserver.module.crusadegroup.group.handler;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.util.Nonnull;
import com.ayjs.mxzg.config.struct.CrusadeGroupStage;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.crusadegroup.group.dao.CrusadeGroupDao;
import com.ayjs.mxzg.gameserver.module.crusadegroup.group.dao.RoleCrusadeGroupDao;
import com.ayjs.mxzg.gameserver.module.crusadegroup.group.domain.CrusadeGroup;
import com.ayjs.mxzg.gameserver.module.crusadegroup.group.domain.RoleCrusadeGroup;
import com.ayjs.mxzg.gameserver.module.crusadegroup.occupation.dao.OccupationTaskDao;
import com.ayjs.mxzg.gameserver.module.crusadegroup.occupation.event.BossKillEvent;
import com.ayjs.mxzg.gameserver.module.crusadegroup.shenbin.dao.ShenBinCoreDao;
import com.ayjs.mxzg.gameserver.module.crusadegroup.shenbin.dao.ShenBinEquipDao;
import com.ayjs.mxzg.gameserver.module.rank.service.RankServiceProxy;
import com.ayjs.mxzg.message.module.crusadegroup.CrusadeGroupReqMessage;
import com.ayjs.mxzg.message.module.crusadegroup.CrusadeGroupResMessage;
import com.ayjs.mxzg.message.module.crusadegroup.group.*;
import com.ayjs.mxzg.message.module.crusadegroup.group.dto.Territory;
import com.ayjs.mxzg.message.module.crusadegroup.map.BossBeatMessage;
import com.ayjs.mxzg.message.module.crusadegroup.map.TerritoryUpdateMessage;
import com.ayjs.mxzg.protocol.CrusadeGroupGMsg;
import com.ayjs.rpc.annotation.RemoteMethod;
import com.ayjs.rpc.dispatcher.MessageDispatcher;
import com.ayjs.rpc.dispatcher.MessageHandler;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.List;
import java.util.Map;

/**
 * 讨伐团消息处理器
 */
@Slf4j
@Controller
public class GroupMessageHandler implements MessageHandler {

    @Autowired
    private CrusadeGroupDao crusadeGroupDao;
    @Autowired
    private RoleCrusadeGroupDao roleCrusadeGroupDao;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private MessageDispatcher messageDispatcher;
    @Autowired
    private CrusadeGroupHelper crusadeGroupHelper;
    @Autowired
    private OccupationTaskDao occupationTaskDao;
    @Autowired
    private ShenBinCoreDao shenBinCoreDao;
    @Autowired
    private ShenBinEquipDao shenBinEquipDao;
    @Autowired
    private RankServiceProxy rankServiceProxy;
    @Autowired
    private GroupPusher groupPusher;
    @Autowired
    private EventBus eventBus;

    /**
     * 处理讨伐团消息
     * @param message
     */
    @RemoteMethod
    public void handleCrusadeGroupResMessage(CrusadeGroupResMessage message){
        log.info("收到讨伐团信息");
        CrusadeGroup crusadeGroup = crusadeGroupDao.get();
        crusadeGroup.updateGroup(message.getGroupMapId(),message.getGroupId(), message.getStage(), message.getHead(), message.getCommander(), message.getRegistrationStartTime()
                , message.getRegistrationEndTime(), message.getBattleStartTime(), message.getBattleEndTime(),message.getEmblem(),message.getGroupName());
        crusadeGroupDao.update(crusadeGroup);

        groupPusher.pushStageChange();
    }

    /**
     * 处理讨伐团开启消息
     * @param message
     */
    @RemoteMethod
    public void handleStartRegistrationMessage(StartRegistrationMessage message){
        log.info("讨伐团开始报名");
        messageDispatcher.dispatch(CrusadeGroupReqMessage.getInstance());

        roleCrusadeGroupDao.truncateAll();
        occupationTaskDao.truncateAll();//职级任务
        shenBinCoreDao.truncateAll();//神兵核心
        shenBinEquipDao.truncateAll();//神兵装备
        rankServiceProxy.resetCGRank();//讨伐团排行榜
        CrusadeGroup crusadeGroup = crusadeGroupDao.get();
        crusadeGroup.setStage(CrusadeGroupStage.START_REGISTRATION.ordinal());
        crusadeGroupDao.update(crusadeGroup);

        groupPusher.pushStageChange();
    }

    /**
     * 处理讨伐团结束报名消息
     * @param message
     */
    @RemoteMethod
    public void handleEndRegistrationMessage(EndRegistrationMessage message){
        log.info("讨伐团结束报名");

        CrusadeGroup crusadeGroup = crusadeGroupDao.get();
        crusadeGroup.setStage(CrusadeGroupStage.END_REGISTRATION.ordinal());
        crusadeGroupDao.update(crusadeGroup);

        groupPusher.pushStageChange();
    }

    /**
     * 处理讨伐团结束报名消息
     *
     * @param message
     */
    @RemoteMethod
    public void handleEndRegistrationMessage(UpdateGroupMessage message) {
        log.info("设置讨伐团团长和指挥官");

        CrusadeGroup crusadeGroup = crusadeGroupDao.get();
        crusadeGroup.setStage(CrusadeGroupStage.END_REGISTRATION.ordinal());
        crusadeGroup.setHead(message.getHeadId());
        crusadeGroup.setCommander(Nonnull.orEmpty(message.getCommander()));
        crusadeGroupDao.update(crusadeGroup);
    }

    /**
     * 处理讨伐团开启战斗消息
     * @param message
     */
    @RemoteMethod
    public void handleStartBattleMessage(StartBattleMessage message){
        log.info("讨伐团开启战斗");

        messageDispatcher.dispatch(CrusadeGroupReqMessage.getInstance());
        CrusadeGroup crusadeGroup = crusadeGroupDao.get();
        crusadeGroup.setStage(CrusadeGroupStage.START_BATTLE.ordinal());
        crusadeGroupDao.update(crusadeGroup);

        for (Map.Entry<Long, Territory> birthplace : message.getBirthplace().entrySet()) {
            RoleCrusadeGroup roleCrusadeGroup = roleCrusadeGroupDao.getOrCreate(birthplace.getKey());
            roleCrusadeGroup.initialize(birthplace.getValue());
            crusadeGroupHelper.refreshProductivity(roleCrusadeGroup);
            crusadeGroupHelper.refreshHeroBackpack(roleCrusadeGroup);

            if(contextManager.isOnline(roleCrusadeGroup.getRid())){
                roleCrusadeGroup.setOpenPush(true);
                contextManager.write(roleCrusadeGroup.getRid(), CmdCode._75652, CrusadeGroupGMsg.GCrusadeGroupOpen.getDefaultInstance());
            }
            roleCrusadeGroupDao.update(roleCrusadeGroup);
        }

        groupPusher.pushStageChange();
    }

    /**
     * 讨伐团战斗结束
     * @param message
     */
    @RemoteMethod
    public void handleEndBattleMessage(EndBattleMessage message) {
        log.info("讨伐团战斗结束");
        CrusadeGroup crusadeGroup = crusadeGroupDao.get();
        crusadeGroup.setStage(CrusadeGroupStage.END_BATTLE.ordinal());
        crusadeGroupDao.update(crusadeGroup);

        groupPusher.pushStageChange();
    }

    /**
     * 讨伐团开始结算
     * @param message
     */
    @RemoteMethod
    public void handleSettlementMessage(SettlementMessage message) {
        log.info("讨伐团开始结算");
        CrusadeGroup crusadeGroup = crusadeGroupDao.get();
        crusadeGroup.setStage(CrusadeGroupStage.SETTLEMENT.ordinal());
        crusadeGroupDao.update(crusadeGroup);

        groupPusher.pushStageChange();
    }

    /**
     * 讨伐团关闭
     * @param message
     */
    @RemoteMethod
    public void handleCloseMessage(CloseMessage message) {
        log.info("讨伐团活动关闭");
        CrusadeGroup crusadeGroup = crusadeGroupDao.get();
        crusadeGroup.setStage(CrusadeGroupStage.UN_OPEN.ordinal());
        crusadeGroupDao.update(crusadeGroup);
        groupPusher.pushStageChange();

        messageDispatcher.dispatch(CrusadeGroupReqMessage.getInstance());
    }

    /**
     * 领地变更
     * @param message
     */
    @RemoteMethod
    public void handleTerritoryUpdateMessage(TerritoryUpdateMessage message){
        CrusadeGroupGMsg.GPushTerritoryUpdate.Builder builder = CrusadeGroupGMsg.GPushTerritoryUpdate.newBuilder();
        CrusadeGroupGMsg.PSTerritory.Builder territory = CrusadeGroupGMsg.PSTerritory.newBuilder();
        territory.setId(message.getTerritoryId()).setElement(message.getElement()).setOccupiedId(message.getOccupiedId()).setHeroId(message.getHeroId());
        builder.setTerritory(territory.build());

        CrusadeGroupGMsg.GPushTerritoryUpdate update = builder.build();
        List<RoleCrusadeGroup> roles = roleCrusadeGroupDao.listAll();
        for (RoleCrusadeGroup role : roles) {
            contextManager.write(role.getRid(), CmdCode._75670, update);
        }
    }

    /**
     * boss击败消息
     *
     * @param message
     */
    @RemoteMethod
    public void handleBossBeatMessage(BossBeatMessage message) {
        eventBus.post(BossKillEvent.of());
        log.info("发布boss击杀事件！");
    }

}
