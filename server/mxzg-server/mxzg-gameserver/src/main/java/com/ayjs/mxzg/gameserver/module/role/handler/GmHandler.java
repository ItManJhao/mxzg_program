/**
 *
 */
package com.ayjs.mxzg.gameserver.module.role.handler;

import com.alibaba.fastjson.JSONArray;
import com.ayjs.mxzg.battle.model.BattleResult;
import com.ayjs.mxzg.battle.model.BattleType;
import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.Faction;
import com.ayjs.mxzg.battle.model.UnitType;
import com.ayjs.mxzg.common.base.SpringProxy;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.DropUtil;
import com.ayjs.mxzg.common.util.GJsonUtils;
import com.ayjs.mxzg.common.util.JsonUtil;
import com.ayjs.mxzg.common.util.RandomUtil;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.common.util.time.TimeConstants;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.BuyGemSysCache;
import com.ayjs.mxzg.config.excel.cache.ChampionSeasonSysCache;
import com.ayjs.mxzg.config.excel.cache.ClanWorldBossStageSysCache;
import com.ayjs.mxzg.config.excel.cache.ClanWorldBossStageSysCache.NextStageConfig;
import com.ayjs.mxzg.config.excel.cache.DreamlandBuffSysCache;
import com.ayjs.mxzg.config.excel.cache.DreamlandLevelSysCache;
import com.ayjs.mxzg.config.excel.cache.EquipmenttypeSysCache;
import com.ayjs.mxzg.config.excel.cache.HeroStarSysCache;
import com.ayjs.mxzg.config.excel.cache.HeroTypeSysCache;
import com.ayjs.mxzg.config.excel.cache.HeroUpGradeSysCache;
import com.ayjs.mxzg.config.excel.cache.JewelTypeSysCache;
import com.ayjs.mxzg.config.excel.cache.LotteryWeightSysCache;
import com.ayjs.mxzg.config.excel.cache.MainLevelSysCache;
import com.ayjs.mxzg.config.excel.cache.NickSysCache;
import com.ayjs.mxzg.config.excel.cache.PromotionControlSysCache;
import com.ayjs.mxzg.config.excel.cache.PromotionTrafficPermitSysCache;
import com.ayjs.mxzg.config.excel.cache.RuneSkillTypeSysCache;
import com.ayjs.mxzg.config.excel.cache.RunesAbilitySysCache;
import com.ayjs.mxzg.config.excel.cache.RunesTypeSysCache;
import com.ayjs.mxzg.config.excel.cache.RunesTypeSysCache.RuneDataTemplate;
import com.ayjs.mxzg.config.excel.cache.ShelterShopPrizeSysCache;
import com.ayjs.mxzg.config.excel.cache.TavernChanceSysCache;
import com.ayjs.mxzg.config.excel.cache.TavernSysCache;
import com.ayjs.mxzg.config.excel.cache.XingSysCache;
import com.ayjs.mxzg.config.excel.constant.ChampionConst;
import com.ayjs.mxzg.config.excel.constant.VideoConst;
import com.ayjs.mxzg.config.excel.entity.CBuyGem;
import com.ayjs.mxzg.config.excel.entity.CDreamlandBuff;
import com.ayjs.mxzg.config.excel.entity.CDreamlandLevel;
import com.ayjs.mxzg.config.excel.entity.CEquipmenttype;
import com.ayjs.mxzg.config.excel.entity.CHeroStar;
import com.ayjs.mxzg.config.excel.entity.CHeroType;
import com.ayjs.mxzg.config.excel.entity.CHeroUpGrade;
import com.ayjs.mxzg.config.excel.entity.CJewelType;
import com.ayjs.mxzg.config.excel.entity.CMainLevel;
import com.ayjs.mxzg.config.excel.entity.CPromotionControl;
import com.ayjs.mxzg.config.excel.entity.CPromotionTrafficPermit;
import com.ayjs.mxzg.config.excel.entity.CRuneSkillType;
import com.ayjs.mxzg.config.excel.entity.CRunesType;
import com.ayjs.mxzg.config.excel.entity.CShelterShopPrize;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.config.struct.ItemType;
import com.ayjs.mxzg.config.struct.LineUpType;
import com.ayjs.mxzg.config.struct.RuneSkill;
import com.ayjs.mxzg.gameserver.infrastructure.constant.ServerConfig;
import com.ayjs.mxzg.gameserver.infrastructure.gm.GMCommand;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.GMCmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.battle.BattleHelper;
import com.ayjs.mxzg.gameserver.module.battle.domain.RoleMission;
import com.ayjs.mxzg.gameserver.module.battle.event.ChapterPassEvent;
import com.ayjs.mxzg.gameserver.module.battle.service.RoleMissionService;
import com.ayjs.mxzg.gameserver.module.blessingPool.domain.BlessingPool;
import com.ayjs.mxzg.gameserver.module.blessingPool.domain.BlessingPoolItemData;
import com.ayjs.mxzg.gameserver.module.blessingPool.service.BlessingPoolService;
import com.ayjs.mxzg.gameserver.module.champion.handler.ChampionTestHandler;
import com.ayjs.mxzg.gameserver.module.champion.service.ChampionService;
import com.ayjs.mxzg.gameserver.module.clan.domain.ClanBossBattleInfo;
import com.ayjs.mxzg.gameserver.module.clan.service.ClanBossService;
import com.ayjs.mxzg.gameserver.module.clanwar.handler.ClanWarTestHandler;
import com.ayjs.mxzg.gameserver.module.clanwar.service.ClanWarService;
import com.ayjs.mxzg.gameserver.module.dreamland.constant.DreamlandBattleStatus;
import com.ayjs.mxzg.gameserver.module.dreamland.domin.Dreamland;
import com.ayjs.mxzg.gameserver.module.dreamland.service.DreamlandService;
import com.ayjs.mxzg.gameserver.module.dungeon.service.DungeonBackpackService;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroLineUp;
import com.ayjs.mxzg.gameserver.module.hero.event.HeroGetEvent;
import com.ayjs.mxzg.gameserver.module.hero.handler.summon.NormalTenSummon;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroLineUpService;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.hero.struct.UpStarRequire;
import com.ayjs.mxzg.gameserver.module.mail.constant.MailScene;
import com.ayjs.mxzg.gameserver.module.mail.domain.Mail;
import com.ayjs.mxzg.gameserver.module.mail.service.MailService;
import com.ayjs.mxzg.gameserver.module.mail.struct.MailParams;
import com.ayjs.mxzg.gameserver.module.marquee.service.MarqueeService;
import com.ayjs.mxzg.gameserver.module.onlineReward.domain.OnlineReward;
import com.ayjs.mxzg.gameserver.module.onlineReward.service.OnlineRewardService;
import com.ayjs.mxzg.gameserver.module.promotionNew.constant.PromotionType;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion053TrafficPermit;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion061ThreeDayTask;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion065HeroRolling;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion069RechargeGift;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.Promotion072;
import com.ayjs.mxzg.gameserver.module.promotionNew.domain.PromotionControl;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion016DragonInfoService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion053TrafficPermitService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion061ThreeDayTaskService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion065HeroRollingService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion069RechargeGiftService;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.Promotion072Service;
import com.ayjs.mxzg.gameserver.module.promotionNew.service.PromotionControlService;
import com.ayjs.mxzg.gameserver.module.promotionNew.struct.TrafficPermitTaskProgress;
import com.ayjs.mxzg.gameserver.module.prophetSummon.service.ProphetSummonService;
import com.ayjs.mxzg.gameserver.module.pvp.service.PvpSysInfoService;
import com.ayjs.mxzg.gameserver.module.recharge.service.RechargeService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.rune.domain.RuneInfo;
import com.ayjs.mxzg.gameserver.module.rune.event.RuneAddEvent;
import com.ayjs.mxzg.gameserver.module.rune.service.RuneInfoService;
import com.ayjs.mxzg.gameserver.module.sensitive.service.SensitiveWordService;
import com.ayjs.mxzg.gameserver.module.task.domain.TavernInfo;
import com.ayjs.mxzg.gameserver.module.task.service.TavernInfoService;
import com.ayjs.mxzg.gameserver.module.towercross.domain.TowerCrossRole;
import com.ayjs.mxzg.gameserver.module.towercross.service.TowerCrossRoleService;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.gameserver.module.video.constant.VideoType;
import com.ayjs.mxzg.gameserver.module.video.domain.VideoHall;
import com.ayjs.mxzg.gameserver.module.video.service.VideoHallService;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ReqChampionCrossGmNextStage;
import com.ayjs.mxzg.message.module.champion.ChampionMessage.ReqChampionCrossGmNextStage.ReqChampionCrossGmNextStageBuilder;
import com.ayjs.mxzg.message.module.clanwar.ClanWarMessage.ReqGmClanWarChangeStageMessage;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ReqGmCwbChangeStageMessage;
import com.ayjs.mxzg.message.module.timetower.TimeTowerMessage.ReqTimeTowerGmRewardMessage;
import com.ayjs.mxzg.message.module.timetower.TimeTowerMessage.ReqTimeTowerGmRewardMessage.ReqTimeTowerGmRewardMessageBuilder;
import com.ayjs.mxzg.module.battle.BattleTemplate;
import com.ayjs.mxzg.protocol.BackPackGMsg;
import com.ayjs.mxzg.protocol.BattleGMsg;
import com.ayjs.mxzg.protocol.ObjectGMsg.PSBackpackData;
import com.ayjs.mxzg.protocol.OnlineRewardGMsg;
import com.ayjs.mxzg.protocol.PubTaskGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.ayjs.mxzg.template.language.LanguageHelper;
import com.ayjs.rpc.dispatcher.MessageDispatcher;
import com.google.protobuf.InvalidProtocolBufferException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * @author YY
 *
 */
@Slf4j
@Controller
public class GmHandler extends ProtocolHandler {

    @Autowired
    private ThingService thingService;
    @Autowired
    private RoleService roleService;
    @Autowired
    private PromotionControlService promotionControlService;
    @Autowired
    private BuyGemSysCache buyGemSysCache;
    @Autowired
    private RechargeService rechargeService;
    @Autowired
    private MainLevelSysCache mainLevelSysCache;
    @Autowired
    private EquipmenttypeSysCache equipmenttypeSysCache;
    @Autowired
    private HeroTypeSysCache heroTypeSysCache;
    @Autowired
    private HeroStarSysCache heroStarSysCache;
    @Autowired
    private HeroService heroService;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private HeroLineUpService heroLineUpService;
    //    @Autowired
//    private ClanWorldBossService clanWorldBossService;
    @Autowired
    private ClanWarService clanWarService;
    @Autowired
    private MailService mailService;
    @Autowired
    private PromotionControlSysCache promotionControlSysCache;
    @Autowired
    private ClanWarTestHandler clanWarTestHandler;
    @Autowired
    private RoleMissionService roleMissionService;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private MarqueeService marqueeService;
    @Autowired
    private BlessingPoolService blessingPoolService;
    @Autowired
    private PvpSysInfoService pvpSysInfoService;
    @Autowired
    private ProphetSummonService prophetSummonService;
    @Autowired
    private Promotion016DragonInfoService promotion016DragonInfoService;
    @Autowired
    private OnlineRewardService onlineRewardService;
    @Autowired
    private ShelterShopPrizeSysCache shelterShopPrizeSysCache;
    @Autowired
    private DungeonBackpackService dungeonBackpackService;
    @Autowired
    private LotteryWeightSysCache lotteryWeightSysCache;
    @Autowired
    private TavernChanceSysCache tavernChanceSysCache;
    @Autowired
    private TavernSysCache tavernSysCache;
    @Autowired
    private HeroUpGradeSysCache heroUpGradeSysCache;
    @Autowired
    private ClanWorldBossStageSysCache clanWorldBossStageSysCache;
    @Autowired
    private ChampionService championService;
    @Autowired
    private ChampionTestHandler championTestHandler;
    @Autowired
    private MessageDispatcher messageDispatcher;
    @Autowired
    private Promotion053TrafficPermitService promotion053TrafficPermitService;
    @Autowired
    private PromotionTrafficPermitSysCache promotionTrafficPermitSysCache;
    @Autowired
    private RunesTypeSysCache runesTypeSysCache;
    @Autowired
    private RunesAbilitySysCache runesAbilitySysCache;
    @Autowired
    private RuneSkillTypeSysCache runeSkillTypeSysCache;
    @Autowired
    private RuneInfoService runeInfoService;
    @Autowired
    private TavernInfoService tavernInfoService;
    @Autowired
    private JewelTypeSysCache jewelTypeSysCache;
    @Autowired
    private DreamlandService dreamlandService;
    @Autowired
    private DreamlandLevelSysCache dreamlandLevelSysCache;
    @Autowired
    private BattleTemplate battleTemplate;
    @Autowired
    private BattleHelper battleHelper;
    @Autowired
    private DreamlandBuffSysCache dreamlandBuffSysCache;
    @Autowired
    private Promotion061ThreeDayTaskService promotion061ThreeDayTaskService;
    @Autowired
    private Promotion065HeroRollingService promotion065HeroRollingService;
    @Autowired
    private NickSysCache nickSysCache;
    @Autowired
    private XingSysCache xingSysCache;
    @Autowired
    private LanguageHelper languageHelper;
    @Autowired
    private SensitiveWordService sensitiveWordService;
    @Autowired
    private TowerCrossRoleService towerCrossRoleService;
    @Autowired
    private Promotion069RechargeGiftService promotion069RechargeGiftService;
    @Autowired
    private Promotion072Service promotion072Service;
    @Autowired
    private ServerConfig serverConfig;
    @Autowired
    private ClanBossService clanBossService;

    @GMCommand(command = GMCmdCode.ADD_ITEM)
    public void gmAddResource(Role role, List<String> param) {
        if (Objects.isNull(param) || param.size() < 2) {
            log.error("rid:{},gm add resource:{}", role.getId(), GJsonUtils.toJson(param));
            return;
        }
        int itemType = Integer.parseInt(param.get(0));
        long number = Long.parseLong(param.get(1));
        ImmutableThing thing = ImmutableThing.of(itemType, number);
        thingService.add(role.getId(), thing, GameEvent.GM);
    }

    @GMCommand(command = GMCmdCode.ADD_ROLE_EXP)
    public void gmAddRoleExp(Role role, List<String> param) {
        if (Objects.isNull(param) || param.isEmpty()) {
            log.error("rid:{}, gmAddRoleExp:{}", role.getId(), GJsonUtils.toJson(param));
            return;
        }
        long addExp = Long.parseLong(param.get(0));
        roleService.addExp(role.getId(), addExp, GameEvent.GM);
    }

    @GMCommand(command = GMCmdCode.OPEN_ALL_PROMOTION)
    public void openAllPromotion(Role role, List<String> param) {
        List<PromotionControl> list = promotionControlService.getAllPromotion();

        if (param.isEmpty()) {
            //开启所有活动
            for (PromotionControl control : list) {

                if (PromotionType.valueOf(control.getType()).getOpenType() == 2) {
                    continue;
                }

                try {
                    CPromotionControl cControl = promotionControlSysCache.getOrThrow(control.getType());
                    control.setStartTime(TimeDateUtil.getTodayZeroTimeInt());
                    control.setEndTime(control.getStartTime() + cControl.getTime() * TimeDateUtil.ONEDAYINT);
                    control.setClearTime(control.getEndTime() + cControl.getClean_time() * TimeDateUtil.ONEDAYINT);
                    control.setNextTime(control.getClearTime() + cControl.getInterval_time() * TimeDateUtil.ONEDAYINT);
                    control.setTurnsTime(TimeDateUtil.getCurrentTimeInt());
                } catch (Exception e) {
                    control.setStartTime(TimeDateUtil.getTodayZeroTimeInt());
                    control.setEndTime(control.getStartTime() + TimeDateUtil.ONEDAYINT);
                    control.setClearTime(control.getEndTime() + TimeDateUtil.ONEDAYINT);
                    control.setNextTime(control.getClearTime() + TimeDateUtil.ONEDAYINT);
                    control.setTurnsTime(TimeDateUtil.getCurrentTimeInt());
                }
            }
        } else {
            //关闭所有活动
            for (PromotionControl control : list) {
                control.setStartTime(TimeDateUtil.getTodayZeroTimeInt() + TimeDateUtil.ONEDAYINT * 10);
                control.setEndTime(control.getStartTime() + TimeDateUtil.ONEDAYINT);
                control.setClearTime(control.getEndTime() + TimeDateUtil.ONEDAYINT);
                control.setNextTime(control.getClearTime() + TimeDateUtil.ONEDAYINT);
                control.setTurnsTime(TimeDateUtil.getCurrentTimeInt());
            }
        }
        promotionControlService.updateControls(list);

    }

    @GMCommand(command = GMCmdCode.RECHARGE)
    public void gmRecharge(Role role, List<String> param) {
        int productId = Integer.parseInt(param.get(0));
        CBuyGem cBuyGem = buyGemSysCache.getOrThrow(productId);
        log.info("GM购买商品{}", productId);
        //根据buyGem的类型分发到各种模块进行是否能够购买商品的判断，比如限购的判断
        if (!rechargeService.isCanBuy(role.getId(), cBuyGem)) {
            log.info("无法GM购买商品{}", productId);
            return;
        }
        boolean flag = rechargeService.buyGoodsSuccess(role.getId(), productId, cBuyGem.getRmb(), true);
        log.info("GM购买商品{}，{}", productId, flag);
    }

    @GMCommand(command = GMCmdCode.ROLE_LV)
    public void roleLv(Role role, List<String> param) {
        int upLv = Integer.parseInt(param.get(0));
        long totalExp = 0;

        if (role.getLevel() + upLv > mainLevelSysCache.getMaxLevel()) {
            upLv = mainLevelSysCache.getMaxLevel() - role.getLevel();
        }
        for (int i = 0; i < upLv; i++) {
            CMainLevel config = mainLevelSysCache.getOrThrow(role.getLevel() + i);
            totalExp += config.getExp();
        }
        ImmutableThing thing = ImmutableThing.of(ItemType.IT_ROLE_EXP, totalExp);
        thingService.add(role.getId(), thing, GameEvent.GM);
    }

    @GMCommand(command = GMCmdCode.ROLE_NICK_CHECK)
    public void roleNickCheck(Role role, List<String> param) {
        Set<Integer> languages = new HashSet<>();
        languages.add(serverConfig.getServerLang());
        if (Objects.nonNull(serverConfig.getSensitiveLang())) {
            for (int i : serverConfig.getSensitiveLang()) {
                languages.add(i);
            }
        }

        int temp = role.getLang();
        for (int language : languages) {
            role.setLang(language);
            List<String> firstNames = nickSysCache.getAll().stream().map(config -> languageHelper.getLanguageBy(config, language))
                    .filter(Objects::nonNull).collect(Collectors.toList());
            firstNames.forEach(firstName -> {
                if (!sensitiveWordService.wordCanUse(firstName, role)) {
                    log.error("first name in sensitive Word:{}", firstName);
                }
            });

            List<String> secondNames = xingSysCache.getAll().stream().map(config -> languageHelper.getLanguageBy(config, language))
                    .filter(Objects::nonNull).collect(Collectors.toList());
            secondNames.forEach(secondName -> {
                if (!sensitiveWordService.wordCanUse(secondName, role)) {
                    log.error("second name in sensitive Word:{}", secondName);
                }
            });
            firstNames.forEach(firstName -> {
                secondNames.forEach(secondName -> {
                    boolean canUse = sensitiveWordService.wordCanUse(secondName + firstName, role);
                    if (!canUse) {
                        log.error("whole name in sensitive Word:second{{}},first{{}}", secondName, firstName);
                    }
                });
            });
        }
        role.setLang(temp);

    }

    @GMCommand(command = GMCmdCode.ALL_HERO)
    public void allHero(Role role, List<String> param) {

        List<Hero> heroList = new ArrayList<>();
        for (CHeroType cHeroType : heroTypeSysCache.getAll()) {
            addHero(cHeroType, heroList, role.getId(), cHeroType.getStar());
            if (JSONArray.parseArray(cHeroType.getTo_5_star(), UpStarRequire.class).size() > 0) {
                addHero(cHeroType, heroList, role.getId(), 5);
            }
            if (JSONArray.parseArray(cHeroType.getTo_6_star(), UpStarRequire.class).size() > 0) {
                addHero(cHeroType, heroList, role.getId(), 6);
            }
            if (JSONArray.parseArray(cHeroType.getTo_7_star(), UpStarRequire.class).size() > 0) {
                addHero(cHeroType, heroList, role.getId(), 7);
            }
            if (JSONArray.parseArray(cHeroType.getTo_8_star(), UpStarRequire.class).size() > 0) {
                addHero(cHeroType, heroList, role.getId(), 8);
            }
            if (JSONArray.parseArray(cHeroType.getTo_9_star(), UpStarRequire.class).size() > 0) {
                addHero(cHeroType, heroList, role.getId(), 9);
            }
            if (JSONArray.parseArray(cHeroType.getTo_10_star(), UpStarRequire.class).size() > 0) {
                addHero(cHeroType, heroList, role.getId(), 10);
            }
            if (JSONArray.parseArray(cHeroType.getTo_11_star(), UpStarRequire.class).size() > 0) {
                addHero(cHeroType, heroList, role.getId(), 11);
            }
            if (JSONArray.parseArray(cHeroType.getTo_12_star(), UpStarRequire.class).size() > 0) {
                addHero(cHeroType, heroList, role.getId(), 12);
            }
            if (JSONArray.parseArray(cHeroType.getTo_13_star(), UpStarRequire.class).size() > 0) {
                addHero(cHeroType, heroList, role.getId(), 13);
            }
            try {
                if (JSONArray.parseArray(cHeroType.getTo_14_star(), UpStarRequire.class).size() > 0) {
                    addHero(cHeroType, heroList, role.getId(), 14);
                }
            } catch (Exception ex) {

            }
        }
        heroService.addHeros(heroList);
        eventBus.post(HeroGetEvent.of(role.getId(), heroList, GameEvent.GM));
    }

    private void addHero(CHeroType cHeroType, List<Hero> heroList, long rid, int star) {
        CHeroStar cHeroStar = heroStarSysCache.getOrThrow(star);
        CHeroUpGrade cHeroUpGrade = heroUpGradeSysCache.getHeroUpGradeOrThrow(cHeroStar.getLevel_limit());
        Hero hero = heroService.createHero(rid, cHeroType, star, cHeroStar.getLevel_limit(), cHeroUpGrade.getGrade());
        heroList.add(hero);
    }

    @GMCommand(command = GMCmdCode.CLEAN_ALL_HERO)
    public void cleanAllHero(Role role, List<String> param) {
        List<Hero> list = heroService.getHeros(role.getId());
        List<Hero> deleteList = new ArrayList<>();

        for (Hero hero : list) {
            if (!heroLineUpService.isHeroLineUp(role.getId(), hero.getId())) {
                deleteList.add(hero);
            } else {
                log.info(hero.getId() + " 在阵型中");
            }
        }
        if (!deleteList.isEmpty()) {
            heroService.deleteHeros(role.getId(), deleteList, GameEvent.GM);
        }
    }


    @GMCommand(command = GMCmdCode.ALL_EQUIP)
    public void allEquip(Role role, List<String> param) {
        List<CEquipmenttype> equipList = equipmenttypeSysCache.getAll();

        List<ImmutableThing> equips = new ArrayList<>();
        for (CEquipmenttype cEquip : equipList) {
            equips.add(ImmutableThing.of(cEquip.getEquipment_type(), 100));
        }
        thingService.add(role.getId(), equips, GameEvent.GM);
    }


    @GMCommand(command = GMCmdCode.CWB_NEXT_STAGE)
    public void clanWorldBossNextStage(Role role, List<String> param) {
        messageDispatcher.dispatch(ReqGmCwbChangeStageMessage.builder().build());
    }

    @GMCommand(command = GMCmdCode.CLANWAR_NEXT_STAGE)
    public void clanWarNextStage(Role role, List<String> param) {
        messageDispatcher.dispatch(ReqGmClanWarChangeStageMessage.builder().build());
    }

    @GMCommand(command = GMCmdCode.CLANWAR_BUILD)
    public void buildTestClanWarEnvironment(Role role, List<String> param) {
        log.info("公会战测试环境构建开始");
        clanWarTestHandler.buildTestEnviroment();
        log.info("公会战测试环境构建结束");
        //TODO 向跨服上报数据
    }

    @GMCommand(command = GMCmdCode.CLANWAR_AUTO_ROAD)
    public void buildTestClanWarAutoRoad(Role role, List<String> param) {
        log.info("公会战测试环境自动布路开始");
        clanWarTestHandler.buildMemberAutoRoad();
        log.info("公会战测试环境自动布路结束");
    }

    @GMCommand(command = GMCmdCode.CWB_RESTART)
    public void clanWorldBossRestart(Role role, List<String> param) {

        NextStageConfig nextStageConfig = clanWorldBossStageSysCache.getNextConfig();
        System.out.println(new Date((nextStageConfig.getWeekZero() + nextStageConfig.getStageConfig().getForecast_time()) * 1000l));
        System.out.println(new Date((nextStageConfig.getWeekZero() + nextStageConfig.getStageConfig().getChallenge_time()) * 1000l));
        System.out.println(new Date((nextStageConfig.getWeekZero() + nextStageConfig.getStageConfig().getRob_time()) * 1000l));
        System.out.println(new Date((nextStageConfig.getWeekZero() + nextStageConfig.getStageConfig().getSpace_time()) * 1000l));
        System.out.println(JsonUtil.toJson(clanWorldBossStageSysCache.getNextConfig()));
//        try {
//            clanWorldBossService.start();
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
    }

    /**
     * 角色关卡
     */
    @GMCommand(command = GMCmdCode.ROLE_MISSION)
    public void gmRoleMission(Role role, List<String> param) {
        int missionId = Integer.parseInt(param.get(0));
        RoleMission roleMission = roleMissionService.getRoleMission(role.getId());
        roleMission.setChapterId(roleMission.getChapterId() + missionId);

        BattleGMsg.GResChapterData.Builder builder = BattleGMsg.GResChapterData.newBuilder();
        builder.setMaxIdx(roleMission.getChapterId());
        builder.setResRewardTime(roleMission.getStartTime());
        builder.addAllExtraRewardId(roleMission.getRewardIds());
        contextManager.write(role.getId(), CmdCode._3007, builder.build());

        eventBus.post(ChapterPassEvent.of(role.getId(), roleMission.getChapterId()));
    }

    /**
     * 测试掉落
     * 示例命令：IDLE_AWARD_TEST 3 10 100 20
     * 测试第三关掉落，总共掉落100回合，每20回合重置一次限制数据，单回合是测试服10分钟的数据
     *
     * @param role
     * @param param
     */
    @GMCommand(command = GMCmdCode.IDLE_AWARD_TEST)
    public void idleAwardTest(Role role, List<String> param) {
        int missionId = Integer.parseInt(param.get(0));
        int onceDropTimes = Integer.parseInt(param.get(1));
        int totalTimes = Integer.parseInt(param.get(2));
        int dropLimit = Integer.parseInt(param.get(3));
        roleMissionService.gmTestIdleAward(role.getId(), missionId, onceDropTimes, totalTimes, dropLimit);
    }

    @GMCommand(command = GMCmdCode.MARQUEE_TEST)
    public void testMarquee(Role role, List<String> param) {
//        marqueeService.addMarquee(NoticeIdx.CLAN_CREATE, 0, ObjParam.build(role.getId(), role.getClanId()));
//        marqueeService.addMarquee(NoticeIdx.CLAN_JOIN, role.getClanId(), ObjParam.build(role.getId()));
//        marqueeService.addMarquee(NoticeIdx.CLAN_POS_CHANGE, role.getClanId(), ObjParam.build(role.getId()));
//        marqueeService.addMarquee(NoticeIdx.CLAN_CHANGE_LEADER, role.getClanId(), ObjParam.build(role.getId()));
//        marqueeService.addMarquee(NoticeIdx.HERO_SUMMON, 0, ObjParam.build(role.getId(), SummonType.HIGH.getType(), 10105010));
//        marqueeService.addMarquee(NoticeIdx.PROPHET_SUMMON, 0, ObjParam.build(role.getId(), 10105010));
//        marqueeService.addMarquee(NoticeIdx.HERO_UP_STAR, 0, ObjParam.build(role.getId(), 10105010, 7));
//        marqueeService.addMarquee(NoticeIdx.CWB_FORECAST, 0, ObjParam.build(TimeDateUtil.getCurrentTimeInt()));
//        marqueeService.addMarquee(NoticeIdx.CWB_CHALLENGE, 0, null);
//        marqueeService.addMarquee(NoticeIdx.CWB_ROB, 0, null);
//        marqueeService.addMarquee(NoticeIdx.CWB_FIRST, 0, ObjParam.build(role.getId(), role.getClanId()));
//        marqueeService.addMarquee(NoticeIdx.CWB_CLAN, role.getClanId(), ObjParam.build(8922, 5555));
//        marqueeService.addMarquee(NoticeIdx.CLANWAR_PREPARE, role.getClanId(), null);
//        marqueeService.addMarquee(NoticeIdx.CLANWAR_ADJUST, role.getClanId(), null);
//        marqueeService.addMarquee(NoticeIdx.CLAN_WAR_WIN, role.getClanId(), null);

        ImmutableThing reward = ImmutableThing.of(ChampionConst.GUESS_REWARD_TYPE, 222);
        Mail mail = mailService.newMailNoTitle(role.getId(), MailScene.CHAMPION_COIN,
                MailParams.build(1111, 222), Collections.singletonList(reward), GameEvent.CHAMPION_COIN);
        mailService.insert(mail);

        System.out.println(JsonUtil.toJson(SpringProxy.getBean(ChampionSeasonSysCache.class).getNextStartTime(1585447200)));
    }

    /**
     * 测试许愿池概率，
     * 示例：BLESSING_POOL_TEST 1 100 10 普通关卡跑100次10连抽，每10连抽刷新一次奖池
     */
    @GMCommand(command = GMCmdCode.BLESSING_POOL_TEST)
    public void testBlessingPool(Role role, List<String> param) {
        int type = Integer.parseInt(param.get(0));
        int times = Integer.parseInt(param.get(1));
        int refreshLimit = Integer.parseInt(param.get(2));

        BackPackGMsg.GResBackpackGain.Builder builder = BackPackGMsg.GResBackpackGain.newBuilder();
        List<BlessingPoolItemData> poolItemDataList = new ArrayList<>();
        for (int i = 1; i <= times; i++) {
            BlessingPool blessingPool = blessingPoolService.getBlessingPoolByType(role.getId(), type);
            // 多少次刷新一次
            if (i % refreshLimit == 0) {
                blessingPoolService.refreshBlessingPoolItemData(blessingPool);
            }

            Map<Integer, BlessingPoolItemData> itemDataMap = blessingPool.getItemData();
            poolItemDataList.addAll(blessingPoolService.blessingPoolDrop(itemDataMap, 10));
        }
        List<ImmutableThing> tempRewardThing = new ArrayList<>();
        for (BlessingPoolItemData itemData : poolItemDataList) {
            tempRewardThing.add(ImmutableThing.of(itemData.getItemType(), itemData.getItemNumber()));

        }
        List<ImmutableThing> rewardThing = ImmutableThingUtil.mergeThing(tempRewardThing);
        builder.setType(NoticeType.NORMAL.getValue());
        builder.addAllList(PbUtil.buildReward(rewardThing));
        contextManager.write(role.getId(), CmdCode._5002, builder.build());
    }

    @GMCommand(command = GMCmdCode.PVP_REWARD_TEST)
    public void testPvpReward(Role role, List<String> param) {
        pvpSysInfoService.testDailyPvpReward();
        pvpSysInfoService.testWeeklyPvpReward();
        clanWarService.testForEndReward(role.getId());
    }

    /**
     * 先知召唤
     * 示例：PROPHET_SUMMON_TEST 2 100, 水系先知召唤100次
     */
    @GMCommand(command = GMCmdCode.PROPHET_SUMMON_TEST)
    public void prophetSummonTest(Role role, List<String> param) {
        int type = Integer.parseInt(param.get(0));
        int times = Integer.parseInt(param.get(1));
        List<ImmutableThing> result = new ArrayList<>();
        for (int i = 0; i < times; i++) {

//            result.addAll(prophetSummonService.prophetSummon(role.getId(), type));
        }
        result = ImmutableThingUtil.mergeThing(result);

        BackPackGMsg.GResBackpackGain.Builder builder = BackPackGMsg.GResBackpackGain.newBuilder();
        builder.setType(NoticeType.NORMAL.getValue());
        builder.addAllList(PbUtil.buildReward(result));
        contextManager.write(role.getId(), CmdCode._5002, builder.build());
    }

    /**
     * 七日目标
     * @param role
     * @param param
     */
    @GMCommand(command = GMCmdCode.SEVEN_DAY_TEST)
    public void sevenDayTest(Role role, List<String> param) {
        role.setCreateTime(role.getCreateTime() - TimeDateUtil.ONEDAY);
        roleService.updateRole(role);
    }

    @GMCommand(command = GMCmdCode.DRAGON_DROP_TEST)
    public void testDragonDrop(Role role, List<String> param) {
        for (int i = 0; i < 100; i++) {
            List<ImmutableThing> list = promotion016DragonInfoService.randomQuickDrops(role.getId(), 6 * 60 * 60);
            System.out.println(JsonUtil.toJson(list));
        }
    }


    @GMCommand(command = GMCmdCode.RATE_TEST)
    public void rateTest(Role role, List<String> param) {
        SpringProxy.getBean(NormalTenSummon.class).testSummon();
    }

    /**
     * 增加在线时长
     * @param role
     * @param param
     */
    @GMCommand(command = GMCmdCode.ADD_ONLINE_TIME)
    public void addOnlineTime(Role role, List<String> param) {

        OnlineReward onlineReward = onlineRewardService.getOnlineReward(role.getId());
        onlineReward.setOnlineTime(onlineReward.getOnlineTime() + 3600);
        onlineRewardService.updateOnlineReward(onlineReward);

        OnlineRewardGMsg.GResInitOnlineRewardData.Builder builder
                = OnlineRewardGMsg.GResInitOnlineRewardData.newBuilder();
        builder.setOnlineTime(onlineReward.getOnlineTime());
        builder.addAllIdxList(onlineRewardService.getOnlineList(onlineReward));

        contextManager.write(role.getId(), CmdCode._25001, builder.build());
    }

    //ADD_HERO 10505014 9
    //ADD_HERO 10505014 5
    //ADD_HERO 10505004 6
    //ADD_HERO 10505010 9
    @GMCommand(command = GMCmdCode.ADD_HERO)
    public void addHero(Role role, List<String> param) {
        int heroType = Integer.parseInt(param.get(0));
        int star = Integer.parseInt(param.get(1));
        CHeroType cHeroType = heroTypeSysCache.getOrThrow(heroType);
        Hero hero = heroService.createHero(role.getId(), cHeroType, star, 0, 0);
        heroService.addHeros(Collections.singletonList(hero));
        eventBus.post(HeroGetEvent.of(role.getId(), Collections.singletonList(hero), GameEvent.GM));
    }

    /**
     * 庇护所商店测试
     * @param role
     * @param param
     */
    @GMCommand(command = GMCmdCode.ADD_SHELTER_SHOP_ITEM)
    public void addShelterShopItem(Role role, List<String> param) {
        int num = Integer.parseInt(param.get(0));
        List<CShelterShopPrize> list = shelterShopPrizeSysCache.getAll();
        List<Integer> list2 = new ArrayList<>();
        for (int i = 0; i < num; i++) {
            CShelterShopPrize cModel = DropUtil.randomDrop(list);
            list2.add(cModel.getIdx());
        }
        log.warn(list2.toString());
    }

   /* @GMCommand(command = GMCmdCode.ADD_SHELTER_ITEM)
    public void addShelterItem(Role role, List<String> param) {
        int item_type = Integer.parseInt(param.get(0));
        int item_num = Integer.parseInt(param.get(1));
        dungeonBackpackService.addItem(role.getId(), item_type, item_num);
        dungeonBackpackService.getDungeonBackpack(role.getId());
    }

    @GMCommand(command = GMCmdCode.ADD_HERO_POINT)
    public void addHeroPoint(Role role, List<String> param) {
        int num = Integer.parseInt(param.get(0));
        List<Integer> list2 = new ArrayList<>();
        // 得到5星英雄池
        List<CLotteryWeight> randomList = lotteryWeightSysCache.getByStar(5);
        for (int i = 0; i < num; i++) {
            CLotteryWeight cLotteryWeight = DropUtil.randomDrop(randomList);
            list2.add(cLotteryWeight.getHero_type());
        }
        log.warn(list2.toString());
    }

    @GMCommand(command = GMCmdCode.ADD_TAVERN_TASK)
    public void addTavernTask(Role role, List<String> param) {

        int num = Integer.parseInt(param.get(0));
        List<Integer> list2 = new ArrayList<>();
        for (int i = 0; i < num; i++) {
            CTavernChance tavernChance = DropUtil.randomDrop(tavernChanceSysCache.getAll());
            List<CTavern> tavernList = tavernSysCache.getByStar(tavernChance.getStar());
            CTavern cTavern = DropUtil.randomDrop(tavernList);
            list2.add(cTavern.getIdx());
        }

    }*/


    @GMCommand(command = GMCmdCode.CHAMPION_NEXT_STAGE)
    public void testChampion(Role role, List<String> param) {
        championService.gmTransformStage();
    }

    @GMCommand(command = GMCmdCode.CHAMPION_CROSS_NEXT_STAGE)
    public void testChampionCross(Role role, List<String> param) {
        ReqChampionCrossGmNextStageBuilder builder = ReqChampionCrossGmNextStage.builder();
        messageDispatcher.dispatch(builder.build());
    }

    @GMCommand(command = GMCmdCode.CHAMPION_BUILD)
    public void championBuild(Role role, List<String> param) {
        championTestHandler.buildTestEnviroment();
    }

    @Autowired
    private VideoHallService videoHallService;

    @GMCommand(command = GMCmdCode.VIDEO_TEST)
    public void videoTest(Role role, List<String> param) {
        List<VideoHall> list = videoHallService.getHalls(VideoType.PVP);
        for (VideoHall hall : list) {
            System.out.println(hall.getBattle_log());
            try {
                BattleGMsg.BattleLog aa = BattleGMsg.BattleLog.parseFrom(hall.getBattle_log().getBytes(VideoConst.ISO));
                System.out.println(aa.getBattleId() + " " + aa.getAttackerLog().getName());
            } catch (InvalidProtocolBufferException e) {
                e.printStackTrace();
            } catch (UnsupportedEncodingException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * 完成通行证当前轮所有任务
     * @param role
     * @param param
     */
    @GMCommand(command = GMCmdCode.TRAFFIC_PERMIT)
    public void trafficPermitTask(Role role, List<String> param) {
        Promotion053TrafficPermit promotion053TrafficPermit = promotion053TrafficPermitService.getPromotionOrRefresh(role.getId());
        Map<Integer, TrafficPermitTaskProgress> dayTaskMap = promotion053TrafficPermit.getDayTask();
        dayTaskMap.forEach((k, v) -> {
            CPromotionTrafficPermit cPromotionTrafficPermit = promotionTrafficPermitSysCache.getOrThrow(k);
            v.setProgress(cPromotionTrafficPermit.getMission().getTarget());
        });
        promotion053TrafficPermit.setDayTask(dayTaskMap);
        Map<Integer, TrafficPermitTaskProgress> weekTaskMap = promotion053TrafficPermit.getWeekTask();
        weekTaskMap.forEach((k, v) -> {
            CPromotionTrafficPermit cPromotionTrafficPermit = promotionTrafficPermitSysCache.getOrThrow(k);
            v.setProgress(cPromotionTrafficPermit.getMission().getTarget());
        });
        promotion053TrafficPermit.setWeekTask(weekTaskMap);
        Map<Integer, TrafficPermitTaskProgress> ultimateTaskMap = promotion053TrafficPermit.getUltimateTask();
        ultimateTaskMap.forEach((k, v) -> {
            CPromotionTrafficPermit cPromotionTrafficPermit = promotionTrafficPermitSysCache.getOrThrow(k);
            v.setProgress(cPromotionTrafficPermit.getMission().getTarget());
        });
        promotion053TrafficPermit.setUltimateTask(ultimateTaskMap);

        promotion053TrafficPermitService.updatePromotion(promotion053TrafficPermit);
    }

    @GMCommand(command = GMCmdCode.ALL_RUNES)
    public void gmAllRuneSkill(Role role, List<String> param) {
        CRunesType cRunesType = runesTypeSysCache.getByType(2000004);

        List<RuneInfo> runeList = new ArrayList<>();
        for (CRuneSkillType cRuneSkillType : runeSkillTypeSysCache.getAll()) {
            RuneDataTemplate runeData = new RuneDataTemplate();
            runeData.setType_id(cRunesType.getType());
            //先随机能力ID
            runeData.setAbility_id(runesAbilitySysCache.randomType());
            RuneSkill runeSkill = new RuneSkill();
            runeSkill.setSort(1);
            runeSkill.setLevel(cRuneSkillType.getLevel());
            runeSkill.setSkillId(cRuneSkillType.getSkill_id());
            runeData.getSkillMap().put(runeSkill.getSort(), runeSkill);

            RuneInfo runeInfo = new RuneInfo();
            runeInfo.setRid(role.getId());
            runeInfo.setTypeId(runeData.getType_id());
            runeInfo.setAbilityId(runeData.getAbility_id());
            runeInfo.setSkillMap(new HashMap<>());
            runeInfo.getSkillMap().putAll(runeData.getSkillMap());
            runeInfo.setWashSkillMap(new HashMap<>());
            runeList.add(runeInfo);
        }
        if (!runeList.isEmpty()) {
            runeInfoService.addRunes(runeList);
            eventBus.post(RuneAddEvent.of(role.getId(), runeList, GameEvent.GM));
        }
        BackPackGMsg.GResBackpackGain.Builder builder = BackPackGMsg.GResBackpackGain.newBuilder();
        builder.setType(NoticeType.SLIENT.getValue());
        for (RuneInfo runeInfo : runeList) {
            PSBackpackData.Builder model = PSBackpackData.newBuilder();
            model.setNum(1);
            model.setType(runeInfo.getTypeId());
            builder.addList(model.build());
        }
        contextManager.write(role.getId(), CmdCode._5002, builder.build());
    }

    @GMCommand(command = GMCmdCode.ADD_ADVENTURE_COUNT)
    public void gmAddAdventureCount(Role role, List<String> param) {
        int adventureCount = Integer.parseInt(param.get(0));
        TavernInfo tavernInfo = tavernInfoService.getTavernInfo(role.getId());
        tavernInfo.setAdventureCount(adventureCount + tavernInfo.getAdventureCount());
        tavernInfoService.updateTavernInfo(tavernInfo);
        PubTaskGMsg.GResPubAdventureCount.Builder builder = PubTaskGMsg.GResPubAdventureCount.newBuilder();
        builder.setAdventureCount(tavernInfo.getAdventureCount());
        contextManager.write(role.getId(), CmdCode._13027, builder.build());
    }

    @GMCommand(command = GMCmdCode.TEST_REFUSE_MAIL)
    public void gmTestRefuseMail(Role role, List<String> param) {
        List<Mail> mails = new ArrayList<>();
        Mail mail1 = mailService.newSimpleMail(role.getId(), MailScene.JIE_RI_HAO_LU, null, GameEvent.GM);
        Mail mail2 = mailService.newSimpleMail(1003000002, MailScene.JIE_RI_HAO_LU, null, GameEvent.GM);
        mails.add(mail1);
        mails.add(mail2);
        mailService.insertMails(mails);
    }

    @GMCommand(command = GMCmdCode.ALL_JEWEL)
    public void gmAllJewel(Role role, List<String> param) {
        List<ImmutableThing> list = new ArrayList<>();
        for (CJewelType cJewelType : jewelTypeSysCache.getAll()) {
            list.add(ImmutableThing.of(cJewelType.getJewel_type(), 100));
        }
        thingService.add(role.getId(), list, GameEvent.GM);
    }

    @GMCommand(command = GMCmdCode.SAN_RI_REN_WU)
    public void addPromotionDay(Role role, List<String> param) {
        PromotionControl promotionControl = promotionControlService.getControl(PromotionType.SAN_RI_REN_WU);
        promotionControl.setStartTime(promotionControl.getStartTime() - TimeConstants.ONE_DAY_SECOND);
        promotionControl.setEndTime(promotionControl.getEndTime() - TimeConstants.ONE_DAY_SECOND);
        promotionControl.setClearTime(promotionControl.getClearTime() - TimeConstants.ONE_DAY_SECOND);
        promotionControl.setNextTime(promotionControl.getNextTime() - TimeConstants.ONE_DAY_SECOND);
        promotionControl.setTurnsTime(promotionControl.getTurnsTime() - TimeConstants.ONE_DAY_SECOND);
        promotionControlService.updateControl(promotionControl);
        for (Promotion061ThreeDayTask promotion061ThreeDayTask : promotion061ThreeDayTaskService.getAllPromotionInfo()) {
            promotion061ThreeDayTask.setTurns(promotionControl.getTurns());
            promotion061ThreeDayTask.setTurnsTime(promotionControl.getTurnsTime());
            promotion061ThreeDayTaskService.updatePromotion(promotion061ThreeDayTask);
        }
    }

    @GMCommand(command = GMCmdCode.CLEAN_GEM)
    public void cleanGem(Role role, List<String> param) {
        thingService.cost(role.getId(), ImmutableThing.of(900002, role.getGem()), GameEvent.GM);
    }

    @GMCommand(command = GMCmdCode.DREAMLAND_END)
    public void dreamlandEnd(Role role, List<String> param) {

        int count = Integer.parseInt(param.get(0));
        HeroLineUp heroLineUp = heroLineUpService.getLineUpByType(role.getId(), LineUpType.DREAMLAND);

        if (heroLineUp.getTime() == 0) {
            HeroLineUp mainHeroLine = heroLineUpService.getLineUpByType(role.getId(), LineUpType.MAIN);

            BattleGMsg.PSLineUpData.Builder psLineUpData = BattleGMsg.PSLineUpData.newBuilder();
            psLineUpData.setType(LineUpType.DREAMLAND.getValue());
            psLineUpData.setTime(DateTimeUtil.currentSecond());
            psLineUpData.setGoddessType(mainHeroLine.getGoddessType());
            psLineUpData.setFormationId(mainHeroLine.getFormationId());
            heroLineUp.getFormationMap().entrySet().forEach(entry -> {
                BattleGMsg.PSLineUpHeroData.Builder hero = BattleGMsg.PSLineUpHeroData.newBuilder();
                hero.setHeroId(entry.getKey());
                hero.setPosition(entry.getValue().getPos());
                Hero hero1 = heroService.getHero(role.getId(), entry.getKey());
                hero.setHp((int) hero1.getHp());
                psLineUpData.addHeroList(hero);
            });
            heroLineUpService.saveLineUpFormation(role.getId(), psLineUpData.build());
        }

        Dreamland dreamland = dreamlandService.loadAndRefresh(role.getId());
        for (int i = 0; i < count; i++) {

            dreamland.setBattleStatus(DreamlandBattleStatus.BATTLE.getValue());

            CDreamlandBuff cDreamlandBuff = RandomUtil.getRand(dreamlandBuffSysCache.getAll());
            dreamland.setCurrBuffId(cDreamlandBuff.getIdx());

            if (dreamlandLevelSysCache.getMaxLv() <= dreamland.getCurLv()) {
                contextManager.writeError(role.getId(), ErrorCode.DREAMLAND_MAX_LV);
                return;
            }

            int battleLv = dreamland.getCurLv() + 1;
            List<CDreamlandLevel> heroConfigs = dreamlandLevelSysCache.getMissionMap().get(battleLv);

            Asserts.notNull(heroConfigs, String.format("下一关英雄配置不存在，当前：{%s}", dreamland.getCurLv()));

            BattlerDo monsterDo = battleTemplate.queryBattler(heroConfigs, String.format("第%s关", battleLv), Faction.DEFENDER, UnitType.MOSTER);

            BattlerDo battlerDo = battleHelper.queryPlayerBattler(LineUpType.DREAMLAND, role.getId(), Faction.ATTACKER);

            BattleResult battleResult = battleHelper.invokeBattle(BattleType.DREAMLAND, battlerDo, monsterDo);

            if (!battleResult.isWin()) {
                contextManager.writeError(role.getId(), ErrorCode.DREAMLAND_BATTLE_DEFEAT);
                return;
            }

            dreamland.setBuffValid(dreamland.getBuffValid() + 1);
            dreamland.setCurLv(battleLv);
            dreamland.setMaxLv(dreamland.getMaxLv() < battleLv ? battleLv : dreamland.getMaxLv());
            dreamland.setTodayMaxLv(battleLv);
            dreamland.setTodayMinLv(battleLv);

            dreamlandService.update(dreamland);

            List<Integer> configMissionList = heroConfigs.stream().map(CDreamlandLevel::getMission_id).collect(Collectors.toList());
            List<Integer> configIdsList = heroConfigs.stream().map(CDreamlandLevel::getIdx).collect(Collectors.toList());
            log.info("-----------------挑战第" + battleLv + "关，战斗结果" + battleResult.isWin() + ",读取的配置为mission：" + configMissionList + ",idx:" + configIdsList);
        }
    }


    @GMCommand(command = GMCmdCode.HERO_ROLLING_RESET)
    public void heroRollingReset(Role role, List<String> param) {
        Promotion065HeroRolling promotionInfo = promotion065HeroRollingService.getPromotionInfo(role.getId());
        promotionInfo.setSummonNum(0);
        promotionInfo.setTriggerNum(0);
        promotionInfo.getRewards().clear();
        promotion065HeroRollingService.updatePromotion(promotionInfo);
    }

    @GMCommand(command = GMCmdCode.TIME_TOWER_RESET)
    public void timeTowerReset(Role role, List<String> param) {
        TowerCrossRole towerCrossRole = towerCrossRoleService.getTower(role.getId());
        towerCrossRole.setFailNum(0);
        towerCrossRoleService.updateTower(towerCrossRole);
    }

    @GMCommand(command = GMCmdCode.TIME_TOWER_REWARD)
    public void timeTowerReward(Role role, List<String> param) {
        ReqTimeTowerGmRewardMessageBuilder builder = ReqTimeTowerGmRewardMessage.builder();
        messageDispatcher.dispatch(builder.build());
    }


    @GMCommand(command = GMCmdCode.RESET_PROMOTION)
    public void resetPromotion(Role role, List<String> param) {
        int promotionType = Integer.parseInt(param.get(0));
        PromotionControl promotionControl = promotionControlService.getControl(PromotionType.valueOf(promotionType));
        promotionControl.setStartTime(promotionControl.getStartTime() + 1);
        promotionControl.setTurnsTime(promotionControl.getStartTime());
        promotionControlService.updateControl(promotionControl);
    }

    @GMCommand(command = GMCmdCode.RECHARGE_GIFT_TIME)
    public void promotionRechargeGift(Role role, List<String> param) {
        Promotion069RechargeGift promotion069RechargeGift = promotion069RechargeGiftService.get(role.getId());
        if (promotion069RechargeGift.getActiveTimeMap().get(0) != null) {
            promotion069RechargeGift.getActiveTimeMap().put(0, promotion069RechargeGift.getActiveTimeMap().get(0) - TimeConstants.ONE_DAY_SECOND);
        }
        if (promotion069RechargeGift.getActiveTimeMap().get(1) != null) {
            promotion069RechargeGift.getActiveTimeMap().put(1, promotion069RechargeGift.getActiveTimeMap().get(1) - TimeConstants.ONE_DAY_SECOND);
        }
        Map<Integer, Integer> map = new HashMap<>();
        for (Map.Entry<Integer, Integer> entry : promotion069RechargeGift.getRewardTimeMap().entrySet()) {
            map.put(entry.getKey(), entry.getValue() - TimeConstants.ONE_DAY_SECOND);
        }
        promotion069RechargeGift.getRewardTimeMap().putAll(map);
        promotion069RechargeGiftService.update(promotion069RechargeGift);
    }

    @GMCommand(command = GMCmdCode.UPDATE_RECHARGE_GIFT_TIME)
    public void updatePromotionActiveTime(Role role, List<String> param) {
        Promotion069RechargeGift promotion069RechargeGift = promotion069RechargeGiftService.get(role.getId());
        promotion069RechargeGift.setOpenTime(DateTimeUtil.dayBreak());
        promotion069RechargeGiftService.update(promotion069RechargeGift);
    }


    @GMCommand(command = GMCmdCode.RESET_ZSJT)
    public void RESET_ZSJT(Role role, List<String> param) {
        Promotion072 promotion072 = promotion072Service.getPromotionInfo(role.getId());
        promotion072.setMoneyDrawNum(0);
        promotion072Service.updatePromotion(promotion072);//更新数据
    }

    @GMCommand(command = GMCmdCode.CLAN_BOSS_BATTLE_TIMES_UPDATE)
    public void CLAN_BOSS_BATTLE_TIMES_UPDATE(Role role, List<String> param) {
        int times = Integer.parseInt(param.get(0));
        ClanBossBattleInfo clBattleNum = clanBossService.selectClanBossBattleNum(role.getId());
        clBattleNum.setPurchaseNum(clBattleNum.getPurchaseNum() + times);
        clBattleNum.setNowBattle(clBattleNum.getNowBattle() + times);
        //更新数据
        clanBossService.updateClanBossBattleInfo(clBattleNum);
    }
}
