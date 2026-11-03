/**
 *
 */
package com.ayjs.mxzg.gameserver.module.adven.handler;

import com.ayjs.mxzg.battle.command.BattleCommand;
import com.ayjs.mxzg.battle.model.BattleResult;
import com.ayjs.mxzg.battle.model.BattleType;
import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.Faction;
import com.ayjs.mxzg.battle.model.UnitType;
import com.ayjs.mxzg.battle.model.mirror.BattlerVo;
import com.ayjs.mxzg.battle.model.mirror.HeroVo;
import com.ayjs.mxzg.common.base.SpringProxy;
import com.ayjs.mxzg.common.command.serivce.CommandBus;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.GJsonUtils;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.AdventurerewardSysCache;
import com.ayjs.mxzg.config.excel.cache.SystemSysCache;
import com.ayjs.mxzg.config.excel.entity.CAdventurereward;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.config.struct.ItemType;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.adven.domain.AdvenMission;
import com.ayjs.mxzg.gameserver.module.adven.domain.AdvenMissionData;
import com.ayjs.mxzg.gameserver.module.adven.event.AdvenBoxEvent;
import com.ayjs.mxzg.gameserver.module.adven.event.AdvenPassEvent;
import com.ayjs.mxzg.gameserver.module.adven.service.AdvenMissionService;
import com.ayjs.mxzg.gameserver.module.adven.struct.AdvenSelectAssist;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.Rewards;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.friend.domain.Relationship;
import com.ayjs.mxzg.gameserver.module.friend.service.RelationshipService;
import com.ayjs.mxzg.gameserver.module.hero.command.QueryHeroCommand;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion027AdventureService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.gameserver.module.role.constant.EntryType;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.module.battle.BattleTemplate;
import com.ayjs.mxzg.protocol.AdvenGMsg;
import com.ayjs.mxzg.protocol.AdvenGMsg.GReqTrialBox;
import com.ayjs.mxzg.protocol.AdvenGMsg.GReqTrialCfg;
import com.ayjs.mxzg.protocol.AdvenGMsg.GReqTrialPass;
import com.ayjs.mxzg.protocol.AdvenGMsg.GResTrialBox;
import com.ayjs.mxzg.protocol.AdvenGMsg.GResTrialCfg;
import com.ayjs.mxzg.protocol.AdvenGMsg.GResTrialPass;
import com.ayjs.mxzg.template.constant.ErrorCode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;

/**
 * @author YY
 *
 */
@Controller
public class AdvenHandler extends ProtocolHandler {

    @Autowired
    private RoleService roleService;
    @Autowired
    private AdvenMissionService advenMissionService;
    @Autowired
    private AdventurerewardSysCache adventurerewardSysCache;
    @Autowired
    private ThingService thingService;
    @Autowired
    private PromotionControlService promotionControlService;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private CommandBus commandBus;
    @Autowired
    private HeroService heroService;
    @Autowired
    private RelationshipService relationshipService;
    @Autowired
    private SystemSysCache systemSysCache;
    @Autowired
    private BattleTemplate battleTemplate;


    /**
     * 获取试炼初始关卡
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._16000)
    public void getAdvenStartMission(PlayerContext playerContext, GReqTrialCfg msg) {
        //查询试炼之路活动是否开启
        boolean promotionRunning = promotionControlService.isPromotionRunning(PromotionType.SHI_LIAN_ZHI_LU);

        // 如果试炼活动开启则先尝试刷新一下数据，避免刚好转点时数据未重置
        if(promotionRunning){
            Promotion027AdventureService promotion027AdventureService = SpringProxy.getBean(Promotion027AdventureService.class);
            promotion027AdventureService.getPromotionInfo(playerContext.getId());
        }

        AdvenMission advenMission = advenMissionService.getAdvenMission(playerContext.getId());

        GResTrialCfg.Builder builder = GResTrialCfg.newBuilder();

        if (TimeDateUtil.isToday(advenMission.getLvTime())) {//今天选择关卡难度之后，推送对战数据
            for (Map.Entry<Integer, AdvenMissionData> missionDataEntry : advenMission.getMissionData().entrySet()) {
                builder.addData(advenMissionService.toGResTrialData(missionDataEntry.getValue(), advenMission.getLv()));
            }

            for (Map.Entry<Long, Long> entry : advenMission.getHeroHpRecord().entrySet()) {
                builder.addHeroHp(
                        AdvenGMsg.GResTrialHeroHpData.newBuilder().setHeroId(entry.getKey()).setHp(entry.getValue()));
            }
        }

        builder.setLevel(advenMission.getLv());
        builder.setTodaySelect(TimeDateUtil.isToday(advenMission.getLvTime()));
        builder.addAllReward(PbUtil.buildReward(advenMission.getRewards()));
        int canChallengeLv = advenMission.getPassLv() + 1;
        Role role = roleService.getOrThrow(playerContext.getId());
        while (canChallengeLv > 0) {
            int fightPowerLimit = advenMissionService.getFightPowerLimit(canChallengeLv);
            if (fightPowerLimit <= role.getMaxFighting()) {
                builder.setPassLv(canChallengeLv);
                break;
            }
            canChallengeLv--;
        }

        playerContext.write(CmdCode._16000, builder.build());
    }

    /**
     * 勇气试炼挑战
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._16001, entry = EntryType.MAIN_PROVING_LANG)
    public void trialPass(PlayerContext playerContext, GReqTrialPass msg) {

        Role role = roleService.getOrThrow(playerContext.getId());

        int missionId = msg.getMissionId();
        AdvenMission advenMission = advenMissionService.getAdvenMission(role.getId());

        Asserts.isTrue(advenMission.getMissionId() == missionId, ErrorCode.ADVEN_CAN_NOT_BATTLE.getValue(),
                () -> String.format("current mission id:%s req idx:%s", advenMission.getMissionId(), missionId));

        Asserts.isTrue(TimeDateUtil.isToday(advenMission.getLvTime()), ErrorCode.ADVEN_CAN_NOT_BATTLE.getValue(),
                () -> String.format("未选择关卡{%s}", advenMission.getLvTime()));

        CAdventurereward cAdventurereward = adventurerewardSysCache.getConfigByMissionIdAndLv(missionId, advenMission.getLv());

        Asserts.isTrue(cAdventurereward.getType() == 1, ErrorCode.ADVEN_REWARD_STAGE.getValue(),
                () -> String.format("current mission id:%s", advenMission.getMissionId()));

        Map<Integer, AdvenMissionData> missionDataMap = advenMission.getMissionData();
        AdvenMissionData missionData = missionDataMap.get(advenMission.getMissionId());

        Asserts.isTrue(missionData.getState() == 0, ErrorCode.ADVEN_COMPLETED.getValue(),
                () -> String.format("mission completed id:%s", advenMission.getMissionId()));

        GResTrialPass.Builder builder = GResTrialPass.newBuilder();

        Map<Long, Long> heroHpMap = advenMission.getHeroHpRecord();
        BattlerVo defBattlerVo = missionData.getBattlerVo();

        // 调用战斗方法
//        BattlerDo battlerDo = battleHelper.queryPlayerBattler(LineUpType.ADVEN, playerContext.getId(), Faction.ATTACKER);
        BattlerVo battlerVo = advenMissionService.createPlayerVo(playerContext.getId());
        battlerVo.getHeros().forEach(heroVo -> {
            if (heroHpMap.containsKey(heroVo.getId())) {
                heroVo.getAttributes().put(AttributeType.HP.getValue(), Math.max(0, heroHpMap.get(heroVo.getId())));
            }
        });
        BattlerDo attacker = battleTemplate.queryBattler(battlerVo, role.getNick(), Faction.ATTACKER, UnitType.HERO);

        BattlerDo defender = battleTemplate.queryBattler(defBattlerVo, missionData.getDefNick(), Faction.DEFENDER, UnitType.MOSTER);

        BattleCommand battleCommand = BattleCommand.createOf(BattleType.TRIAL, attacker, defender);
        commandBus.invoke(battleCommand);

        BattleResult battleResult = battleCommand.getResult();


        missionData.setBattlerVo(battleResult.buildDefenderVo());
        List<HeroVo> attackHeros = battleResult.buildAttackerVo().getHeros();
        for (HeroVo attackerHeroDo : attackHeros) {
            heroHpMap.put(attackerHeroDo.getId(), Math.max(0, attackerHeroDo.getHp()));
        }


        if (!battleResult.isWin()) {
            // 失败退出
            advenMissionService.updateAdvenMission(advenMission);
        } else {
            // 成功
            missionData.setState((byte) 1);

            // 计算下一关
            int newMissionId = adventurerewardSysCache.getNextBattleCAdventurereward(cAdventurereward).getMission();
            advenMission.setMissionId(newMissionId);
            if (newMissionId > missionId) {
                advenMissionService.matchDefender(advenMission, advenMission.getMissionId());
            } else {
                advenMission.setPassLv(Math.max(cAdventurereward.getLevel(), advenMission.getPassLv()));
            }
            advenMissionService.updateAdvenMission(advenMission);

            // 计算奖励
            //查询试炼之路活动是否开启
            boolean promotionRunning = promotionControlService.isPromotionRunning(PromotionType.SHI_LIAN_ZHI_LU);

            List<ImmutableThing> rewardList = cAdventurereward.getReward();

            List<ImmutableThing> resultList = new ArrayList<>(rewardList);
            if (promotionRunning) {
                for (ImmutableThing reward : rewardList) {
                    if (reward.getItem_type() == ItemType.IT_ADVEN_POINT) {
                        //奖励内容为试炼之血，活动开启时增加10%
                        long addNumber = Math.max(1, reward.getItem_num() * 10 / 100);
                        resultList.add(ImmutableThing.of(reward.getItem_type(), addNumber));
                    }
                }
            }
            ImmutableThingUtil.mergeThing(resultList);
            Rewards gotRewards = thingService.add(role.getId(), resultList, GameEvent.ADVEN_REWARD, NoticeType.SLIENT);
            advenMission.getRewards().addAll(resultList);
            advenMission.setRewards(ImmutableThingUtil.mergeThing(advenMission.getRewards()));

            builder.addAllItems(PbUtil.buildReward(gotRewards));
        }
        builder.setMissionId(advenMission.getMissionId());
        builder.setReport(battleResult.getReport());
        playerContext.write(CmdCode._16001, builder.build());

        eventBus.post(AdvenPassEvent.of(role.getId(), cAdventurereward.getIdx(), battleResult.isWin(), cAdventurereward.getShow_mission()));
    }

    @CMD(id = CmdCode._16002)
    public void getAdvenBox(PlayerContext playerContext, GReqTrialBox msg) {
        Role role = roleService.getOrThrow(playerContext.getId());
        AdvenMission advenMission = advenMissionService.getAdvenMission(playerContext.getId());

        int rewardMissionId = msg.getMissionId();

        Asserts.isTrue(rewardMissionId > 0, ErrorCode.ADVEN_CAN_NOT_REWARD.getValue(),
                () -> String.format("advenMission MissionId:%s msg idx:%s", advenMission.getMissionId(), rewardMissionId));

        Map<Integer, AdvenMissionData> missionDataMap = advenMission.getMissionData();
        AdvenMissionData advenMissionData = missionDataMap.get(rewardMissionId);
        // 上一关
        AdvenMissionData preAdvenMissionData = missionDataMap.get(rewardMissionId - 1);

        // 上一关已经通关
        Asserts.isTrue(preAdvenMissionData != null && preAdvenMissionData.getState() == 1,
                ErrorCode.ADVEN_CAN_NOT_REWARD.getValue(),
                () -> String.format("advenMission MissionId:%s msg idx:%s", advenMission.getMissionId(), rewardMissionId));
        CAdventurereward cAdventurereward = adventurerewardSysCache.getConfigByMissionIdAndLv(rewardMissionId, advenMission.getLv());
        // 只能领奖宝箱关卡
        Asserts.isTrue(cAdventurereward.getType() == 2, ErrorCode.ADVEN_CAN_NOT_REWARD.getValue(),
                () -> String.format("msg idx:%s", rewardMissionId));

        Set<Integer> receiveList = advenMission.getReceivedMissionId();
        Asserts.isTrue(!receiveList.contains(rewardMissionId), ErrorCode.ADVEN_REWARD_RECEIVED.getValue(),
                () -> String.format("msg idx:%s,receive:%s", rewardMissionId, GJsonUtils.toJson(receiveList)));

        receiveList.add(rewardMissionId);

        if (Objects.isNull(advenMissionData)) {
            advenMissionData = new AdvenMissionData();
            advenMissionData.setMissionId(rewardMissionId);
            missionDataMap.put(advenMissionData.getMissionId(), advenMissionData);
        }
        advenMissionData.setState((byte) 1);
        advenMission.getRewards().addAll(cAdventurereward.getReward());
        advenMission.setRewards(ImmutableThingUtil.mergeThing(advenMission.getRewards()));
        advenMissionService.updateAdvenMission(advenMission);

        thingService.add(role.getId(), cAdventurereward.getReward(), GameEvent.ADVEN_REWARD);

        GResTrialBox.Builder builder = GResTrialBox.newBuilder();
        builder.setMissionId(rewardMissionId);
        builder.setStatus(advenMissionData.getState());
        playerContext.write(CmdCode._16002, builder.build());

        eventBus.post(AdvenBoxEvent.of(playerContext.getId()));
    }

    @CMD(id = CmdCode._16010)
    public void sendPointState(PlayerContext playerContext, AdvenGMsg.GReqRedState req) {
        AdvenMission advenMission = advenMissionService.getAdvenMission(playerContext.getId(), false);
        int redState = 0;
        if (advenMission == null || TimeDateUtil.isToday(advenMission.getNextResetTime())) {
            redState = 1;
        } else {
            //判定是否有奖励未领取
            boolean hadReward = adventurerewardSysCache.getLvConfigs(advenMission.getLv()).stream().anyMatch(config -> config.getType() == 2 &&
                    !advenMission.getReceivedMissionId().contains(config.getMission()) &&
                    advenMission.getMissionId() >= config.getMission());
            redState = hadReward ? 1 : 0;
        }
        AdvenGMsg.GResRedState.Builder builder = AdvenGMsg.GResRedState.newBuilder();
        builder.setRedState(redState);
        playerContext.write(CmdCode._16010, builder.build());
    }

    /***
     * 好友助战列表
     * @param playerContext
     * @param req
     */
    @CMD(id = CmdCode._16011)
    public void friendAssistList(PlayerContext playerContext, AdvenGMsg.GReqAdvenAssistHeroList req) {
        long rid = playerContext.getId();
        List<Long> friendIds = new ArrayList<>(relationshipService.getShipMap(rid).keySet());

        AdvenGMsg.GResAdvenAssistHeroList.Builder builder = AdvenGMsg.GResAdvenAssistHeroList.newBuilder();
        //派出助战英雄
        AdvenMission advenMission = advenMissionService.getAdvenMission(rid);
        if (advenMission.getAssistHeros().size() > 0) {
            advenMission.getAssistHeros().forEach(assist -> builder.addHeroData(heroService.serialize(assist)));
        }

        //选择的好友英雄
        advenMission.getSelectAssists().forEach(selectAssist -> {
            AdvenGMsg.PSAdvenAssistData.Builder assistData = AdvenGMsg.PSAdvenAssistData.newBuilder();
            Role friend = roleService.getOrThrow(selectAssist.getOwnerId());
            assistData.setFriendId(friend.getId());
            assistData.setFriendNick(friend.getNick());
            assistData.setHadBattle(selectAssist.isHadBattle());
            assistData.setHero(heroService.serialize(selectAssist.getHeroVo()));
            builder.addFriendHero(assistData);
        });

        //好友助战列表
        for (Long friendId : friendIds) {
            AdvenMission friendAdvenMission = advenMissionService.getAdvenMission(friendId);
            if (friendAdvenMission.getAssistHeros().size() > 0) {
                friendAdvenMission.getAssistHeros().forEach(assist -> {
                    Role friend = roleService.getOrThrow(friendId);
                    AdvenGMsg.PSAdvenAssistData.Builder friendAssistBuilder = AdvenGMsg.PSAdvenAssistData.newBuilder();
                    friendAssistBuilder.setFriendId(friend.getId());
                    friendAssistBuilder.setFriendNick(friend.getNick());
                    AdvenSelectAssist collect = advenMission.getSelectAssists().stream().filter(selectAssist ->
                            selectAssist.getOwnerId() == friendId && selectAssist.getHeroVo().getId() == assist.getId())
                            .findFirst().orElse(null);
                    if (collect != null) {
                        friendAssistBuilder.setHadBattle(collect.isHadBattle());
                    }

                    friendAssistBuilder.setHero(heroService.serialize(assist));
                    builder.addAssistData(friendAssistBuilder);
                });
            }
        }

        playerContext.write(CmdCode._16011, builder.build());
    }

    /**
     * 派遣助战英雄
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._16012)
    public void assist(PlayerContext playerContext, AdvenGMsg.GReqAdvenAssist msg) {

        AdvenMission advenMission = advenMissionService.getAdvenMission(playerContext.getId());
        Asserts.isTrue(advenMission.getAssistHeros().size() < systemSysCache.getAdventureAssistNum(),
                ErrorCode.ADVEN_ASSIST_HAD_BATTLE.getValue(), "助战英雄已派遣，不可更替。");

        long rid = playerContext.getId();
        long heroId = msg.getHeroId();
        Hero hero = heroService.getHero(rid, heroId);
        Asserts.notNull(hero, ErrorCode.ADVEN_ASSIST_HAD_BATTLE.getValue(), String.format("助战英雄不存在！{%s}", heroId));

        //创建英雄Vo
        QueryHeroCommand command = QueryHeroCommand.createOf(hero);
        commandBus.invoke(command);
        HeroVo heroVo = HeroVo.valueOf(command.getHeroDo());

        advenMission.getAssistHeros().add(heroVo);
        advenMissionService.updateAdvenMission(advenMission);

        AdvenGMsg.GResAdvenAssist.Builder builder = AdvenGMsg.GResAdvenAssist.newBuilder();
        builder.setHero(heroService.buildHero(hero));

        playerContext.write(CmdCode._16012, builder.build());
    }


    /***
     * 选择英雄助战
     * @param playerContext
     * @param req
     */
    @CMD(id = CmdCode._16013)
    public void selectAssist(PlayerContext playerContext, AdvenGMsg.GReqAdvenSelect req) {

        Relationship relationship = relationshipService.getRelationship(playerContext.getId(), req.getFriendId());
        Asserts.notNull(relationship, ErrorCode.FRIEND_SHIP_MISS.getValue(), "非好友");
        AdvenMission advenMission = advenMissionService.getAdvenMission(playerContext.getId());

        AdvenSelectAssist advenSelectAssist = advenMission.getSelectAssists().stream().filter(
                advenSelectAssistTemp -> advenSelectAssistTemp.getHeroVo().getId() == req.getHeroId()).findFirst().orElse(null);

        if (req.getSelect()) {

            Asserts.isNull(advenSelectAssist, ErrorCode.FRIEND_NOT_ASSIST.getValue(), String.format("英雄已上阵{%s}-{%s}", req.getHeroId(), req.getFriendId()));

            AdvenMission friendAdvenMission = advenMissionService.getAdvenMission(req.getFriendId());
            Asserts.isTrue(friendAdvenMission.getAssistHeros().size() > 0, ErrorCode.FRIEND_NOT_ASSIST.getValue(), "好友无助战英雄！");

            HeroVo heroVo = friendAdvenMission.getAssistHeros().stream().filter(assist -> assist.getId() == req.getHeroId()).findFirst().orElse(null);
            Asserts.notNull(heroVo, ErrorCode.FRIEND_NOT_ASSIST.getValue(), String.format("好友无助战英雄！{%s}-{%s}", req.getHeroId(), req.getFriendId()));

            List<Hero> heros = heroService.getHeros(playerContext.getId());
            Hero hero = heros.stream().max(Comparator.comparingLong(Hero::getFighting)).orElse(null);

            Asserts.notNull(hero, ErrorCode.FRIEND_HERO_HIGH.getValue(), "战力过高{0}");
            int helpFight = heroService.computeStrength(heroVo);
            int maxFight = hero.getFighting();
            Asserts.isTrue(helpFight < maxFight *
                            (systemSysCache.getAdventureAssistScoreLimit() / 10000.0f)
                    , ErrorCode.FRIEND_HERO_HIGH.getValue(), String.format("战力过高{%s}，最高战力{%s}", helpFight, maxFight));

            advenSelectAssist = new AdvenSelectAssist();
            advenSelectAssist.setHeroVo(heroVo);
            advenSelectAssist.setOwnerId(friendAdvenMission.getRid());
            advenMission.getSelectAssists().add(advenSelectAssist);
            advenMissionService.updateAdvenMission(advenMission);

        } else {//取消选择

            Asserts.notNull(advenSelectAssist, ErrorCode.FRIEND_NOT_ASSIST.getValue(), String.format("英雄未上阵{%s}", req.getHeroId()));

            Asserts.isTrue(!advenSelectAssist.isHadBattle(), ErrorCode.ADVEN_ASSIST_HAD_BATTLE.getValue(),
                    String.format("英雄已上阵{%s}", advenSelectAssist.isHadBattle()));

            advenMission.getSelectAssists().remove(advenSelectAssist);
            advenMissionService.updateAdvenMission(advenMission);
        }

        AdvenGMsg.GResAdvenSelect.Builder builder = AdvenGMsg.GResAdvenSelect.newBuilder();
        AdvenGMsg.PSAdvenAssistData.Builder assistData = AdvenGMsg.PSAdvenAssistData.newBuilder();
        Role friend = roleService.getOrThrow(advenSelectAssist.getOwnerId());
        assistData.setFriendId(friend.getId());
        assistData.setFriendNick(friend.getNick());
        assistData.setHadBattle(advenSelectAssist.isHadBattle());
        assistData.setHero(heroService.serialize(advenSelectAssist.getHeroVo()));
        builder.setSelect(req.getSelect());
        builder.setHero(assistData);

        playerContext.write(CmdCode._16013, builder.build());
    }


    /**
     * 选择难度
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._16014)
    public void selectLv(PlayerContext playerContext, AdvenGMsg.GResAdvenSelectLv msg) {

        AdvenMission advenMission = advenMissionService.getAdvenMission(playerContext.getId(), false);
        Asserts.isTrue(!TimeDateUtil.isToday(advenMission.getLvTime()), ErrorCode.ADVEN_ASSIST_HAD_SELECT_LV.getValue(),
                String.format("已经选择了难度{%s}", advenMission.getLvTime()));
        Asserts.isTrue(advenMission.getPassLv() + 1 >= msg.getLv(), ErrorCode.ADVEN_PASS_LV_LOW.getValue(),
                String.format("当前已通关难度{%s}-{%s}", advenMission.getPassLv(), msg.getLv()));
        Role role = roleService.getOrThrow(playerContext.getId());
        Asserts.isTrue(role.getMaxFighting() >= advenMissionService.getFightPowerLimit(msg.getLv()), ErrorCode.DAILY_MISSION_FIGHTING_NOT_ENOUGH.getValue(),
                String.format("战力不足{%s}-{%s}", role.getMaxFighting(), systemSysCache.getAdventureSecondLevelNeedScore()));

        advenMission.setLastLv(advenMission.getLv());
        advenMission.setLastLvTime(advenMission.getLvTime());
        advenMission.setLv(msg.getLv());
        advenMission.setLvTime(TimeDateUtil.getCurrentTimeInt());
        advenMissionService.updateAdvenMission(advenMission);

        AdvenGMsg.GResAdvenSelectLv.Builder builder = AdvenGMsg.GResAdvenSelectLv.newBuilder();
        builder.setLv(msg.getLv());
        playerContext.write(CmdCode._16014, builder.build());
    }
}
