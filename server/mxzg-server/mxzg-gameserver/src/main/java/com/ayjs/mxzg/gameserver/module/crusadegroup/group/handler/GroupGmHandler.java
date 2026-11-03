package com.ayjs.mxzg.gameserver.module.crusadegroup.group.handler;


import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.config.excel.cache.crusadegroup.CrusadeGroupMapSysCache;
import com.ayjs.mxzg.config.excel.cache.occupation.OccupationSysCache;
import com.ayjs.mxzg.config.excel.entity.crusadegroup.CCrusadeGroupMap;
import com.ayjs.mxzg.config.excel.entity.occupation.COccupation;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.gm.GMCommand;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.GMCmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.Rewards;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.crusadegroup.group.dao.CrusadeGroupDao;
import com.ayjs.mxzg.gameserver.module.crusadegroup.group.dao.RoleCrusadeGroupDao;
import com.ayjs.mxzg.gameserver.module.crusadegroup.group.domain.CrusadeGroup;
import com.ayjs.mxzg.gameserver.module.crusadegroup.group.domain.CrusadeGroupHero;
import com.ayjs.mxzg.gameserver.module.crusadegroup.group.domain.RoleCrusadeGroup;
import com.ayjs.mxzg.gameserver.module.crusadegroup.occupation.event.CityOccupyEvent;
import com.ayjs.mxzg.gameserver.module.crusadegroup.occupation.event.OccupationUpEvent;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.message.module.crusadegroup.group.GmCleanBeaterMessage;
import com.ayjs.mxzg.message.module.crusadegroup.group.GmExecuteNextReqMessage;
import com.ayjs.mxzg.message.module.crusadegroup.group.GmExecuteNextResMessage;
import com.ayjs.mxzg.message.module.crusadegroup.group.GmExecuteOccupiedReqMessage;
import com.ayjs.mxzg.message.module.crusadegroup.group.GmExecuteOccupiedResMessage;
import com.ayjs.mxzg.message.module.crusadegroup.group.GmExecuteResetReqMessage;
import com.ayjs.mxzg.message.module.crusadegroup.group.GmExecuteResetResMessage;
import com.ayjs.mxzg.message.module.crusadegroup.group.dto.Territory;
import com.ayjs.mxzg.protocol.CrusadeGroupGMsg;
import com.ayjs.mxzg.protocol.CrusadeGroupOccupationGMsg;
import com.ayjs.rpc.dispatcher.MessageDispatcher;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.util.CollectionUtils;

import java.util.List;

@Slf4j
@Controller
public class GroupGmHandler extends ProtocolHandler {

    @Autowired
    private CrusadeGroupDao crusadeGroupDao;
    @Autowired
    private MessageDispatcher messageDispatcher;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private RoleCrusadeGroupDao roleCrusadeGroupDao;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private ThingService thingService;
    @Autowired
    private OccupationSysCache occupationSysCache;
    @Autowired
    private CrusadeGroupMapSysCache crusadeGroupMapSysCache;

    /**
     * 讨伐团重置
     *
     * @param role
     * @param param
     */
    @GMCommand(command = GMCmdCode.RESET_CRUSADE_GROUP)
    public void handleResetCrusadeGroup(Role role, List<String> param) {
        CrusadeGroup crusadeGroup = crusadeGroupDao.get();
        log.info("Gm执行讨伐团重置阶段，当前阶段{}", crusadeGroup.getStage());
        messageDispatcher.dispatch(GmExecuteResetReqMessage.getInstance(), result -> {
            GmExecuteResetResMessage message = (GmExecuteResetResMessage) result;
            CrusadeGroupGMsg.GPushStageChange.Builder builder = CrusadeGroupGMsg.GPushStageChange.newBuilder();
            builder.setStage(message.getStage());
            log.info("讨伐团进入{}阶段", message.getStage());
            contextManager.writeAll(CmdCode._75649, builder.build());
        });
    }

    /**
     * 讨伐团进入下一阶段
     * @param role
     * @param param
     */
    @GMCommand(command = GMCmdCode.CRUSADE_GROUP_NEXT)
    public void handleCrusadeGroupNext(Role role, List<String> param) {
        CrusadeGroup crusadeGroup = crusadeGroupDao.get();
        log.info("Gm执行讨伐团进入到下一阶段，当前阶段{}", crusadeGroup.getStage());
        messageDispatcher.dispatch(GmExecuteNextReqMessage.getInstance(), result -> {
            GmExecuteNextResMessage message = (GmExecuteNextResMessage) result;
            CrusadeGroupGMsg.GPushStageChange.Builder builder = CrusadeGroupGMsg.GPushStageChange.newBuilder();
            builder.setStage(message.getStage());
            log.info("讨伐团进入{}阶段", message.getStage());
            contextManager.writeAll(CmdCode._75649, builder.build());
        });
    }

    /**
     * 增加體力
     *
     * @param role
     * @param param
     */
    @GMCommand(command = GMCmdCode.INCREASE_PHYSICAL_STRENGTH)
    public void handleIncreasePhysicalStrength(Role role, List<String> param) {
        int physical = 100;
        if (!CollectionUtils.isEmpty(param)) {
            physical = Integer.parseInt(param.get(0));
        }
        RoleCrusadeGroup roleCrusadeGroup = roleCrusadeGroupDao.getOrCreate(role.getId());
        for (CrusadeGroupHero hero : roleCrusadeGroup.getHeroes().values()) {
            if (hero.notEmpty()) {
                hero.recoveryPhysical(physical);
            }
        }
        roleCrusadeGroupDao.update(roleCrusadeGroup);
    }

    /**
     * 升级讨伐团职级
     *
     * @param role
     * @param param
     */
    @GMCommand(command = GMCmdCode.UP_OCCUPATION)
    public void handleUpOccupation(Role role, List<String> param) {
        RoleCrusadeGroup roleCrusadeGroup = roleCrusadeGroupDao.getOrCreate(role.getId());
        roleCrusadeGroup.setKnighthoodId(roleCrusadeGroup.getKnighthoodId() + 1);
        roleCrusadeGroupDao.update(roleCrusadeGroup);

        COccupation cOccupation_now = occupationSysCache.getById(roleCrusadeGroup.getKnighthoodId());
        Rewards rewards = thingService.add(role.getId(), cOccupation_now.getReward(),
                GameEvent.OCCUPATION_UP_REWARD, NoticeType.NORMAL);

        CrusadeGroupOccupationGMsg.GResOccupationUp.Builder builder = CrusadeGroupOccupationGMsg.GResOccupationUp.newBuilder();
        builder.setOcId(roleCrusadeGroup.getKnighthoodId());
        contextManager.write(role.getId(), CmdCode._75607, builder.build());
        eventBus.post(OccupationUpEvent.valueOf(role.getId(), roleCrusadeGroup.getKnighthoodId()));
    }

    /**
     * 直接占领领地
     *
     * @param role
     * @param param
     */
    @GMCommand(command = GMCmdCode.OCCUPIED_TERRITORY)
    public void handleOccupiedTerritory(Role role, List<String> param) {

        CCrusadeGroupMap map;
        if (param.size() == 1) {
            int territoryId = Integer.parseInt(param.get(0));
            map = crusadeGroupMapSysCache.getMap(territoryId);
        } else {
            int x = Integer.parseInt(param.get(0));
            int y = Integer.parseInt(param.get(1));
            map = crusadeGroupMapSysCache.getMap(x, y);
        }

        int territoryId = map.getGroup_id();
        log.info("gm执行占领领地指令x = {}, y = {} territoryId = {}", map.getX(), map.getY(), territoryId);
        messageDispatcher.dispatch(GmExecuteOccupiedReqMessage.valueOf(role.getId(), territoryId), result -> {
            GmExecuteOccupiedResMessage message = (GmExecuteOccupiedResMessage) result;
            Territory territory = Territory.valueOf(message.getTerritoryId(), role.getId(), message.getElement(), 0);
            RoleCrusadeGroup roleCrusadeGroup = roleCrusadeGroupDao.getOrCreate(role.getId());
            roleCrusadeGroup.occupationTerritory(territory);

            eventBus.post(CityOccupyEvent.of(role.getId(), map.getArea_level(), map.getBuilding_level(), 1));
        });
    }

    /**
     * 直接占领领地
     *
     * @param role
     * @param param
     */
    @GMCommand(command = GMCmdCode.CLEAN_BEATER)
    public void handleGmCleanBeaterMessage(Role role, List<String> param) {
        messageDispatcher.dispatch(GmCleanBeaterMessage.getInstance());
    }


}
