package com.ayjs.mxzg.gameserver.module.floatingIslands.handler;

import com.ayjs.mxzg.battle.model.BattleResult;
import com.ayjs.mxzg.battle.model.BattleType;
import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.Faction;
import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.exception.ErrorCodeException;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.config.excel.cache.LanguageSysCache;
import com.ayjs.mxzg.config.excel.cache.floatingIslands.FloatingIslandsBuyConsumeSysCache;
import com.ayjs.mxzg.config.excel.cache.floatingIslands.FloatingIslandsHeroSysCache;
import com.ayjs.mxzg.config.excel.constant.FloatingIslandsConst;
import com.ayjs.mxzg.config.excel.entity.floatingIslands.CFloatingIslandsBuyConsume;
import com.ayjs.mxzg.config.excel.entity.floatingIslands.CFloatingIslandsHero;
import com.ayjs.mxzg.config.struct.FloatingIslandsStage;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.constant.ServerConfig;
import com.ayjs.mxzg.gameserver.infrastructure.gm.GMCommand;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.GMCmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.battle.BattleHelper;
import com.ayjs.mxzg.gameserver.module.floatingIslands.domain.RoleFloatingIslands;
import com.ayjs.mxzg.gameserver.module.floatingIslands.service.FloatingIslandsRankService;
import com.ayjs.mxzg.gameserver.module.floatingIslands.service.FloatingIslandsService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.gameserver.remote.large.event.StageCrossConnectEvent;
import com.ayjs.mxzg.message.module.floatingIslands.message.FloatingIslandsChallengeReqMessage;
import com.ayjs.mxzg.message.module.floatingIslands.message.FloatingIslandsChallengeResMessage;
import com.ayjs.mxzg.message.module.floatingIslands.message.FloatingIslandsGMAddDmgMessage;
import com.ayjs.mxzg.message.module.floatingIslands.message.FloatingIslandsGMMessage;
import com.ayjs.mxzg.message.module.floatingIslands.message.FloatingIslandsGetRankMessage;
import com.ayjs.mxzg.message.module.floatingIslands.message.FloatingIslandsGetStateReqMessage;
import com.ayjs.mxzg.message.module.floatingIslands.message.FloatingIslandsGetStateResMessage;
import com.ayjs.mxzg.message.module.floatingIslands.message.FloatingIslandsStartNewMessage;
import com.ayjs.mxzg.message.module.floatingIslands.struct.FloatingIslands;
import com.ayjs.mxzg.message.module.floatingIslands.struct.FloatingIslandsTime;
import com.ayjs.mxzg.protocol.FloatingIslandsGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.ayjs.mxzg.template.language.LanguageHelper;
import com.ayjs.rpc.annotation.RemoteMethod;
import com.ayjs.rpc.dispatcher.MessageDispatcher;
import com.ayjs.rpc.dispatcher.MessageHandler;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2020/6/30
 **/
@Component
@Observer
public class FloatingIslandsHandler extends ProtocolHandler implements MessageHandler {

    @Autowired
    private FloatingIslandsService floatingIslandsService;
    @Autowired
    private FloatingIslandsHeroSysCache floatingIslandsHeroSysCache;
    @Autowired
    private BattleHelper battleHelper;
    @Autowired
    private LanguageHelper languageHelper;
    @Autowired
    private LanguageSysCache languageSysCache;
    @Autowired
    private FloatingIslandsConst floatingIslandsConst;
    @Autowired
    private ThingService thingService;
    @Autowired
    private MessageDispatcher messageDispatcher;
    @Autowired
    private RoleService roleService;
    @Autowired
    private FloatingIslandsRankService floatingIslandsRankService;
    @Autowired
    private FloatingIslandsBuyConsumeSysCache floatingIslandsBuyConsumeSysCache;
    @Autowired
    private ServerConfig serverConfig;

    @CMD(id = CmdCode._73001)
    public void getTime(PlayerContext playerContext, FloatingIslandsGMsg.GReqFloatingIslandsTime req) {
        FloatingIslandsTime time = floatingIslandsService.getTime();
        FloatingIslandsGMsg.GResFloatingIslandsTime.Builder builder = FloatingIslandsGMsg.GResFloatingIslandsTime.newBuilder();
        builder.setStage(time.getStage());
        builder.setNextTime(time.getNextTime());
        playerContext.write(CmdCode._73001, builder.build());
    }

    @CMD(id = CmdCode._73002)
    public void getData(PlayerContext playerContext, FloatingIslandsGMsg.GReqFloatingIslandsData req) {
        RoleFloatingIslands roleFloatingIslands = floatingIslandsService.get(playerContext.getId());
        FloatingIslandsGMsg.GResFloatingIslandsData.Builder builder = FloatingIslandsGMsg.GResFloatingIslandsData.newBuilder();
        FloatingIslands serverDmg = floatingIslandsService.getServerDmg();
        builder.setTotalDmg(serverDmg.getDmg() + "");
        builder.setSelfMaxDmg(roleFloatingIslands.getMaxDmg());
        builder.setCanBuyCount(floatingIslandsBuyConsumeSysCache.getMaxCount() - roleFloatingIslands.getHadBuyCount());
        builder.setChallengeCount(roleFloatingIslands.getChallengeCount());

        FloatingIslandsTime time = floatingIslandsService.getTime();
//        builder.setBossTurns(time.getBossTurns());
        playerContext.write(CmdCode._73002, builder.build());
    }

    @CMD(id = CmdCode._73003)
    public void challenge(PlayerContext playerContext, FloatingIslandsGMsg.GReqFloatingIslandsData req) {
        FloatingIslandsTime islandsTime = floatingIslandsService.getTime();
        RoleFloatingIslands roleFloatingIslands = floatingIslandsService.get(playerContext.getId());

        Asserts.isTrue(islandsTime.getStage() == FloatingIslandsStage.CHALLENGE_BOSS.getCode(),
                ErrorCode.FLOATING_ISLANDS_STAGE_ERROR.getValue(), String.format("阶段错误"));

        Asserts.isTrue(roleFloatingIslands.getChallengeCount() > 0, ErrorCode.FLOATING_ISLANDS_COUNT_LOW.getValue()
                , String.format("次数不足{%s}", roleFloatingIslands.getChallengeCount()));
        Role role = roleService.getOrThrow(playerContext.getId());

        List<CFloatingIslandsHero> configs = floatingIslandsHeroSysCache.getAll()
                .stream().filter(config -> config.getHero_type() > 0).collect(Collectors.toList());
        BattlerDo monsterDo = battleHelper.queryNpcBattler(configs, languageHelper.getLanguageBy(
                languageSysCache.getByKey(floatingIslandsConst.getBattleName())));

        BattlerDo playerDo = battleHelper.queryPlayerBattler(BattleType.FLOATING_ISLANDS, playerContext.getId(), Faction.ATTACKER);

        BattleResult battleResult = battleHelper.invokeBattle(BattleType.FLOATING_ISLANDS, playerDo, monsterDo);
        long totalDamage = battleResult.getTotalDamage(Faction.ATTACKER);
        messageDispatcher.dispatch(FloatingIslandsChallengeReqMessage.of(role.getId(), role.getServerId(), totalDamage), res -> {
            FloatingIslandsChallengeResMessage response = (FloatingIslandsChallengeResMessage) res;
            if (ErrorCode.NO_ERROR.getValue() == response.getCode()) {
                roleFloatingIslands.setChallengeCount(roleFloatingIslands.getChallengeCount() - 1);
                roleFloatingIslands.setTotalDmg(totalDamage + roleFloatingIslands.getTotalDmg());
                if (totalDamage > roleFloatingIslands.getMaxDmg()) {
                    roleFloatingIslands.setMaxDmg(totalDamage);
                }
                floatingIslandsService.update(roleFloatingIslands);

                //更新最大伤害值
                FloatingIslands serverDmg = floatingIslandsService.getServerDmg();
                serverDmg.setDmg(response.getTotalDmg());
                floatingIslandsService.update(serverDmg);

                thingService.add(playerContext.getId(), floatingIslandsConst.getFloatingIslandsChallengeReward(),
                        GameEvent.FLOATING_ISLANDS_CHALLENGE_REWARD, NoticeType.SLIENT);

                FloatingIslandsGMsg.GResFloatingIslandsChallenge.Builder builder = FloatingIslandsGMsg.GResFloatingIslandsChallenge.newBuilder();
                builder.setReport(battleResult.getReport());
                builder.setDmg(battleResult.getTotalDamage(Faction.ATTACKER));
                builder.addAllChallengeReward(PbUtil.buildReward(floatingIslandsConst.getFloatingIslandsChallengeReward()));
                playerContext.write(CmdCode._73003, builder.build());
            } else {
                throw new ErrorCodeException(response.getCode(), "跨服返回失败");
            }
        });
    }

    @CMD(id = CmdCode._73004)
    public void buyCount(PlayerContext playerContext, FloatingIslandsGMsg.GReqFloatingIslandsBuyCount req) {
        RoleFloatingIslands roleFloatingIslands = floatingIslandsService.get(playerContext.getId());

        FloatingIslandsTime islandsTime = floatingIslandsService.getTime();
        Asserts.isTrue(islandsTime.getStage() == FloatingIslandsStage.CHALLENGE_BOSS.getCode(),
                ErrorCode.FLOATING_ISLANDS_STAGE_ERROR.getValue(), String.format("阶段错误{%s}", islandsTime.getStage()));

        Asserts.isTrue(roleFloatingIslands.getHadBuyCount() < floatingIslandsBuyConsumeSysCache.getMaxCount(),
                ErrorCode.FLOATING_ISLANDS_BUY_COUNT_MAX.getValue(), String.format("购买次数{%s}达到上限", roleFloatingIslands.getHadBuyCount()));

        CFloatingIslandsBuyConsume consumeConfig = floatingIslandsBuyConsumeSysCache.getOrThrow(roleFloatingIslands.getHadBuyCount() + 1);
        Asserts.isTrue(thingService.enough(playerContext.getId(), consumeConfig.getConsume()),
                ErrorCode.ITEM_NUM_LOW.getValue(), "道具不足");

        thingService.cost(playerContext.getId(), consumeConfig.getConsume(), GameEvent.FLOATING_ISLANDS_BUY_COUNT_COST);

        roleFloatingIslands.setHadBuyCount(roleFloatingIslands.getHadBuyCount() + 1);
        roleFloatingIslands.setChallengeCount(roleFloatingIslands.getChallengeCount() + 1);
        floatingIslandsService.update(roleFloatingIslands);

        FloatingIslandsGMsg.GResFloatingIslandsBuyCount.Builder builder = FloatingIslandsGMsg.GResFloatingIslandsBuyCount.newBuilder();
        builder.setCanBuyCount(floatingIslandsBuyConsumeSysCache.getMaxCount() - roleFloatingIslands.getHadBuyCount());
        builder.setChallengeCount(roleFloatingIslands.getChallengeCount());
        playerContext.write(CmdCode._73004, builder.build());
    }

    @CMD(id = CmdCode._73005)
    public void getRank(PlayerContext playerContext, FloatingIslandsGMsg.GReqFloatingIslandsRank req) {
        List<FloatingIslandsGMsg.PSFloatingRankData> ranks = floatingIslandsRankService.showRanks(floatingIslandsConst.getShowCount());
        FloatingIslandsGMsg.PSFloatingRankData self = floatingIslandsRankService.selfRank(playerContext.getId());
        FloatingIslandsGMsg.GResFloatingIslandsRank.Builder builder = FloatingIslandsGMsg.GResFloatingIslandsRank.newBuilder();
        builder.addAllRanks(ranks);
        builder.setSelf(self);
        playerContext.write(CmdCode._73005, builder.build());
    }

    @RemoteMethod
    public void updateState(FloatingIslandsGetStateResMessage req) {
        floatingIslandsService.setNewStage(req.getTime());
    }

    @RemoteMethod
    public void updateState(FloatingIslandsStartNewMessage req) {
        floatingIslandsService.clearDmg();
    }

    @GMCommand(command = GMCmdCode.FLOATING_ISLANDS_SET_STATE)
    public void setState(Role role, List<String> param) {
        Integer state = Integer.valueOf(param.get(0));
        messageDispatcher.dispatch(FloatingIslandsGMMessage.of(state.intValue()));
    }


    @GMCommand(command =GMCmdCode.FLOATING_ISLANDS_ADD_COUNT)
    public void addCount(Role role, List<String> param) {
        RoleFloatingIslands floatingIslands = floatingIslandsService.get(role.getId());
        floatingIslands.setChallengeCount(100);
        floatingIslandsService.update(floatingIslands);
    }

    @GMCommand(command = GMCmdCode.FLOATING_ISLANDS_ADD_DMG)
    public void addDmg(Role role, List<String> param) {
        RoleFloatingIslands floatingIslands = floatingIslandsService.get(role.getId());
        messageDispatcher.dispatch(FloatingIslandsGMAddDmgMessage.of(Long.valueOf(param.get(0))));
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(StageCrossConnectEvent event) {
        floatingIslandsService.settleChallengeBoss();
        messageDispatcher.dispatch(new FloatingIslandsGetStateReqMessage());
        messageDispatcher.dispatch(FloatingIslandsGetRankMessage.of(serverConfig.getServerId()));
    }
}
