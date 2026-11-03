package com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.handler;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.config.excel.cache.spaceTime.SpaceTimeAdventureSysCache;
import com.ayjs.mxzg.config.excel.cache.spaceTime.SpaceTimeEventShowSysCache;
import com.ayjs.mxzg.config.excel.entity.spaceTime.CSpaceTimeAdventure;
import com.ayjs.mxzg.config.excel.entity.spaceTime.CSpaceTimeEventShow;
import com.ayjs.mxzg.config.struct.FleetUnlockStruct;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.gameserver.infrastructure.gm.GMCommand;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.GMCmdCode;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.constant.FleetEventType;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.domain.SpaceTimeInfo;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.event.SailingExploreEvent;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.event.SailingProgressEvent;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.service.SpaceTimeInfoService;
import com.ayjs.mxzg.protocol.SpaceTimeAdventureGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 时空冒险GM
 *
 * @author hyx
 */
@Controller
public class SpaceTimeGmHandler extends ProtocolHandler {

    @Autowired
    private SpaceTimeInfoService spaceTimeInfoService;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private SpaceTimeAdventureSysCache spaceTimeAdventureSysCache;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private SpaceTimeEventShowSysCache spaceTimeEventShowSysCache;

    @GMCommand(command = GMCmdCode.SPACE_TIME_SKILL)
    public void addSkillNum(Role role, List<String> param) {
        int skillNum = Integer.parseInt(param.get(0));

        SpaceTimeInfo spaceTimeInfo = spaceTimeInfoService.getInfo(role.getId());
        spaceTimeInfo.setSkillNum(spaceTimeInfo.getSkillNum() + skillNum);
        spaceTimeInfoService.update(spaceTimeInfo);

        this.sendBuilder(spaceTimeInfo);
    }

    @GMCommand(command = GMCmdCode.SPACE_TIME_DURABILITY)
    public void costDurability(Role role, List<String> param) {
        int durability = Integer.parseInt(param.get(0));

        SpaceTimeInfo spaceTimeInfo = spaceTimeInfoService.getInfo(role.getId());
        spaceTimeInfo.setDurability(spaceTimeInfo.getDurability() - durability);
        spaceTimeInfoService.update(spaceTimeInfo);

        this.sendBuilder(spaceTimeInfo);

        eventBus.post(SailingProgressEvent.of(spaceTimeInfo.getRid()));
    }

    private void sendBuilder(SpaceTimeInfo spaceTimeInfo) {
        SpaceTimeAdventureGMsg.GResFleetInfo.Builder builder = SpaceTimeAdventureGMsg.GResFleetInfo.newBuilder();
        builder.setLevel(spaceTimeInfo.getFleetLevel());
        builder.setExp(spaceTimeInfo.getFleetExp());
        builder.setNick(spaceTimeInfo.getFleetName());
        builder.setDurability(spaceTimeInfo.getDurability());
        builder.setSkillNum(spaceTimeInfo.getSkillNum());
        spaceTimeInfo.getSkillMap().forEach((key, value) -> {
            builder.addSkill(spaceTimeInfoService.builderFleetSkill(key, value));
        });
        contextManager.write(spaceTimeInfo.getRid(), CmdCode._74121, builder.build());
    }

    @GMCommand(command = GMCmdCode.SPACE_TIME_PROGRESS)
    public void addProgress(Role role, List<String> param) {
        double progress = Double.parseDouble(param.get(0));

        SpaceTimeInfo spaceTimeInfo = spaceTimeInfoService.getInfo(role.getId());
        if (spaceTimeInfo.getRouteId() > 0) {
            CSpaceTimeAdventure cSpaceTimeAdventure = spaceTimeAdventureSysCache.getOrThrow(spaceTimeInfo.getRouteId());
            progress = cSpaceTimeAdventure.getTotalProgress() * progress / 100;
            spaceTimeInfo.setNotProgress(Math.min(spaceTimeInfo.getNotProgress() + (int) progress, cSpaceTimeAdventure.getTotalProgress()));
            spaceTimeInfoService.update(spaceTimeInfo);

            eventBus.post(SailingProgressEvent.of(role.getId()));
        }

    }

    @GMCommand(command = GMCmdCode.SPACE_TIME_ENERGY)
    public void addEnergy(Role role, List<String> param) {
        int energy = Integer.parseInt(param.get(0));

        SpaceTimeInfo spaceTimeInfo = spaceTimeInfoService.getInfo(role.getId());
        spaceTimeInfo.setEnergy(spaceTimeInfo.getEnergy() + energy);
        spaceTimeInfoService.update(spaceTimeInfo);

        SpaceTimeAdventureGMsg.GResSpaceTimeAdventureInfo.Builder builder = SpaceTimeAdventureGMsg.GResSpaceTimeAdventureInfo.newBuilder();
        builder.setNotRoute(spaceTimeInfo.getRouteId());
        builder.addAllUnlockRoute(spaceTimeInfo.getUnlockRoutes());
        builder.setEnergy(spaceTimeInfo.getEnergy());
        builder.setNotProgress(spaceTimeInfoService.getSailingProgress(spaceTimeInfo));
        builder.setEndTime(spaceTimeInfoService.getSailingEndTime(spaceTimeInfo));
        builder.setShopEndTime(spaceTimeInfo.getShopEndTime());
        spaceTimeInfo.getShopItems().forEach((key, value) -> {
            SpaceTimeAdventureGMsg.PSShopItemData.Builder item = SpaceTimeAdventureGMsg.PSShopItemData.newBuilder();
            item.setIdx(key);
            item.setBuyNum(value);
            builder.addShopList(item);
        });
        builder.setSpeedBuff(spaceTimeInfo.getSpeedBuff() > 0 ? 1 : 0);
        contextManager.write(role.getId(), CmdCode._74120, builder.build());

    }

    @GMCommand(command = GMCmdCode.SPACE_TIME_UNLOCK_EVENT)
    public void unlock(Role role, List<String> param) {
        int eventId = Integer.parseInt(param.get(0));

        SpaceTimeInfo spaceTimeInfo = spaceTimeInfoService.getInfo(role.getId());
        if (!spaceTimeInfo.getUnlockEvent().contains(eventId)) {
            spaceTimeInfo.getUnlockEvent().add(eventId);
            spaceTimeInfoService.update(spaceTimeInfo);
            eventBus.post(SailingExploreEvent.of(role.getId(), spaceTimeInfo.getRouteId(), eventId));
        }
    }

    @GMCommand(command = GMCmdCode.SPACE_TIME_ADD_BACKPACK)
    public void addBackpack(Role role, List<String> param) {
        List<ImmutableThing> rewardList = new ArrayList<>();
        rewardList.add(ImmutableThing.of(900601, 10));
        rewardList.add(ImmutableThing.of(900702, 10));
        rewardList.add(ImmutableThing.of(900801, 1120));
        rewardList.add(ImmutableThing.of(901401, 9001));
        rewardList.add(ImmutableThing.of(901401, 9001));
        rewardList.add(ImmutableThing.of(901401, 9001));
        rewardList.add(ImmutableThing.of(960001, 1));
        rewardList.add(ImmutableThing.of(960002, 2));
        SpaceTimeInfo spaceTimeInfo = spaceTimeInfoService.getInfo(role.getId());
        spaceTimeInfoService.addItem(spaceTimeInfo, rewardList, GameEvent.GM);
    }

    @GMCommand(command = GMCmdCode.SPACE_TIME_NEXT_EVENT)
    public void nextEvent(Role role, List<String> param) {
        int eventId = Integer.parseInt(param.get(0));
        SpaceTimeInfo spaceTimeInfo = spaceTimeInfoService.getInfo(role.getId());
        if (eventId == FleetEventType.YIN_CANG_HANG_XIAN.getEventId()) {
            spaceTimeInfo.getUnlockRoutes().clear();
            spaceTimeInfoService.update(spaceTimeInfo);
        }
        Asserts.isTrue(spaceTimeInfo.getRouteId() > 0, ErrorCode.SPACE_TIME_NOT_SAILING.getValue(), "当前航队未航行");
        //获取航线事件
        List<Integer> eventList = spaceTimeEventShowSysCache.getMap(spaceTimeInfo.getRouteId()).stream().filter(config -> {
            //若有隐藏航线事件，则检查当前航线所有的隐藏隐线是否已解锁
            if (config.getEvent_id() == FleetEventType.YIN_CANG_HANG_XIAN.getEventId()) {
                return spaceTimeInfoService.containsRoute(spaceTimeInfo, config);
            } else if (config.getEvent_id() == FleetEventType.TU_ZHU_SHANG_REN.getEventId()) {
                return spaceTimeInfo.getShopEndTime() == 0 || spaceTimeInfo.getShopEndTime() < DateTimeUtil.currentSecond();
            } else {
                return true;
            }
        }).map(CSpaceTimeEventShow::getEvent_id).collect(Collectors.toList());

        Asserts.isTrue(eventList.contains(eventId), ErrorCode.SPACE_TIME_FLEET_EVENT_NOT_EXISTS.getValue(),
                String.format("当前航线不存在该事件{%s}", eventId));
        spaceTimeInfo.setNextEvent(eventId);
        spaceTimeInfoService.update(spaceTimeInfo);
    }

    @GMCommand(command = GMCmdCode.SPACE_TIME_CLEAN_ROUTE)
    public void cleanRoute(Role role, List<String> param) {
        SpaceTimeInfo spaceTimeInfo = spaceTimeInfoService.getInfo(role.getId());
        spaceTimeInfo.getUnlockRoutes().clear();
        spaceTimeInfoService.update(spaceTimeInfo);
    }

    @GMCommand(command = GMCmdCode.SPACE_TIME_ADD_EXP)
    public void addExp(Role role, List<String> param) {
        long exp = Long.parseLong(param.get(0));
        spaceTimeInfoService.addExp(role.getId(), exp);
    }
    
}
