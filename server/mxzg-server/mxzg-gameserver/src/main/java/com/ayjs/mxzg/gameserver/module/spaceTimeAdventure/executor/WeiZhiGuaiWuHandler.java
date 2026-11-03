package com.ayjs.mxzg.gameserver.module.spaceTimeAdventure.executor;

import com.ayjs.mxzg.battle.model.BattleResult;
import com.ayjs.mxzg.battle.model.BattleType;
import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.Faction;
import com.ayjs.mxzg.battle.model.UnitType;
import com.ayjs.mxzg.common.util.DropUtil;
import com.ayjs.mxzg.config.excel.cache.LanguageSysCache;
import com.ayjs.mxzg.config.excel.cache.RewardGroupSysCache;
import com.ayjs.mxzg.config.excel.cache.spaceTime.SpaceTimeEventShowSysCache;
import com.ayjs.mxzg.config.excel.cache.spaceTime.SpaceTimeMonsterSysCache;
import com.ayjs.mxzg.config.excel.constant.SpaceTimeAdventureConst;
import com.ayjs.mxzg.config.excel.entity.spaceTime.CSpaceTimeEventShow;
import com.ayjs.mxzg.config.excel.entity.spaceTime.CSpaceTimeMonster;
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
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.module.battle.BattleTemplate;
import com.ayjs.mxzg.protocol.ObjectGMsg;
import com.ayjs.mxzg.protocol.SpaceTimeAdventureGMsg;
import com.ayjs.mxzg.template.language.LanguageHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;

/**
 * 舰队残骸(怪物事件)
 *
 * @author hyx
 */
@Component
public class WeiZhiGuaiWuHandler implements IFleetEventHandler {

    @Autowired
    private SpaceTimeInfoService spaceTimeInfoService;
    @Autowired
    private SpaceTimeMonsterSysCache spaceTimeMonsterSysCache;
    @Autowired
    private BattleHelper battleHelper;
    @Autowired
    private BattleTemplate battleTemplate;
    @Autowired
    private LanguageSysCache languageSysCache;
    @Autowired
    private LanguageHelper languageHelper;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private SpaceTimeEventShowSysCache spaceTimeEventShowSysCache;
    @Autowired
    private RewardGroupSysCache rewardGroupSysCache;

    @Override
    public FleetEventType thisType() {
        return FleetEventType.WEI_ZHI_GUAI_WU;
    }

    @Override
    public void executor(SpaceTimeInfo spaceTimeInfo, int condition) {
        List<CSpaceTimeMonster> monsterList = spaceTimeMonsterSysCache.getRoutedMonsters(spaceTimeInfo.getRouteId());

        BattlerDo monsterDo = battleTemplate.queryBattler(monsterList, languageHelper.getLanguageBy(
                languageSysCache.getByKey(SpaceTimeAdventureConst.LANGUAGE)), Faction.DEFENDER, UnitType.MOSTER);
        BattlerDo playerDo = battleHelper.queryPlayerBattler(LineUpType.SPACE_TIME_MONSTER, spaceTimeInfo.getRid(), Faction.ATTACKER);
        BattleResult battleResult = battleHelper.invokeBattle(BattleType.SPACE_TIME_MONSTER, playerDo, monsterDo);

        CSpaceTimeEventShow cSpaceTimeEventShow = spaceTimeEventShowSysCache.getEventMap(spaceTimeInfo.getRouteId(), thisType().getEventId());

        SpaceTimeAdventureGMsg.GResFleetEventTwo.Builder builder = SpaceTimeAdventureGMsg.GResFleetEventTwo.newBuilder();
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
        builder.setDurability(spaceTimeInfo.getDurability());
        contextManager.write(spaceTimeInfo.getRid(), CmdCode._74133, builder.build());
    }
}
