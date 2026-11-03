/**
 *
 */
package com.ayjs.mxzg.gameserver.module.battle.handler;

import com.alibaba.fastjson.JSONObject;
import com.ayjs.mxzg.battle.BattleConstant;
import com.ayjs.mxzg.battle.model.BattleResult;
import com.ayjs.mxzg.battle.model.BattleType;
import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.Faction;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.model.UnitType;
import com.ayjs.mxzg.battle.model.mirror.BattlerVo;
import com.ayjs.mxzg.battle.model.mirror.HeroVo;
import com.ayjs.mxzg.common.command.serivce.CommandBus;
import com.ayjs.mxzg.common.convert.ConvertUtils;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.JsonUtil;
import com.ayjs.mxzg.common.util.MessageUtils;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.BattleMatrixAdditionSysCache;
import com.ayjs.mxzg.config.excel.cache.ChapterExtraRewardSysCache;
import com.ayjs.mxzg.config.excel.cache.ChapterSysCache;
import com.ayjs.mxzg.config.excel.cache.ChapterrewardSysCache;
import com.ayjs.mxzg.config.excel.cache.FirstrewardChapterSysCache;
import com.ayjs.mxzg.config.excel.cache.GuideBattleSysCache;
import com.ayjs.mxzg.config.excel.cache.HeroTypeSysCache;
import com.ayjs.mxzg.config.excel.cache.LanguageSysCache;
import com.ayjs.mxzg.config.excel.cache.SpeedUpCostSysCache;
import com.ayjs.mxzg.config.excel.cache.SystemSysCache;
import com.ayjs.mxzg.config.excel.constant.IdleConst;
import com.ayjs.mxzg.config.excel.entity.CBattleMatrixAddition;
import com.ayjs.mxzg.config.excel.entity.CChapter;
import com.ayjs.mxzg.config.excel.entity.CChapterExtraReward;
import com.ayjs.mxzg.config.excel.entity.CChapterreward;
import com.ayjs.mxzg.config.excel.entity.CFirstrewardChapter;
import com.ayjs.mxzg.config.excel.entity.CGuideBattle;
import com.ayjs.mxzg.config.excel.entity.CLanguage;
import com.ayjs.mxzg.config.excel.entity.CSpeedUpCost;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.HeroInfo;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ItemType;
import com.ayjs.mxzg.config.struct.LineUpType;
import com.ayjs.mxzg.gameserver.infrastructure.constant.ServerConfig;
import com.ayjs.mxzg.gameserver.infrastructure.gm.GMCommand;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.GMCmdCode;
import com.ayjs.mxzg.gameserver.module.adven.service.AdvenMissionService;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.Rewards;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.battle.BattleHelper;
import com.ayjs.mxzg.gameserver.module.battle.constant.MainBattleConstant;
import com.ayjs.mxzg.gameserver.module.battle.domain.Formation;
import com.ayjs.mxzg.gameserver.module.battle.domain.RoleMission;
import com.ayjs.mxzg.gameserver.module.battle.event.ChapterBattleEvent;
import com.ayjs.mxzg.gameserver.module.battle.event.ChapterPassEvent;
import com.ayjs.mxzg.gameserver.module.battle.event.ChapterRewardEvent;
import com.ayjs.mxzg.gameserver.module.battle.event.HeroLineEvent;
import com.ayjs.mxzg.gameserver.module.battle.event.IdleAwardReceiveEvent;
import com.ayjs.mxzg.gameserver.module.battle.service.FormationService;
import com.ayjs.mxzg.gameserver.module.battle.service.RoleMissionService;
import com.ayjs.mxzg.gameserver.module.dreamland.service.DreamlandService;
import com.ayjs.mxzg.gameserver.module.hero.command.QueryHerosCommand;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroLineUp;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroLineUpService;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.hero.struct.HeroPosition;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PrivilegeType;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PrivilegeGift;
import com.ayjs.mxzg.gameserver.module.promotionNew.event.SpeedFightEvent;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion010PrivilegeGiftService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.role.service.RoleVipService;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.gameserver.module.video.constant.VideoType;
import com.ayjs.mxzg.gameserver.module.video.event.VideoRecordEvent;
import com.ayjs.mxzg.message.module.study.ReqBattlerVOMessage;
import com.ayjs.mxzg.message.module.study.ResBattlerVOMessage;
import com.ayjs.mxzg.module.battle.BattleReportManager;
import com.ayjs.mxzg.module.battle.BattleTemplate;
import com.ayjs.mxzg.module.battle.command.SaveBattleReportCommand;
import com.ayjs.mxzg.protocol.BattleGMsg;
import com.ayjs.mxzg.protocol.BattleGMsg.BattleReport;
import com.ayjs.mxzg.protocol.BattleGMsg.GReqBattleMatch;
import com.ayjs.mxzg.protocol.BattleGMsg.GReqBattleReport;
import com.ayjs.mxzg.protocol.BattleGMsg.GReqBattleTest;
import com.ayjs.mxzg.protocol.BattleGMsg.GReqChapterData;
import com.ayjs.mxzg.protocol.BattleGMsg.GReqChapterEnd;
import com.ayjs.mxzg.protocol.BattleGMsg.GReqChapterItemList;
import com.ayjs.mxzg.protocol.BattleGMsg.GReqChapterReport;
import com.ayjs.mxzg.protocol.BattleGMsg.GReqExtraReward;
import com.ayjs.mxzg.protocol.BattleGMsg.GReqLineUp;
import com.ayjs.mxzg.protocol.BattleGMsg.GReqPreComputeStrength;
import com.ayjs.mxzg.protocol.BattleGMsg.GReqStudy;
import com.ayjs.mxzg.protocol.BattleGMsg.GResBattleMatch;
import com.ayjs.mxzg.protocol.BattleGMsg.GResBattleReport;
import com.ayjs.mxzg.protocol.BattleGMsg.GResBattleTest;
import com.ayjs.mxzg.protocol.BattleGMsg.GResChapterData;
import com.ayjs.mxzg.protocol.BattleGMsg.GResChapterFirstReward;
import com.ayjs.mxzg.protocol.BattleGMsg.GResChapterReport;
import com.ayjs.mxzg.protocol.BattleGMsg.GResExtraReward;
import com.ayjs.mxzg.protocol.BattleGMsg.GResLineUp;
import com.ayjs.mxzg.protocol.BattleGMsg.GResLineUpSave;
import com.ayjs.mxzg.protocol.BattleGMsg.GResPreComputeStrength;
import com.ayjs.mxzg.protocol.BattleGMsg.GResQueryFormation;
import com.ayjs.mxzg.protocol.BattleGMsg.GResStudy;
import com.ayjs.mxzg.protocol.BattleGMsg.GResUnlock;
import com.ayjs.mxzg.protocol.BattleGMsg.GResUnlockFormation;
import com.ayjs.mxzg.protocol.BattleGMsg.PSLineUpData;
import com.ayjs.mxzg.protocol.BattleGMsg.PSLineUpHeroData;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.ayjs.mxzg.template.language.LanguageHelper;
import com.ayjs.rpc.dispatcher.MessageDispatcher;
import com.ayjs.rpc.util.ProtostuffUtil;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.Lists;
import com.google.common.collect.Table;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.util.CollectionUtils;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

/**
 * @author YY
 *
 */
@Slf4j
@Controller
public class
BattleHandler extends ProtocolHandler {

    @Value("${server.id}")
    private int serverId;

    @Autowired
    private RoleMissionService roleMissionService;
    @Autowired
    private RoleService roleService;
    @Autowired
    private ChapterrewardSysCache chapterrewardSysCache;
    @Autowired
    private ChapterSysCache chapterSysCache;
    @Autowired
    private SystemSysCache systemSysCache;
    @Autowired
    private ThingService thingService;
    @Autowired
    private HeroLineUpService heroLineUpService;
    @Autowired
    private FirstrewardChapterSysCache firstrewardChapterSysCache;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private BattleHelper battleHelper;
    @Autowired
    private Promotion010PrivilegeGiftService promotion010PrivilegeGiftService;
    @Autowired
    private PromotionControlService promotionControlService;
    @Autowired
    private SpeedUpCostSysCache speedUpCostSysCache;
    @Autowired
    private LanguageSysCache languageSysCache;
    @Autowired
    private LanguageHelper languageHelper;
    @Autowired
    private RoleVipService roleVipService;
    @Autowired
    private ChapterExtraRewardSysCache chapterExtraRewardSysCache;
    @Autowired
    private HeroTypeSysCache heroTypeSysCache;
    @Autowired
    private GuideBattleSysCache guideBattleSysCache;
    @Autowired
    private BattleReportManager reportManager;
    @Autowired
    private HeroService heroService;
    @Autowired
    private CommandBus commandBus;
    @Autowired
    private DreamlandService dreamlandService;
    @Autowired
    private MessageDispatcher messageDispatcher;
    @Autowired
    private ServerConfig serverConfig;
    @Autowired
    private FormationService formationService;
    @Autowired
    private BattleTemplate battleTemplate;
    @Autowired
    private BattleMatrixAdditionSysCache battleMatrixAdditionSysCache;
    @Autowired
    private AdvenMissionService advenMissionService;

    @CMD(id = CmdCode._3000)
    public void battleTest(PlayerContext playerContext, GReqBattleTest msg) {
        long startTime = TimeDateUtil.getCurrentTime();
        BattlerDo attacker = battleHelper.queryPlayerBattler(BattleType.MAIN, playerContext.getId(), Faction.ATTACKER);
        BattlerDo defender = null;
        if (msg.getType() == 1) { // 对打固定配置阵容，对面攻击为1
            List<CGuideBattle> defenderHeros = guideBattleSysCache.getHerosBy(Faction.DEFENDER.ordinal() + 1);
            defender = battleTemplate.queryBattler(defenderHeros, "防守阵营", Faction.DEFENDER, UnitType.HERO);
            defender.setInvincible();
        } else if (msg.getType() == 2) {   // 对打固定配置阵容
            List<CGuideBattle> defenderHeros = guideBattleSysCache.getHerosBy(Faction.DEFENDER.ordinal() + 1);
            defender = battleTemplate.queryBattler(defenderHeros, "防守阵营", Faction.DEFENDER, UnitType.HERO);
        } else if (msg.getType() == 3 || msg.getType() == 4) { // 3一直使用第一个主动技能4一直使用第二个主动技能
            defender = battleHelper.queryPlayerBattler(BattleType.MAIN, playerContext.getId(), Faction.DEFENDER);
            defender.setTestType(msg.getType());
            attacker.setTestType(msg.getType());
        } else if (msg.getType() == 5) {  //打竞技场防守阵容
            defender = battleHelper.queryPlayerBattler(LineUpType.PVP_DEF, playerContext.getId(), Faction.DEFENDER);
        } else if (msg.getType() == 6) {
            defender = battleHelper.queryPlayerBattler(BattleType.MAIN, playerContext.getId(), Faction.DEFENDER);
            defender.setTestType(msg.getType());
            attacker.setTestType(msg.getType());
        } else {    // 打自己
            defender = battleHelper.queryPlayerBattler(BattleType.MAIN, playerContext.getId(), Faction.DEFENDER);
        }

        BattleResult result = battleHelper.invokeBattle(BattleType.MAIN, attacker, defender);
        long endTime = TimeDateUtil.getCurrentTime();


        GResBattleTest.Builder builder = GResBattleTest.newBuilder();
        builder.setReport(result.getReport());
        GResBattleTest test = builder.build();

        log.info("战斗耗时{}ms战报大小{}共{}回合", endTime - startTime, result.getReport().toByteArray().length, result.getReport().getRoundsCount());
        log.info("战报{}", MessageUtils.formatMessage(test, false));

        playerContext.write(CmdCode._3000, test);
    }

    @CMD(id = CmdCode._3001)
    public void challenge(PlayerContext playerContext, GReqBattleMatch msg) {
        Role role = roleService.getOrThrow(playerContext.getId());
        RoleMission roleMission = roleMissionService.getRoleMission(playerContext.getId());
        if (roleMission.isReceiveReward()) {
            missionEnd(playerContext, GReqChapterEnd.getDefaultInstance());
            log.info("玩家有主线奖励未领取ChapterId:{}，自动帮玩家领取！", roleMission.getChapterId());
            return;
        }
        CChapterreward chapterReward = chapterrewardSysCache.getById(roleMission.getChapterId() + 1);
        Asserts.isTrue(!roleMission.isReceiveReward(), ErrorCode.RECEIVE_CUSTOMS_CLEARANCE_REWARDS_FIRST.getValue(), () -> String.format("有通关奖励未领取id:%s", roleMission.getChapterId()));
        Asserts.notNull(chapterReward, ErrorCode.ALREADY_PASSED.getValue(), () -> String.format("已经通关当前关卡id:%s", roleMission.getChapterId()));

        Asserts.isTrue(role.getFighting() >= chapterReward.getCombat_effectiveness(), ErrorCode.INSUFFICIENT_COMBAT_POWER.getValue(),
                () -> String.format("战力:%s不符合要求:%s", role.getFighting(), chapterReward.getCombat_effectiveness()));
        Asserts.isTrue(chapterReward.getLevel() <= role.getLevel(), ErrorCode.ROLE_LEVEL_LOW.getValue(), () -> String.format("角色等级不足"));

        List<CChapter> chapters = chapterSysCache.getChapter(chapterReward.getMission_id(), chapterReward.getMode_id(), chapterReward.getChapter_id());
        Asserts.notEmpty(chapters, ErrorCode.MOSTER_IS_EMPTY.getValue(), () -> String.format("怪物列表为空id:%s", roleMission.getChapterId()));

        CLanguage cLanguage = languageSysCache.getByKey(String.valueOf(MainBattleConstant.LANGUAGE_BASE_ID + chapterReward.getChapter_id()));
        String mosterName = String.format("%s%s", languageHelper.getLanguageBy(cLanguage), chapterReward.getIdx());
        BattleResult result = battleHelper.invokePVEBattle(BattleType.MAIN, playerContext.getId(), chapters, mosterName);

        if (result.isWin()) {
            roleMission.setReceiveReward(true);
            roleMission.setChapterId(chapterReward.getIdx());
            roleMission.setMissionRankTime(TimeDateUtil.getCurrentTimeInt());
            roleMissionService.updateRoleMission(roleMission);
        }

        GResBattleMatch.Builder builder = GResBattleMatch.newBuilder().setReport(result.getReport());
        playerContext.write(CmdCode._3001, builder.build());

        eventBus.post(ChapterBattleEvent.of(playerContext.getId(), chapterReward.getIdx(), role.getFighting(), role.getLevel(), result.isWin()));
    }


    @CMD(id = CmdCode._3002)
    public void missionEnd(PlayerContext playerContext, GReqChapterEnd msg) {
        RoleMission roleMission = roleMissionService.getRoleMission(playerContext.getId());
        if (!roleMission.isReceiveReward()) {
            // 上线客户端会请求一次改接口，没有奖励则忽略
            return;
        }
        roleMission.setReceiveReward(false);
        roleMissionService.updateRoleMission(roleMission);

        CChapterreward cModel = chapterrewardSysCache.getOrThrow(roleMission.getChapterId());

        BattleGMsg.GResChapterEnd.Builder builder = BattleGMsg.GResChapterEnd.newBuilder();
        Rewards rewardList = thingService.add(playerContext.getId(), cModel.getFirst_reward(), GameEvent.CHAPTER_FIRST_REWARD, NoticeType.SLIENT);
        for (ImmutableThing reward : rewardList.getThingSet().asList()) {
            builder.addList(PbUtil.buildReward(reward));
        }
        builder.setIdx(roleMission.getChapterId());
        playerContext.write(CmdCode._3002, builder.build());
        eventBus.post(ChapterPassEvent.of(playerContext.getId(), roleMission.getChapterId()));
    }

    @CMD(id = CmdCode._3004)
    public void idleLineupAwardList(PlayerContext playerContext, GReqChapterItemList msg) {
        roleMissionService.sendIdleList(playerContext.getId());
    }


    /**
     * 领取挂机奖励
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._3005)
    public void idleAwardReceive(PlayerContext playerContext, BattleGMsg.GReqChapterItemReward msg) {
        BattleGMsg.GResChapterItemReward.Builder builder = BattleGMsg.GResChapterItemReward.newBuilder();
        Role role = roleService.getOrThrow(playerContext.getId());
        RoleMission roleMission = roleMissionService.getRoleMission(role.getId());
        int rewardMissionId = 1;
        if (roleMission.getChapterId() > rewardMissionId) {
            rewardMissionId = roleMission.getChapterId();
        }
        CChapterreward cChapterreward = chapterrewardSysCache.getOrThrow(rewardMissionId);

        // 挂机收益时长
        int idleTime = Math.min(DateTimeUtil.currentSecond() - roleMission.getStartTime(),
                roleVipService.getIdleMaxTime(playerContext.getId()));
        // 收益次数
        int dropNumber = idleTime / IdleConst.DROP_FREQUENCY;

        Asserts.isTrue(dropNumber > 0, ErrorCode.IDLE_AWARD_NOT_ENOUGH.getValue(),
                () -> String.format("idleTime:{%s},roleMission.getStartTime():{%s}", idleTime, roleMission.getStartTime()));
        //更新
        roleMission.setStartTime(DateTimeUtil.currentSecond());
        roleMissionService.updateRoleMission(roleMission);

//        //添加资源
//        List<ImmutableThing> rewardList = new ArrayList<>();
//        // 基础收益和快速挂机奖励一样，修改时需要同步修改
//        // 基础收益
//        List<ImmutableThing> baseReward = ImmutableThingUtil.multiplyThing(cChapterreward.getReward_base(), dropNumber);
//
//
//        List<ImmutableThing> promotion016DragonDrops = promotion016DragonInfoService.randomIdleDrops(role.getId(), idleTime);
//        List<ImmutableThing> promotion034Drops = promotion034ZhuShenService.randomIdleDrops(role.getId(), idleTime);
//        List<ImmutableThing> promotion044Drops = promotion044FiresShopService.randomIdleDrops(role.getId(), idleTime);
//
//
//        rewardList.addAll(baseReward); // 基础
//        rewardList.addAll(roleMissionService.dropReward(roleMission, rewardMissionId, idleTime));// 道具收益
//        rewardList.addAll(promotion016DragonDrops);// 活动获得
//        rewardList.addAll(promotion034Drops);
//        rewardList.addAll(promotion044Drops);
//
//        //基础资源掉落
//        Map<Integer, ImmutableThing> baseRewardMap = ListMapUtil.listToMap(baseReward, ImmutableThing::getItem_type);
//        //VIP挂机加成(只对基础资源加成)
//        if (role.getGoddessVip() > 0) {
//            CGoddessVip cGoddessVip = goddessVipSysCache.getOrThrow(role.getGoddessVip());
//            ThingService.addBonus(rewardList, baseRewardMap, cGoddessVip.getHangBonusList());
//        }
//
//        //特权礼包挂机资源加成
//        //角色经验特权加成
//        List<ThingBonus> roleExpBonus = promotion010PrivilegeGiftService.getPrivilegeBonus(role.getId(), PrivilegeEffectType.IDLE_ROLE_EXP);
//        ThingService.addBonus(rewardList, baseRewardMap, roleExpBonus, PrivilegeEffectType.IDLE_ROLE_EXP);
//        //金币特权加成
//        List<ThingBonus> goldBonus = promotion010PrivilegeGiftService.getPrivilegeBonus(role.getId(), PrivilegeEffectType.IDLE_GOLD);
//        ThingService.addBonus(rewardList, baseRewardMap, goldBonus, PrivilegeEffectType.IDLE_GOLD);
//        //英雄经验特权加成
//        List<ThingBonus> heroExpBonus = promotion010PrivilegeGiftService.getPrivilegeBonus(role.getId(), PrivilegeEffectType.IDLE_HERO_EXP);
//        ThingService.addBonus(rewardList, baseRewardMap, heroExpBonus, PrivilegeEffectType.IDLE_HERO_EXP);
//
//        rewardList = ImmutableThingUtil.mergeThing(rewardList);

        List<ImmutableThing> rewardList = roleMissionService.idleBattleReward(role.getId(), idleTime);

        thingService.add(role.getId(), rewardList, GameEvent.IDLE_RESOURCE);

        builder.setRewardTime(roleMission.getStartTime());
        playerContext.write(CmdCode._3005, builder.build());

        eventBus.post(IdleAwardReceiveEvent.of(role.getId(), idleTime));
    }


    @CMD(id = CmdCode._3006)
    public void reqHangUpReport(PlayerContext playerContext, GReqChapterReport msg) {
        CChapter chapter = chapterSysCache.getOrThrow(msg.getChapterIdx());
        BattlerDo attackerDo = battleHelper.queryPlayerBattler(LineUpType.LANG_UP, playerContext.getId(), Faction.ATTACKER);
        attackerDo.setFirstPos(msg.getFirstPos());
        attackerDo.setTestType(6); //只用普攻
        attackerDo.seal();
        BattlerDo defenderDo = battleHelper.queryNpcBattler(Lists.newArrayList(chapter), "");
        defenderDo.setAllSpikes();
        defenderDo.setTestType(6); // 只用普攻
        defenderDo.seal();
        BattleResult result = battleHelper.invokeBattle(BattleType.HANG_UP, attackerDo, defenderDo);
        GResChapterReport report = GResChapterReport.newBuilder().setFirstPos(msg.getFirstPos()).setReport(result.getReport())
                .setChapterIdx(msg.getChapterIdx()).build();
        playerContext.write(CmdCode._3006, report);
    }

    @CMD(id = CmdCode._3007)
    public void missionData(PlayerContext playerContext, GReqChapterData msg) {
        RoleMission roleMission = roleMissionService.getRoleMission(playerContext.getId());
        GResChapterData.Builder builder = GResChapterData.newBuilder();
        builder.setMaxIdx(roleMission.getChapterId());
        builder.setResRewardTime(roleMission.getStartTime());
        builder.addAllExtraRewardId(roleMission.getRewardIds());
        playerContext.write(CmdCode._3007, builder.build());
    }

    @CMD(id = CmdCode._3008)
    public void extraReward(PlayerContext playerContext, GReqExtraReward msg) {
        RoleMission roleMission = roleMissionService.getRoleMission(playerContext.getId());
        CChapterExtraReward extraReward = chapterExtraRewardSysCache.getOrThrow(msg.getRewardId());

        Asserts.isTrue(extraReward.getChapter() <= roleMission.getChapterId(), ErrorCode.CHAPTER_NOT_PASS.getValue(),
                () -> String.format("还未通关目标关卡：%s当前关卡:%s", extraReward.getChapter(), roleMission.getChapterId()));
        Asserts.isTrue(!roleMission.getRewardIds().contains(msg.getRewardId()), ErrorCode.EXTRA_REWARD_ALREADY_RECEIVED.getValue(),
                () -> String.format("额外奖励已经领取rewardId:%s", msg.getRewardId()));

        roleMission.getRewardIds().add(msg.getRewardId());
        roleMissionService.updateRoleMission(roleMission);

        Rewards rewards = thingService.add(playerContext.getId(), extraReward.getReward(), GameEvent.CHAPTER_EXTRA_REWARD, NoticeType.SLIENT);


        GResExtraReward.Builder builder = GResExtraReward.newBuilder();
        builder.addAllRewardId(roleMission.getRewardIds());
        builder.addAllList(PbUtil.buildReward(rewards));
        builder.addAllHeroList(heroService.buildHero(rewards.getHeroes()));
        playerContext.write(CmdCode._3008, builder.build());
    }

    /**
     * 关卡首通
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._3010)
    public void chapterRewardList(PlayerContext playerContext, BattleGMsg.GReqChapterRewardList msg) {
        BattleGMsg.GResChapterRewardList.Builder builder = BattleGMsg.GResChapterRewardList.newBuilder();
        RoleMission roleMission = roleMissionService.getRoleMission(playerContext.getId());
        List<Integer> list = roleMission.getChapterRewardId();
        builder.addAllList(list);
        playerContext.write(CmdCode._3010, builder.build());
    }

    /**
     * 领取关卡奖励
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._3011)
    public void chapterFirstReward(PlayerContext playerContext, BattleGMsg.GReqChapterFirstReward msg) {
        RoleMission roleMission = roleMissionService.getRoleMission(playerContext.getId());
        List<Integer> list = roleMission.getChapterRewardId();

        if (list.contains(msg.getIdx())) {
            playerContext.writeError(ErrorCode.CHAPTER_FIRST_REWARD_ALREADY_RECEIVED,
                    String.format("idx :%s, already received:%s", msg.getIdx(), JSONObject.toJSON(list)));
            return;
        }
        CFirstrewardChapter cModel = firstrewardChapterSysCache.getChapterOrThrow(msg.getIdx());
        Asserts.isTrue(roleMission.getChapterId() >= cModel.getChapter(),
                ErrorCode.CHAPTER_NOT_PASS.getValue(),
                () -> String.format("MissionId:%s req idx:%s CFirstrewardChapter chapter:%s",
                        roleMission.getChapterId(), msg.getIdx(), cModel.getChapter()));

        list.add(msg.getIdx());
        roleMission.setChapterReward(list);
        roleMissionService.updateRoleMission(roleMission);

        thingService.add(playerContext.getId(), cModel.getReward(), GameEvent.CHAPTER_FIRST_REWARD);

        playerContext.write(CmdCode._3011, GResChapterFirstReward.getDefaultInstance());

        eventBus.post(ChapterRewardEvent.of(playerContext.getId(), msg.getIdx()));
    }


    /**
     * 请求快速战斗次数
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._3012)
    public void quickBattleData(PlayerContext playerContext, BattleGMsg.GReqQuickBattleInitData msg) {
        BattleGMsg.GResQuickBattleInitData.Builder builder = BattleGMsg.GResQuickBattleInitData.newBuilder();
        RoleMission roleMission = roleMissionService.getRoleMission(playerContext.getId());
        builder.setBattleCount(roleMission.getQuickNum());
        builder.setMaxBattleCount(getMaxQuickBattleNum(playerContext.getId()));
        builder.setPromotion(promotionControlService.isPromotionRunning(PromotionType.SU_ZHAN_ZHI_WANG) ? 1 : 0);
        builder.setPrivilege(isFastPrivilege(playerContext.getId()) ? 1 : 0);
        playerContext.write(CmdCode._3012, builder.build());
    }


    /**
     * 快速战斗
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._3013)
    public void quickBattleReward(PlayerContext playerContext, BattleGMsg.GReqQuickBattleReward msg) {

        Role role = roleService.getOrThrow(playerContext.getId());
        RoleMission roleMission = roleMissionService.getRoleMission(role.getId());

        //速战之王活动提供的免费额外次数
        int promotionNum = 0;
        if (promotionControlService.isPromotionRunning(PromotionType.SU_ZHAN_ZHI_WANG)) {
            promotionNum = systemSysCache.getPromotionSpeedFightGetFreeTimes();
        }
        int maxQuickNum = getMaxQuickBattleNum(role.getId());

        Asserts.isTrue(roleMission.getQuickNum() < maxQuickNum, ErrorCode.SPEED_UP_COST_MORE_THAN_MAX_TIMES.getValue(),
                () -> String.format("quick num:%s max num:%s", roleMission.getQuickNum(), maxQuickNum));


        // 是否有特权
        boolean privilege = isFastPrivilege(role.getId());

        CSpeedUpCost cSpeedUpCost = speedUpCostSysCache
                .getOrThrow(roleMission.getQuickNum() + 1 - promotionNum > 0 ? roleMission.getQuickNum() + 1 - promotionNum : 1);

        long costGemCount = 0;
        if (privilege) {
            Asserts.isTrue(cSpeedUpCost.getCost_gem_adv() >= 0,
                    ErrorCode.SPEED_UP_COST_MORE_THAN_MAX_TIMES.getValue(),
                    () -> String.format("privilege:%s cSpeedUpCost.getCost_gem_adv():%s", true,
                            cSpeedUpCost.getCost_gem_adv()));
            costGemCount = cSpeedUpCost.getCost_gem_adv();
        } else {
            Asserts.isTrue(cSpeedUpCost.getCost_gem() >= 0,
                    ErrorCode.SPEED_UP_COST_MORE_THAN_MAX_TIMES.getValue(),
                    () -> String.format("privilege:%s cSpeedUpCost.getCost_gem():%s", false,
                            cSpeedUpCost.getCost_gem()));
            costGemCount = cSpeedUpCost.getCost_gem();
        }

        ImmutableThing cost = ImmutableThing.of(ItemType.IT_GEM, costGemCount);

        // 检查此次快速战斗关卡是否在允许范围内
        if (cost.getItem_num() > 0) {
            thingService.cost(role.getId(), cost, GameEvent.MISSION_QUICK_BATTLE);
        }

        int idleTime = IdleConst.SPEED_UP;

        List<ImmutableThing> rewardList = roleMissionService.idleBattleReward(role.getId(), idleTime);

        roleMission.setQuickBattleTime(DateTimeUtil.currentSecond());
        roleMission.setQuickNum(roleMission.getQuickNum() + 1);
        roleMissionService.updateRoleMission(roleMission);

        Rewards rewards = thingService.add(role.getId(), rewardList, GameEvent.MISSION_QUICK_BATTLE_REWARD, NoticeType.SLIENT);

        BattleGMsg.GResQuickBattleReward.Builder builder = BattleGMsg.GResQuickBattleReward.newBuilder();
        builder.setBattleCount(roleMission.getQuickNum());
        builder.setMaxBattleCount(getMaxQuickBattleNum(role.getId()));
        builder.addAllList(PbUtil.buildReward(rewards));
        playerContext.write(CmdCode._3013, builder.build());

        eventBus.post(SpeedFightEvent.of(playerContext.getId()));
    }

    /**
     * 切磋
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._3030)
    public void study(PlayerContext playerContext, GReqStudy msg) {
        BattlerDo attacker = battleHelper.queryPlayerBattler(BattleType.MAIN, playerContext.getId(), Faction.ATTACKER);

        if (serverConfig.matchServerId(msg.getServerId())) {
            BattlerDo defender = battleHelper.queryPlayerBattler(BattleType.MAIN, msg.getOpponentId(), Faction.DEFENDER);
            doStudy(playerContext, msg, attacker, defender);
        } else {
            messageDispatcher.dispatch(ReqBattlerVOMessage.of(msg.getOpponentId(), msg.getServerId(), BattleType.MAIN.getValue()), response -> {
                ResBattlerVOMessage message = (ResBattlerVOMessage) response;
                BattlerVo battlerVo = ProtostuffUtil.deserialize(message.getBattlerVo(), BattlerVo.class);
                BattlerDo defender = battleTemplate.queryBattler(battlerVo, message.getNick(), Faction.DEFENDER, UnitType.HERO);
                defender.setRoleInfo(message.getServerId(), message.getHeadId(), message.getBorderId(), message.getLevel(), message.getFighting());

                doStudy(playerContext, msg, attacker, defender);
            });
        }
    }

    private void doStudy(PlayerContext playerContext, GReqStudy msg, BattlerDo attacker, BattlerDo defender) {
        BattleResult result = battleHelper.invokeBattle(BattleType.STUDY, attacker, defender);
        commandBus.invoke(SaveBattleReportCommand.of(result.getReport()));
        GResStudy.Builder builder = GResStudy.newBuilder();
        builder.setReport(result.getReport());
        builder.setType(msg.getType());
        playerContext.write(CmdCode._3030, builder.build());
        eventBus.post(VideoRecordEvent.of(VideoType.STUDY, 0, result.getReport(), ""));
    }

    /**
     * 解锁第二契约
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._3097)
    public void unlock(PlayerContext playerContext, BattleGMsg.GReqUnlock msg) {
        //废除契约系统
        playerContext.write(CmdCode._3097, GResUnlock.getDefaultInstance());
    }

    /**
     * 解锁阵法
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._3098)
    public void unlockFormation(PlayerContext playerContext, BattleGMsg.GReqUnlockFormation msg) {
        //阵法改成按等级自动开启
        GResUnlockFormation.Builder builder = GResUnlockFormation.newBuilder();
        playerContext.write(CmdCode._3098, builder.build());
    }

    /**
     * 查询阵法信息
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._3099)
    public void queryFormation(PlayerContext playerContext, BattleGMsg.GReqQueryFormation msg) {
        Formation heroFormation = formationService.getFormation(playerContext.getId());
        GResQueryFormation.Builder builder = GResQueryFormation.newBuilder();
        builder.addAllUnlockIds(heroFormation.getUnlockFormationIds());
        playerContext.write(CmdCode._3099, builder.build());
    }

    /**
     * 保存各种类型的队伍
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._3100)
    public void lineUpSave(PlayerContext playerContext, BattleGMsg.GReqLineUpSave msg) {
        heroLineUpService.saveLineUpFormation(playerContext.getId(), msg.getLineData());
        playerContext.write(CmdCode._3100, GResLineUpSave.getDefaultInstance());
        eventBus.post(HeroLineEvent.of(playerContext.getId(), LineUpType.valueOf(msg.getLineData().getType())));
    }

    /**
     * 获取队伍
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._3101)
    public void getLineUp(PlayerContext playerContext, GReqLineUp msg) {
        List<HeroLineUp> lineUpList = heroLineUpService.getHeroLineUps(playerContext.getId());
        GResLineUp.Builder builder = GResLineUp.newBuilder();
        for (HeroLineUp lineUp : lineUpList) {
            PSLineUpData.Builder lineUpData = PSLineUpData.newBuilder();
            lineUpData.setGoddessType(lineUp.getGoddessType());
            lineUpData.setTime(lineUp.getTime());
            lineUpData.setType(lineUp.getType());
            lineUpData.setFormationId(lineUp.getFormationId());
            for (HeroPosition hpos : lineUp.getFormationMap().values()) {
                PSLineUpHeroData.Builder heroData = PSLineUpHeroData.newBuilder();
                heroData.setHeroId(hpos.getHeroId());
                heroData.setHp(0);
                heroData.setPosition(hpos.getPos());
                lineUpData.addHeroList(heroData.build());
            }
            builder.addList(lineUpData.build());
        }
        Role role = roleService.getOrThrow(playerContext.getId());
        builder.setAssistanceUnlock(role.isAssistanceUnlock());
        playerContext.write(CmdCode._3101, builder.build());
    }


    /**
     * 获取最大的快速战斗次数
     * @param rid
     */
    private int getMaxQuickBattleNum(long rid) {
        int maxQuickBattle = 0;
        if (promotionControlService.isPromotionRunning(PromotionType.SU_ZHAN_ZHI_WANG)) {
            maxQuickBattle = systemSysCache.getPromotionSpeedFightGetFreeTimes();
        }
        if (isFastPrivilege(rid)) {
            maxQuickBattle += speedUpCostSysCache.getAll().stream().filter(config -> config.getCost_gem_adv() >= 0).count();
        } else {
            maxQuickBattle += speedUpCostSysCache.getAll().stream().filter(config -> config.getCost_gem() >= 0).count();
        }
        return maxQuickBattle;
    }

    private boolean isFastPrivilege(long rid) {
        PrivilegeGift privilegeGift = promotion010PrivilegeGiftService.getPrivilegeGift(rid, PrivilegeType.FAST_BATTLE);
        if (privilegeGift != null && privilegeGift.getEndTime() > TimeDateUtil.getCurrentTimeInt()) {
            return true;
        }
        return false;
    }

    /**
     * 查询战报
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._3102)
    public void scanBattleReport(PlayerContext playerContext, GReqBattleReport msg) {
        BattleReport report = reportManager.getReport(msg.getBattleId());
        Asserts.notNull(report, ErrorCode.BATTLE_REPORT_TIMEOUT.getValue(), () -> String.format("战报已过期：%s", msg.getBattleId()));
        GResBattleReport.Builder builder = GResBattleReport.newBuilder();
        builder.setType(msg.getType());
        builder.setReport(report);
        playerContext.write(CmdCode._3102, builder.build());
    }

    /**
     * 战斗测试
     *
     * @param role
     * @param param
     */
    @GMCommand(command = GMCmdCode.BATTLE_TEST)
    public void gmBattleTest(Role role, List<String> param) {
        int testTimes = CollectionUtils.isEmpty(param) ? 1 : ConvertUtils.toInt(param.get(0));
        int battleCount = 0;
        Table<Integer, Integer, HeroInfo> heroTable = heroTypeSysCache.getHeroTable();
        List<HeroInfo> heros = new ArrayList<>();
        long startTime = TimeDateUtil.getCurrentTime();
        for (int time = 0; time < testTimes; time++) {
            for (int star = 1; star <= BattleConstant.MAX_STAR; star++) {
                for (int heroId : heroTable.rowKeySet()) {
                    HeroInfo heroInfo = heroTable.get(heroId, star);
                    if (heroInfo != null) {
                        heros.add(heroInfo);
                    }
                    if (heros.size() == 12) {
                        battleHelper.invokerBattle(heros);
                        battleCount++;
                        heros.clear();
                    }
                }
            }
            if (!heros.isEmpty()) {
                battleHelper.invokerBattle(heros);
                battleCount++;
            }
        }

        long endTime = TimeDateUtil.getCurrentTime();
        log.info("战场测试完毕，总共测试{}场耗时{}ms", battleCount, endTime - startTime);
    }

    /**
     * 预计算战斗力，在布阵时没有点击保存之前，需要计算战斗力给前端
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._3103)
    public void preComputeStrength(PlayerContext playerContext, GReqPreComputeStrength msg) {

        int fighting = 0;

        List<Hero> heroList = new ArrayList<>();
        HeroVo assistVo = null;//援助类英雄
        for (Long heroId : msg.getHeroIdsList()) {
            Hero hero = heroService.getHero(playerContext.getId(), heroId);
            if (hero != null) {
                heroList.add(hero);
            } else if (msg.getLineUpType() == LineUpType.DREAMLAND.getValue()) {
                assistVo = dreamlandService.getMySelectAssist(playerContext.getId());
            } else if (msg.getLineUpType() == LineUpType.ADVEN.getValue()) {
                assistVo = advenMissionService.getMySelectAssist(playerContext.getId(), heroId);
            }
        }

        if (!heroList.isEmpty()) {
            QueryHerosCommand command = QueryHerosCommand.createOf(heroList);
            commandBus.invoke(command);
            for (HeroDo heroDo : command.getHeroDos()) {
                heroDo.initAttribute();
                fighting += battleTemplate.computeStrength(heroDo);
            }
        }
        if (assistVo != null) {
            fighting += heroService.computeStrength(assistVo);
        }

        GResPreComputeStrength.Builder builder = GResPreComputeStrength.newBuilder();
        builder.setFighting(fighting);
        builder.setType(msg.getType());
        playerContext.write(CmdCode._3103, builder.build());
    }

    @GMCommand(command = GMCmdCode.HERO_RANDOM_TEST)
    public void test(Role role, List<String> param) {

        int star = param.size() > 0 ? Integer.valueOf(param.get(0)) : 0;

        new Thread(new Runnable() {
            @Override
            public void run() {
                int hadExecuteNum = 0;
                int formationId = 1;
                while (hadExecuteNum < 10) {
                    hadExecuteNum++;
                    List<Hero> heros = heroService.getHeros(role.getId());
                    if (star > 0) {
                        heros = heros.stream().filter(hero -> hero.getStar() == star).collect(Collectors.toList());
                    }
                    Collections.shuffle(heros);
                    int heroNum = (int) (Math.random() * 3) + 4;
                    int count = heros.size() / heroNum;
                    count = heros.size() % heroNum == 0 ? count - 1 : count;
                    for (int i = 0; i <= count; i++) {
                        HeroLineUp attackLineUp = null;
                        HeroLineUp defendLineUp = null;
                        try {
                            attackLineUp = heroLineUpService.getLineUpByType(role.getId(), LineUpType.MAIN);
                            List<CBattleMatrixAddition> matrixs = ImmutableList.copyOf(battleMatrixAdditionSysCache.getMatrix(formationId)
                                    .values()).stream().filter(config -> config.getIs_open() > 0).collect(Collectors.toList());
                            attackLineUp.getFormationMap().clear();
                            attackLineUp.setFormationId(formationId);
                            for (int j = 0; j < heroNum; j++) {
                                if (i * heroNum + j >= heros.size()) {
                                    break;
                                }

                                Hero hero = heros.get(i * heroNum + j);
                                HeroPosition heroPosition = new HeroPosition();
                                heroPosition.setPos(matrixs.get(j).getPosition());
                                heroPosition.setHeroId(hero.getId());
                                heroPosition.setHeroType(hero.getType());
                                heroPosition.setOwnerId(role.getId());

                                attackLineUp.getFormationMap().put(hero.getId(), heroPosition);
                            }

                            heroLineUpService.updateHeroLineUp(attackLineUp);

                            defendLineUp = heroLineUpService.getLineUpByType(role.getId(), LineUpType.PVP_DEF);
                            defendLineUp.setFormationId(formationId);
                            defendLineUp.getFormationMap().clear();
                            for (int j = 0; j < heroNum; j++) {
                                int index = (count - i) * heroNum + j;
                                if (index >= heros.size()) {
                                    break;
                                }
                                Hero hero = heros.get(index);
                                HeroPosition heroPosition = new HeroPosition();
                                heroPosition.setPos(matrixs.get(j).getPosition());
                                heroPosition.setHeroId(hero.getId());
                                heroPosition.setHeroType(hero.getType());
                                heroPosition.setOwnerId(role.getId());

                                defendLineUp.getFormationMap().put(hero.getId(), heroPosition);
                            }

                            heroLineUpService.updateHeroLineUp(defendLineUp);

                            BattlerDo attackDo = battleHelper.queryPlayerBattler(BattleType.MAIN, role.getId(), Faction.ATTACKER);

                            BattlerDo defendDo = battleHelper.queryPlayerBattler(LineUpType.PVP_DEF, role.getId(), Faction.DEFENDER);
                            BattleResult battleResult = battleHelper.invokeBattle(BattleType.MAIN, attackDo, defendDo);
                            commandBus.invoke(SaveBattleReportCommand.of(battleResult.getReport()));
                        } catch (Exception e) {
                            List<String> attackNames = new ArrayList<>();
                            attackLineUp.getFormationMap().values().forEach(heroPosition -> {
                                Hero hero = heroService.getHero(role.getId(), heroPosition.getHeroId());
                                attackNames.add(heroTypeSysCache.getById(heroPosition.getHeroType()).getNote() + "-" + hero.getStar());
                            });

                            List<String> defendName = new ArrayList<>();
                            defendLineUp.getFormationMap().values().forEach(heroPosition -> {
                                Hero hero = heroService.getHero(role.getId(), heroPosition.getHeroId());
                                defendName.add(heroTypeSysCache.getById(heroPosition.getHeroType()).getNote() + "-" + hero.getStar());
                            });
                            log.error("阵容数据,进攻：" + JsonUtil.toJson(attackNames) + ",防守：" + JsonUtil.toJson(defendName), e);
                        }

                        try {
                            Thread.sleep(100);
                        } catch (InterruptedException e) {
                            e.printStackTrace();
                        }
                    }

                }
            }
        }).start();
    }

    @GMCommand(command = GMCmdCode.SET_CHAPTER_ID)
    public void setChapterId(Role role, List<String> param) {
        int chapterId = param.size() > 0 ? Integer.valueOf(param.get(0)) : 1;
        RoleMission roleMission = roleMissionService.getRoleMission(role.getId());
        roleMission.setChapterId(chapterId);
        roleMissionService.updateRoleMission(roleMission);
    }
}
