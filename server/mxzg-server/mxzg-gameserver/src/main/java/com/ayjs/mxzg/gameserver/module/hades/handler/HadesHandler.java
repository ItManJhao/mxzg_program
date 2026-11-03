package com.ayjs.mxzg.gameserver.module.hades.handler;

import com.ayjs.mxzg.battle.model.BattleResult;
import com.ayjs.mxzg.battle.model.BattleType;
import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.Faction;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.gson.GsonUtils;
import com.ayjs.mxzg.config.excel.cache.LanguageSysCache;
import com.ayjs.mxzg.config.excel.cache.hades.HadesBuyCountSysCache;
import com.ayjs.mxzg.config.excel.cache.hades.HadesFloorSysCache;
import com.ayjs.mxzg.config.excel.cache.hades.HadesMonsterSysCache;
import com.ayjs.mxzg.config.excel.entity.hades.CHadesBuyCount;
import com.ayjs.mxzg.config.excel.entity.hades.CHadesFloor;
import com.ayjs.mxzg.config.excel.entity.hades.CHadesMonster;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.config.struct.LineUpType;
import com.ayjs.mxzg.gameserver.infrastructure.gm.GMCommand;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.GMCmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.battle.BattleHelper;
import com.ayjs.mxzg.gameserver.module.hades.converter.HadesPBBuilder;
import com.ayjs.mxzg.gameserver.module.hades.domain.Hades;
import com.ayjs.mxzg.gameserver.module.hades.service.AbstractHadesRankService;
import com.ayjs.mxzg.gameserver.module.hades.service.HadesService;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroLineUpService;
import com.ayjs.mxzg.gameserver.module.rank.constant.RankType;
import com.ayjs.mxzg.gameserver.module.rank.service.RankServiceProxy;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.message.module.hades.message.HadesChallengeReqMessage;
import com.ayjs.mxzg.protocol.HadesGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.ayjs.mxzg.template.language.LanguageHelper;
import com.ayjs.rpc.dispatcher.MessageDispatcher;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2021/1/5
 **/
@Component
public class HadesHandler extends ProtocolHandler {

    @Autowired
    private HadesService hadesService;
    @Autowired
    private HadesPBBuilder hadesPBBuilder;
    @Autowired
    private ThingService thingService;
    @Autowired
    private HadesFloorSysCache hadesFloorSysCache;
    @Autowired
    private HadesMonsterSysCache hadesMonsterSysCache;
    @Autowired
    private BattleHelper battleHelper;
    @Autowired
    private LanguageHelper languageHelper;
    @Autowired
    private LanguageSysCache languageSysCache;
    @Autowired
    private HadesBuyCountSysCache hadesBuyCountSysCache;
    @Autowired
    private RankServiceProxy rankServiceProxy;
    @Autowired
    private HeroLineUpService heroLineUpService;
    @Autowired
    private MessageDispatcher messageDispatcher;

    @CMD(id = CmdCode._76181)
    public void getInfo(PlayerContext playerContext, HadesGMsg.GReqHadesInfo req) {
        Hades hades = hadesService.get(playerContext.getId());
        playerContext.write(CmdCode._76181, hadesPBBuilder.builderInfo(hades, req.getType()));
    }

    @CMD(id = CmdCode._76182)
    public void battle(PlayerContext playerContext, HadesGMsg.GReqHadesChallenge req) {
        Hades hades = hadesService.get(playerContext.getId());
        int currFloor = hades.getFloorByType(req.getType().getNumber());
        CHadesFloor challengeFloorConfig = hadesFloorSysCache.getByTypeAndFloor(req.getType().getNumber(), currFloor);
        Asserts.isTrue(challengeFloorConfig != null,
                ErrorCode.HADES_FLOOR_NOT_EXIST.getValue(),
                String.format("层数{%s}不存在", currFloor + 1));

        Asserts.isTrue(thingService.enough(playerContext.getId(), challengeFloorConfig.getCost()),
                ErrorCode.ITEM_NUM_LOW.getValue(),
                String.format("道具{%s}不足", GsonUtils.toJson(challengeFloorConfig.getCost())));

        List<CHadesMonster> monsters = hadesMonsterSysCache.getByFloor(challengeFloorConfig.getIdx());

        Asserts.isTrue(monsters != null && monsters.size() != 0,
                ErrorCode.HADES_FLOOR_MONSTER_NOT_EXIST.getValue(),
                String.format("层数{%s}怪物不存在", currFloor + 1));

        thingService.cost(playerContext.getId(), challengeFloorConfig.getCost(), GameEvent.HADES_CHALLENGE_COST);

        BattlerDo monsterDo = battleHelper.queryNpcBattler(monsters, languageHelper.getLanguageBy(languageSysCache.getByKey(challengeFloorConfig.getBattle_name())));
        BattlerDo playerDo = battleHelper.queryPlayerBattler(BattleType.HADED, playerContext.getId(), Faction.ATTACKER);
        BattleResult battleResult = battleHelper.invokeBattle(BattleType.HADED, playerDo, monsterDo);

        List<ImmutableThing> list = new ArrayList<>();

        if (battleResult.isWin()) {
            hades.putFloor(req.getType().getNumber(), currFloor + 1);
            hadesService.update(hades);
            thingService.add(playerContext.getId(), challengeFloorConfig.getPass_reward(), GameEvent.HADES_CHALLENGE_REWARD, NoticeType.SLIENT);
            list.addAll(challengeFloorConfig.getPass_reward());
            int fighting = heroLineUpService.getLineUpFighting(heroLineUpService.getLineUpByType(playerContext.getId(), LineUpType.HADES));

            messageDispatcher.dispatch(HadesChallengeReqMessage.of(playerContext.getId(), currFloor + 1, req.getType().getNumber(), fighting));
        }
        playerContext.write(CmdCode._76182, hadesPBBuilder.builderChallenge(battleResult, list, req.getType(), hades.getFloorByType(req.getType().getNumber())));
    }

    @CMD(id = CmdCode._76183)
    public void sweep(PlayerContext playerContext, HadesGMsg.GReqHadesSweep req) {
        Hades hades = hadesService.get(playerContext.getId());
        int sweepCount = hades.getSweepCount(req.getType().getNumber());
        int passFloor = hades.getFloorByType(req.getType().getNumber());
        CHadesBuyCount config = hadesBuyCountSysCache.getOrThrow(sweepCount + 1);

        Asserts.isTrue(config != null,
                ErrorCode.HADES_SWEEP_COUNT_MAX.getValue(),
                String.format("次数{%s}上限", sweepCount + 1));

        List<CHadesFloor> sweepFloorConfigs = hadesFloorSysCache.listByType(req.getType().getNumber());

        Asserts.isTrue(sweepFloorConfigs != null,
                ErrorCode.HADES_TYPE_ERROR.getValue(),
                String.format("类型{%s}-{%s}错误", req.getType(), req.getType().getNumber()));

        sweepFloorConfigs = sweepFloorConfigs.stream().filter(cHadesFloor -> cHadesFloor.getFloor() <= passFloor).collect(Collectors.toList());

        Asserts.isTrue(sweepFloorConfigs.size() > 0,
                ErrorCode.HADES_TYPE_ERROR.getValue(),
                String.format("类型{%s}没有层数可以扫荡，当前通关层数{%s}", req.getType(), passFloor));

        if (config.getCost().size() > 0) {
            Asserts.isTrue(thingService.enough(playerContext.getId(), config.getCost()),
                    ErrorCode.ITEM_NUM_LOW.getValue(),
                    String.format("道具{%s}不足", GsonUtils.toJson(config.getCost())));

            thingService.cost(playerContext.getId(), config.getCost(), GameEvent.HADES_SWEEP_COST);
        }

        hades.addSweep(req.getType().getNumber(), 1);
        hadesService.update(hades);

        List<ImmutableThing> sweepRewards = sweepFloorConfigs.stream().map(CHadesFloor::getSweep_reward).flatMap(Collection::stream).collect(Collectors.toList());
        sweepRewards = ImmutableThingUtil.mergeThing(sweepRewards);

        thingService.add(playerContext.getId(), sweepRewards, GameEvent.HADES_SWEEP_REWARD);

        playerContext.write(CmdCode._76183, hadesPBBuilder.builderSweep(req.getType(), hades.getSweepCount(req.getType().getNumber())));
    }

    @CMD(id = CmdCode._76184)
    public void rankList(PlayerContext playerContext, HadesGMsg.GReqHadesRankList req) {
        HadesGMsg.HadesType type = req.getType();
        RankType rankType = hadesService.hadesType2RankType(type);
        AbstractHadesRankService rankService = (AbstractHadesRankService) rankServiceProxy.getRankService(rankType);
        List<HadesGMsg.PSHadesRankData> rankDataList = rankService.showRanks(rankType.getRankCount());
        HadesGMsg.PSHadesRankData selfRank = rankService.selfRank(playerContext.getId());

        HadesGMsg.GResHadesRankList.Builder builder = HadesGMsg.GResHadesRankList.newBuilder();
        builder.addAllRanks(rankDataList);
        builder.setSelf(selfRank);
        builder.setType(req.getType());
        playerContext.write(CmdCode._76184, builder.build());
    }

    @GMCommand(command = GMCmdCode.HADES_RESET_LV)
    public void resetLv(Role role, List<String> param) {
        Hades hades = hadesService.get(role.getId());
        hades.getHadesInfoMap().clear();
        hades.setSweepCount(0);
        hadesService.update(hades);
    }

}
