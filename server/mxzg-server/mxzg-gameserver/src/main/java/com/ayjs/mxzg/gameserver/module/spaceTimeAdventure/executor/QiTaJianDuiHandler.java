package com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.executor;

import com.ayjs.mxzg.battle.model.BattleResult;
import com.ayjs.mxzg.battle.model.BattleType;
import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.Faction;
import com.ayjs.mxzg.battle.model.UnitType;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.config.excel.cache.RewardGroupSysCache;
import com.ayjs.mxzg.config.excel.cache.spaceTime.SpaceTimeEventShowSysCache;
import com.ayjs.mxzg.config.excel.entity.spaceTime.CSpaceTimeEventShow;
import com.ayjs.mxzg.config.struct.FleetSailingStruct;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.LineUpType;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.battle.BattleHelper;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.constant.FleetEventType;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.domain.SpaceTimeInfo;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.service.SpaceTimeInfoService;
import com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.struct.FleetEnemyInfo;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.module.battle.BattleTemplate;
import com.ayjs.mxzg.protocol.ObjectGMsg;
import com.ayjs.mxzg.protocol.SpaceTimeAdventureGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * @author hyx
 */
@Component
public class QiTaJianDuiHandler implements IFleetEventHandler {

    @Autowired
    private SpaceTimeInfoService spaceTimeInfoService;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private SpaceTimeEventShowSysCache spaceTimeEventShowSysCache;
    @Autowired
    private BattleHelper battleHelper;
    @Autowired
    private BattleTemplate battleTemplate;
    @Autowired
    private RewardGroupSysCache rewardGroupSysCache;

    @Override
    public FleetEventType thisType() {
        return FleetEventType.QI_TA_JIAN_DUI;
    }

    @Override
    public void executor(SpaceTimeInfo spaceTimeInfo, int condition) {

        Asserts.isTrue(spaceTimeInfo.getEnemyInfo().getEnemyMap().size() > 0,
                ErrorCode.SPACE_TIME_NOT_ENEMY.getValue(), "尚未匹配到敌人无法挑战");

        FleetEnemyInfo fleetEnemyInfo = spaceTimeInfo.getEnemyInfo();

        BattlerDo atkDo = battleHelper.queryPlayerBattler(LineUpType.valueOf(condition), spaceTimeInfo.getRid(), Faction.ATTACKER);
        BattlerDo defDo = battleTemplate.queryBattler(fleetEnemyInfo.getEnemyMap().get(condition), fleetEnemyInfo.getNick()
                , Faction.DEFENDER, UnitType.HERO);

        BattleResult battleResult = battleHelper.invokeBattle(BattleType.SPACE_TIME_MONSTER, atkDo, defDo);

        CSpaceTimeEventShow cSpaceTimeEventShow = spaceTimeEventShowSysCache.getEventMap(spaceTimeInfo.getRouteId(), thisType().getEventId());

        SpaceTimeAdventureGMsg.GResFleetEventThree.Builder builder = SpaceTimeAdventureGMsg.GResFleetEventThree.newBuilder();
        builder.setReport(battleResult.getReport());
        if (battleResult.isWin()) {
            //获得道具
            List<ImmutableThing> rewardList = rewardGroupSysCache.getRewardGroupThing(cSpaceTimeEventShow.getGroup());
            List<ObjectGMsg.PSBackpackData> builderList = spaceTimeInfoService.addItem(spaceTimeInfo, rewardList, GameEvent.SPACE_TIME_EVENT_REWARD);
            builder.addAllItemList(builderList);
            builder.addAllBuff(spaceTimeInfoService.addBuff(spaceTimeInfo, cSpaceTimeEventShow.getBuff()));
        } else {
            builder.addAllBuff(spaceTimeInfoService.addDebuff(spaceTimeInfo, cSpaceTimeEventShow.getDebuff()));
        }
        spaceTimeInfo.getEnemyInfo().getEnemyMap().clear();
        spaceTimeInfoService.update(spaceTimeInfo);
        builder.setDurability(spaceTimeInfo.getDurability());
        contextManager.write(spaceTimeInfo.getRid(), CmdCode._74134, builder.build());
    }
}
