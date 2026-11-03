/**
 *
 */
package com.ayjs.mxzg.gameserver.module.hero.handler;

import cn.hutool.core.util.StrUtil;
import com.alibaba.fastjson.JSONArray;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.common.base.IRegister;
import com.ayjs.mxzg.common.command.serivce.CommandBus;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.DropUtil;
import com.ayjs.mxzg.common.util.JsonUtil;
import com.ayjs.mxzg.config.excel.cache.*;
import com.ayjs.mxzg.config.excel.constant.HeroConst;
import com.ayjs.mxzg.config.excel.entity.*;
import com.ayjs.mxzg.config.struct.*;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.Rewards;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.clergy.service.ClergyService;
import com.ayjs.mxzg.gameserver.module.hero.command.QueryHeroCommand;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroSummon;
import com.ayjs.mxzg.gameserver.module.hero.domain.Illustrat;
import com.ayjs.mxzg.gameserver.module.hero.event.*;
import com.ayjs.mxzg.gameserver.module.hero.handler.summon.IHeroSummon;
import com.ayjs.mxzg.gameserver.module.hero.service.*;
import com.ayjs.mxzg.gameserver.module.hero.struct.IllustratData;
import com.ayjs.mxzg.gameserver.module.hero.struct.SummonType;
import com.ayjs.mxzg.gameserver.module.hero.struct.UpStarRequire;
import com.ayjs.mxzg.gameserver.module.recharge.domain.RoleRecharge;
import com.ayjs.mxzg.gameserver.module.recharge.service.RoleRechargeService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.role.service.RoleVipService;
import com.ayjs.mxzg.gameserver.module.rune.service.RuneInfoService;
import com.ayjs.mxzg.gameserver.module.tweakCube.service.TweakCubeService;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.gameserver.module.worldLevel.manager.WorldLevelManager;
import com.ayjs.mxzg.protocol.HeroGMsg;
import com.ayjs.mxzg.protocol.HeroGMsg.*;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.google.common.collect.Lists;
import com.google.common.collect.Sets;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.*;
import java.util.stream.Collectors;

/**
 * @author YY
 *
 */
@Slf4j
@Controller
public class HeroHandler extends ProtocolHandler implements IRegister<IHeroSummon> {

    @Autowired
    private RoleService roleService;
    @Autowired
    private HeroService heroService;
    @Autowired
    private HeroUpGradeSysCache heroUpGradeSysCache;
    @Autowired
    private ThingService thingService;
    @Autowired
    private HeroStarSysCache heroStarSysCache;
    @Autowired
    private HeroLevelSysCache heroLevelSysCache;
    @Autowired
    private LotteryPointSysCache lotteryPointSysCache;
    @Autowired
    private LotteryWeightSysCache lotteryWeightSysCache;
    @Autowired
    private IllustratService illustratService;
    @Autowired
    private SkinSysCache skinSysCache;
    @Autowired
    private HeroSummonService heroSummonService;
    @Autowired
    private HeroTypeSysCache heroTypeSysCache;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private RoleVipService roleVipService;
    @Autowired
    private HeroSpaceSysCache heroSpaceSysCache;
    @Autowired
    private RoleRechargeService roleRechargeService;
    @Autowired
    private SystemSysCache systemSysCache;
    @Autowired
    private HeroRebornSysCache heroRebornSysCache;
    @Autowired
    private HeroSwitchSysCache heroSwitchSysCache;
    @Autowired
    private HeroBackSysCache heroBackSysCache;
    @Autowired
    private HeroLineUpService heroLineUpService;
    @Autowired
    protected PromotionLimitedSetSysCache promotionLimitedSetSysCache;
    @Autowired
    private CommandBus commandBus;
    @Autowired
    private WorldLevelManager worldLevelManager;
    @Autowired
    private ClergyService clergyService;
    @Autowired
    private HeroEvolveService heroEvolveService;
    @Autowired
    private TweakCubeService tweakCubeService;
    @Autowired
    private RuneInfoService runeInfoService;

    private Map<Integer, IHeroSummon> summonMap = new HashMap<>();

    @CMD(id = CmdCode._4001)
    public void getHeroList(PlayerContext playerContext, GReqHeroList msg) {

        Role role = roleService.getOrThrow(playerContext.getId());
        HeroSummon heroSummon = heroSummonService.getHeroSummon(playerContext.getId());

        List<Hero> list = heroService.getHeros(playerContext.getId());

        int page = msg.getPage();

        //Asserts.isTrue(page > 0, ErrorCode.ERROR_PARAM.getValue(), StrUtil.format("page less than 0", page));

        GResHeroList.Builder builder = GResHeroList.newBuilder();
        builder.setHeroCapacity(roleVipService.getHeroCapacity(role.getId()));
        builder.setBuySpaceTimes(heroSummon.getBuySpaceTimes());

        int heroCount = list.size();
        int sendStatus = 1;
        if (heroCount > (page - 1) * systemSysCache.getHeroPageNum()) {
            int end = Math.min(heroCount, page * systemSysCache.getHeroPageNum());
            for (int i = systemSysCache.getHeroPageNum() * (page - 1); i < end; i++) {
                Hero hero = list.get(i);
                if (hero.getHp() == 0) {
                    heroService.computeStrength(hero, GameEvent.HERO_ATTR_FIX);
                }
                builder.addList(heroService.buildHero(hero));
            }
            if (heroCount > page * systemSysCache.getHeroPageNum()) {
                sendStatus = 0;// 未完成
            }
        }
        builder.setSendStatus(sendStatus);
        builder.setPage(page);
        playerContext.write(CmdCode._4001, builder.build());
    }

    @CMD(id = CmdCode._4002)
    public void heroSummon(PlayerContext playerContext, GReqHeroSummon msg) {

        // 抽奖消耗及积分
        CLotteryPoint cLotteryPoint = lotteryPointSysCache.getOrThrow(msg.getType());

        List<Hero> heroList = heroService.getHeros(playerContext.getId());
        // 判断英雄数量是否超过上限

        int heroNum = heroList.size() + cLotteryPoint.getSummon_times();

        Asserts.isTrue(heroNum <= roleVipService.getHeroCapacity(playerContext.getId()), ErrorCode.HERO_NUM_LIMIT.getValue(),
                () -> String.format("heroNum%s ,max hero size:%s", heroNum, roleVipService.getHeroCapacity(playerContext.getId())));

        HeroSummon heroSummon = heroSummonService.getHeroSummon(playerContext.getId());
        List<ImmutableThing> heroThing = new ArrayList<>();

        //根据召唤类型进行召唤
        IHeroSummon iHeroSummon = summonMap.get(cLotteryPoint.getIdx());
        Asserts.isTrue(iHeroSummon.isCanSummon(), ErrorCode.HERO_SUMMON_DISABLE.getValue(), "该类型的英雄召唤功能暂时不可用");
        iHeroSummon.summon(heroSummon, cLotteryPoint, heroThing);

        GResHeroSummon.Builder builder = GResHeroSummon.newBuilder();
        Rewards rewards = thingService.add(playerContext.getId(), heroThing, iHeroSummon.heroGameEvent(), NoticeType.SLIENT);
        for (Hero newHero : rewards.getHeroes()) {
            builder.addList(heroService.buildHero(newHero));
        }

        //发送限时礼包idx
        rewards.getHeroes().forEach(hero -> {
            List<CPromotionLimitedSet> configs = promotionLimitedSetSysCache.getByStar(hero.getStar());
            if (configs != null && !configs.isEmpty()) {
                configs.forEach(cPromotionLimitedSet -> {
                    builder.addIdx(cPromotionLimitedSet.getIdx());
                });
            }
        });

        playerContext.write(CmdCode._4002, builder.build());

        heroSummonService.updateHeroSummon(heroSummon);

        //抛出英雄召唤事件
        eventBus.post(HeroSummonEvent.of(playerContext.getId(),
                SummonType.valueOf(cLotteryPoint.getType()), cLotteryPoint.getSummon_times(), rewards.getHeroes()));
        // 记录积分
        if (!cLotteryPoint.getPoint().isEmpty()) {
            thingService.add(playerContext.getId(), cLotteryPoint.getPoint(), iHeroSummon.heroGameEvent(), NoticeType.SLIENT);
        }
        iHeroSummon.handleAfterSummon(playerContext);
    }

    @CMD(id = CmdCode._4003)
    public void heroDetail(PlayerContext playerContext, GReqHeroDetail msg) {
        Hero hero = heroService.getHero(playerContext.getId(), msg.getHeroId());
        Asserts.isTrue(hero != null, ErrorCode.HERO_NOT_EXIST.getValue(), "没有找到该英雄" + msg.getHeroId());

        QueryHeroCommand command = QueryHeroCommand.createOf(hero);
        commandBus.invoke(command);
        HeroDo heroDo = command.getHeroDo();
        heroDo.initAttribute();

        GResHeroDetail.Builder builder = GResHeroDetail.newBuilder();
        PSHeroDetail.Builder model = PSHeroDetail.newBuilder();

        model.setHeroId(hero.getId());
        model.setAtk(heroDo.getAttributeInfo().getAttribute(AttributeType.ATTACK));
        model.setDef(heroDo.getAttributeInfo().getAttribute(AttributeType.DEFENSE));
        model.setHp(heroDo.getAttributeInfo().getAttribute(AttributeType.MAX_HP));
        model.setSpd(heroDo.getAttributeInfo().getAttribute(AttributeType.SPEED));
        model.setSkillDamage(heroDo.getAttributeInfo().getAttribute(AttributeType.SKILL_DAMAGE));
        model.setPrecision(heroDo.getAttributeInfo().getAttribute(AttributeType.PRECISION_PERCENT));
        model.setBlock(heroDo.getAttributeInfo().getAttribute(AttributeType.BLOCK_PERCENT));
        model.setCrit(heroDo.getAttributeInfo().getAttribute(AttributeType.CRIT_PERCENT));
        model.setCritDamage(heroDo.getAttributeInfo().getAttribute(AttributeType.CRIT_DAMAGE_PERCENT));
        model.setArmor(heroDo.getAttributeInfo().getAttribute(AttributeType.ARMOR_PERCENT));
        model.setFreeControl(heroDo.getAttributeInfo().getAttribute(AttributeType.FREE_CONTROL_PERCENT));
        model.setReduceDamage(heroDo.getAttributeInfo().getAttribute(AttributeType.FINAL_DAMAGE_REDUCE_PERCENT));
        model.setSacredDamage(heroDo.getAttributeInfo().getAttribute(AttributeType.SACRED_DAMAGE_PERCENT));
        model.setDodge(heroDo.getAttributeInfo().getAttribute(AttributeType.DODGE));
        model.setHit(heroDo.getAttributeInfo().getAttribute(AttributeType.HIT));
        model.setControlPercent(heroDo.getAttributeInfo().getAttribute(AttributeType.CONTROL_PERCENT));
        model.setTreatmentPercent(heroDo.getAttributeInfo().getAttribute(AttributeType.TREATMENT_PERCENT));
        model.setResistCritPercent(heroDo.getAttributeInfo().getAttribute(AttributeType.RESIST_CRIT_PERCENT));
        model.setDrive(heroDo.getAttributeInfo().getAttribute(AttributeType.DRIVE));
        model.setIncantation(heroDo.getAttributeInfo().getAttribute(AttributeType.INCANTATION));

        builder.setDetail(model.build());
        playerContext.write(CmdCode._4003, builder.build());
    }

    /**
     * 获取免费时间
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._4004)
    public void pointCount(PlayerContext playerContext, GReqHeroSummonCount msg) {
        HeroSummon heroSummon = heroSummonService.getHeroSummon(playerContext.getId());

        GResHeroSummonCount.Builder builder = GResHeroSummonCount.newBuilder();
        builder.setFreeTime(heroSummon.getFreeTime());
        builder.setSeniorFreeTime(heroSummon.getSeniorFreeTime());
        playerContext.write(CmdCode._4004, builder.build());
    }

    /**
     * 获取累积召唤英雄奖励
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._4005)
    public void heroSummonAward(PlayerContext playerContext, GReqHeroSummonAward msg) {
        Role role = roleService.getOrThrow(playerContext.getId());
        // 累计充值验证
        RoleRecharge roleRecharge = roleRechargeService.getRoleRecharge(playerContext.getId());
        Asserts.isTrue(roleRecharge.getTotalRecharge() >= HeroConst.POINT_SUMMON_RECHARGE_NEED,
                ErrorCode.HERO_RECHARGE_NOT_ENOUGH.getValue(),
                () -> "role total recharge :" + roleRecharge.getTotalRecharge()
                        + " need:" + HeroConst.POINT_SUMMON_RECHARGE_NEED);

        // 判断英雄数量是否超过上限

        List<Hero> heroList = heroService.getHeros(playerContext.getId());
        int heroNum = heroList.size() + 1;
        if (heroNum > roleVipService.getHeroCapacity(playerContext.getId())) {
            playerContext.writeError(ErrorCode.HERO_NUM_LIMIT);
            return;
        }

        CLotteryPoint cLotteryPoint = lotteryPointSysCache.getOrThrow(7);
        // 得到5星英雄池
        List<CLotteryWeight> randomList = lotteryWeightSysCache.getByStar(5);
        CLotteryWeight cLotteryWeight = DropUtil.randomDrop(randomList);
        if (cLotteryWeight == null) {
            // 系统异常
            playerContext.writeError(ErrorCode.HERO_ROLL_MISS);
            return;
        }

        //神职扣除减免
        List<ImmutableThing> costList = clergyService.clergyEarnings(role, ClergyPrivilegeType.POINT_SUMMON, cLotteryPoint.getNeed_item());
        if (costList.isEmpty()) {
            costList = cLotteryPoint.getNeed_item();
        }

        thingService.cost(role.getId(), costList, GameEvent.HERO_SUMMON_AWARD);

        ImmutableThing hero = ImmutableThing.of(cLotteryWeight.getHero_type(), 1);
        Rewards rewards = thingService.add(role.getId(), hero, GameEvent.HERO_SUMMON_AWARD, NoticeType.SLIENT);

        GResHeroSummonAward.Builder builder = GResHeroSummonAward.newBuilder();
        for (Hero newHero : rewards.getHeroes()) {
            builder.addList(heroService.buildHero(newHero));
        }
        playerContext.write(CmdCode._4005, builder.build());
    }

    @CMD(id = CmdCode._4013)
    public void illustratReward(PlayerContext playerContext, GReqIllustratReward msg) {
        GResIllustratReward.Builder builder = GResIllustratReward.newBuilder();

        Illustrat illustrat = illustratService.getIllustrat(playerContext.getId());
        for (IllustratData data : illustrat.getHeros().values()) {
            CSkin cSkin = skinSysCache.getOrThrow(data.getHeroType());
            ResIllustratRewardData.Builder obj = ResIllustratRewardData.newBuilder();
            obj.setHeroType(data.getHeroType());
            List<Integer> starLimits = JSONArray.parseArray(cSkin.getStar_limit(), Integer.class);
            for (Integer starLimit : starLimits) {
                if (data.getStar() <= starLimit) {
                    obj.setStar(starLimit);
                    break;
                }
            }
            builder.addList(obj.build());
        }
        playerContext.write(CmdCode._4013, builder.build());
    }

    /**
     * 英雄上锁、解锁
     *
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._4015)
    public void heroLock(PlayerContext playerContext, GReqHeroLock msg) {
        Asserts.isTrue(msg.getIsLock() == 0 || msg.getIsLock() == 1, ErrorCode.ERROR_PARAM.getValue(),
                "参数错误" + msg.getIsLock());

        Hero hero = heroService.getHero(playerContext.getId(), msg.getHeroId());
        Asserts.isTrue(hero != null, ErrorCode.HERO_NOT_EXIST.getValue(), "没有找到该英雄" + msg.getHeroId());

        hero.setIsLock(msg.getIsLock());
        heroService.updateHero(hero);

        GResHeroLock.Builder builder = GResHeroLock.newBuilder();
        builder.setHeroId(hero.getId());
        builder.setIsLock(hero.getIsLock());
        playerContext.write(CmdCode._4015, builder.build());
    }

    @CMD(id = CmdCode._4018)
    public void heroUpLevel(PlayerContext playerContext, GReqHeroUpLevel msg) {
        Role role = roleService.getOrThrow(playerContext.getId());
        Hero hero = heroService.getHero(playerContext.getId(), msg.getHeroId());
        if (hero == null) {
            // 没有找到该英雄
            playerContext.writeError(ErrorCode.HERO_NOT_EXIST);
            return;
        }
        int upLevel = msg.getUpLevel();
        if (!msg.hasUpLevel()) {
            upLevel = 1;
        }
        int finalUpLevel = upLevel;
        Asserts.isTrue(upLevel > 0 && upLevel <= systemSysCache.getHeroLevelJumpMax(),
                ErrorCode.ERROR_PARAM.getValue(),
                () -> StrUtil.format("hero:{} up level error request up level:{}", hero.getId(), finalUpLevel));

        // 升级后的等级
        CHeroStar cHeroStar = heroStarSysCache.getOrThrow(hero.getStar());
        CHeroUpGrade cHeroUpGrade = heroUpGradeSysCache.getOrThrow(hero.getStage());
        int levelLimit = 0;
        if (hero.getLevel() < heroUpGradeSysCache.getMaxLevel()) {
            levelLimit = cHeroUpGrade.getLevel();
        } else {
            levelLimit = cHeroStar.getLevel_limit();
        }
        if (hero.getLevel() + upLevel > levelLimit) {
            playerContext.writeError(ErrorCode.HERO_LEVEL_LIMIT);
            return;
        }

        int oriLevel = hero.getLevel();
        long needExp = 0;
        long needGold = 0;
        for (int i = 0; i < upLevel; i++) {
            // 升级所需资源
            CHeroLevel cHeroLevel = heroLevelSysCache.getOrThrow(hero.getLevel() + i);
            needExp += cHeroLevel.getExp_need();
            needGold += cHeroLevel.getGold_need();
        }
        List<ImmutableThing> costList = new ArrayList<>();
        costList.add(ImmutableThing.of(ItemType.IT_HERO_EXP, needExp));
        costList.add(ImmutableThing.of(ItemType.IT_GOLD, needGold));
        thingService.cost(role.getId(), costList, GameEvent.HERO_UP_LEVEL);
        hero.setLevel(hero.getLevel() + upLevel);
        heroService.updateHero(hero);

        GResHeroUpLevel.Builder builder = GResHeroUpLevel.newBuilder();
        builder.setHeroId(hero.getId());
        builder.setHeroLevel(hero.getLevel());
        playerContext.write(CmdCode._4018, builder.build());


        //更新战斗力
        eventBus.post(HeroUpLevelEvent.of(hero, GameEvent.HERO_UP_LEVEL, oriLevel, costList, upLevel));
    }

    @CMD(id = CmdCode._4019)
    public void heroUpgrade(PlayerContext playerContext, GReqHeroUpgrade msg) {
        Role role = roleService.getOrThrow(playerContext.getId());

        Hero hero = heroService.getHero(role.getId(), msg.getHeroId());
        if (hero == null) {
            // 没有找到该英雄
            playerContext.writeError(ErrorCode.HERO_NOT_EXIST);
            return;
        }
        if (hero.getStar() < hero.getStage() + 1) {
            // 若升阶后阶级大于星级不给于升阶
            playerContext.writeError(ErrorCode.HERO_STAGE_STAR);
            return;
        }
        if (hero.getStage() >= heroUpGradeSysCache.getMaxGrade()) {
            playerContext.writeError(ErrorCode.HERO_MAX_GRADE);
            return;
        }
        CHeroUpGrade cHeroUpGrade = heroUpGradeSysCache.getOrThrow(hero.getStage());
        if (hero.getLevel() < cHeroUpGrade.getLevel()) {
            // 若等级未到升阶要求
            playerContext.writeError(ErrorCode.HERO_LEVEL_LACK);
            return;
        }

        int oriStage = hero.getStage();

        List<ImmutableThing> costList = new ArrayList<>();
        costList.add(ImmutableThing.of(ItemType.IT_HERO_UP_STONE, cHeroUpGrade.getSoul()));
        costList.add(ImmutableThing.of(ItemType.IT_GOLD, cHeroUpGrade.getGold()));
        thingService.cost(role.getId(), costList, GameEvent.HERO_UP_GRADE);
        hero.setStage(hero.getStage() + 1);
        heroService.updateHero(hero);

        GResHeroUpgrade.Builder builder = GResHeroUpgrade.newBuilder();
        builder.setHeroId(hero.getId());
        builder.setHeroStage(hero.getStage());
        playerContext.write(CmdCode._4019, builder.build());

        // 更新战斗力
        eventBus.post(HeroUpGradeEvent.of(hero, GameEvent.HERO_UP_GRADE, oriStage, costList));
    }

    @CMD(id = CmdCode._4020)
    public void heroUpStar(PlayerContext playerContext, GReqHeroUpStar msg) {
        Set<Long> eleHeroId = new HashSet<>(msg.getListHeroIdList());
        if (eleHeroId.contains(msg.getHeroId())) {
            // 参数有误
            playerContext.writeError(ErrorCode.ERROR_PARAM);
            return;
        }
        if (eleHeroId.size() != msg.getListHeroIdCount()) {
            // 参数有误
            playerContext.writeError(ErrorCode.ERROR_PARAM);
            return;
        }

        // 素材英雄
        List<Hero> eleHeroList = new ArrayList<>();
        for (Long heroId : eleHeroId) {
            Hero subHero = heroService.getUnlockInLineUpHero(playerContext.getId(), heroId);
            if (subHero == null) {
                // 未找到素材英雄
                log.error("英雄升星素材不匹配，没有找到空闲的英雄ID" + heroId);
                playerContext.writeError(ErrorCode.HERO_MUST_IDLE);
                return;
            }
            Asserts.isTrue(subHero.getIsLock() == 0, ErrorCode.HERO_LOCK.getValue(), "该英雄被锁定了");
            eleHeroList.add(subHero);
        }

        List<Long> eleHeroIds = new ArrayList<>(eleHeroId);
        Asserts.isTrue(!heroLineUpService.isHeroDeletes(playerContext.getId(), eleHeroIds), ErrorCode.HERO_CANT_DELETE_LINEUP_ALL.getValue(),
                "不能删除指定阵型上的所有英雄");

        Role role = roleService.getOrThrow(playerContext.getId());
        Hero mainHero = heroService.getHero(role.getId(), msg.getHeroId());
        if (mainHero == null) {
            // 没有找到该英雄
            playerContext.writeError(ErrorCode.HERO_NOT_EXIST, msg.getHeroId());
            return;
        }

        // 验证合成材料是数量是否符合要求
        CHeroStar cHeroStar = heroStarSysCache.getOrThrow(mainHero.getStar());
        if (cHeroStar == null) {
            playerContext.writeError(ErrorCode.HERO_CONFIG_MISS);
            return;
        }

        Asserts.isTrue(role.getLevel() >= cHeroStar.getRole_level_require() || worldLevelManager.getWorldLevel() >= cHeroStar.getWorld_level_require(),
                ErrorCode.HERO_UP_STAR_WORLD_LEVEL.getValue(), "等级要求未达成，无法升星！");

        // 升星
        CHeroType cHeroType = heroTypeSysCache.getOrThrow(mainHero.getType());
        String up_star_list = null;
        if (mainHero.getStar() == 4) {// 根据英雄当前星级获取升星材料
            up_star_list = cHeroType.getTo_5_star();
        } else if (mainHero.getStar() == 5) {
            up_star_list = cHeroType.getTo_6_star();
        } else if (mainHero.getStar() == 6) {
            up_star_list = cHeroType.getTo_7_star();
        } else if (mainHero.getStar() == 7) {
            up_star_list = cHeroType.getTo_8_star();
        } else if (mainHero.getStar() == 8) {
            up_star_list = cHeroType.getTo_9_star();
        } else if (mainHero.getStar() == 9) {
            up_star_list = cHeroType.getTo_10_star();
        } else if (mainHero.getStar() == 10) {
            up_star_list = cHeroType.getTo_11_star();
        } else if (mainHero.getStar() == 11) {
            up_star_list = cHeroType.getTo_12_star();
        } else if (mainHero.getStar() == 12) {
            up_star_list = cHeroType.getTo_13_star();
        } else if (mainHero.getStar() == 13) {
            int count = (int) heroService.getHeros(playerContext.getId()).stream().filter(heroTemp -> heroTemp.getStar() >= HeroConst.NEED_STAR_NUM[0]).count();
            Asserts.isTrue(count >= HeroConst.NEED_STAR_NUM[1],
                    ErrorCode.HERO_STAR_NUM_LOW.getValue(), String.format("星级：{%s},数量：{%s}", HeroConst.NEED_STAR_NUM[0], count));
            up_star_list = cHeroType.getTo_14_star();
        }
        if (up_star_list == null) {
            return;
        }

        List<UpStarRequire> baseList = JSONArray.parseArray(up_star_list, UpStarRequire.class);
        // 修正本体类型与元素匹配的条件
        for (UpStarRequire upStarRequire : baseList) {
            if (upStarRequire.getType() == -1) {
                upStarRequire.setType(mainHero.getType());
            }
            if (upStarRequire.getElem() == -1) {
                upStarRequire.setElem(cHeroType.getElem());
            }
        }
        // 非0的类型在后面，先匹配非0的类型
        baseList.sort(Comparator.comparingInt(UpStarRequire::getType));

        List<Hero> matchHeroList = new ArrayList<>(eleHeroList);
        //替代道具
        Map<Integer, ImmutableThing> costReplaces = new HashMap<>();

        // 先判断符合类型的星级、数量是否满足
        while (baseList.size() > 0) {
            UpStarRequire upStarRequire = baseList.get(baseList.size() - 1);
            if (upStarRequire.getType() == 0) {
                break;
            }

            int needNum = upStarRequire.getNum();
            for (int i = 0; i < needNum; i++) {
                int index = 0;
                while (index < matchHeroList.size()) {
                    Hero matchingHero = matchHeroList.get(index);
                    // 匹配类型跟星级
                    if (matchingHero.getType() == upStarRequire.getType()
                            && upStarRequire.getStar() == upStarRequire.getStar()) {
                        matchHeroList.remove(matchingHero);
                        // 需求数量减-1
                        upStarRequire.setNum(upStarRequire.getNum() - 1);
                        break;
                    }
                    index++;
                }
            }
            if (upStarRequire.getNum() <= 0) {
                baseList.remove(upStarRequire);
            } else {
                if (upStarRequire.getReplace_item() > 0 && isEnoughReplaceItem(playerContext.getId(), upStarRequire, costReplaces)) {
                    baseList.remove(upStarRequire);
                } else {
                    // 素材英雄条件不匹配
                    playerContext.writeError(ErrorCode.HERO_NOT_MATCH);
                    log.error("英雄升星素材不匹配，主英雄ID" + mainHero.getId() + "，素材英雄ID" + eleHeroId.toString() + "，升星条件"
                            + up_star_list + "，当前剩余条件" + JsonUtil.toJson(baseList));
                    return;
                }
            }
        }
        // 非0的元素在后面，先匹配非0的元素
        baseList.sort(Comparator.comparingInt(UpStarRequire::getElem));

        // 再匹配剩下的任意需求是否满足
        while (baseList.size() > 0) {
            UpStarRequire upStarRequire = baseList.get(baseList.size() - 1);

            int needNum = upStarRequire.getNum();
            for (int i = 0; i < needNum; i++) {
                int index = 0;
                while (index < matchHeroList.size()) {
                    Hero matchingHero = matchHeroList.get(index);
                    CHeroType matchingCHeroType = heroTypeSysCache.getOrThrow(matchingHero.getType());
                    // 匹配元素跟星级
                    if ((matchingCHeroType.getElem() == upStarRequire.getElem())
                            && upStarRequire.getStar() == upStarRequire.getStar()) {
                        matchHeroList.remove(matchingHero);
                        // 需求数量减-1
                        upStarRequire.setNum(upStarRequire.getNum() - 1);
                        break;
                    } else if (upStarRequire.getElem() == 0 && upStarRequire.getStar() == upStarRequire.getStar()) {
                        matchHeroList.remove(matchingHero);
                        // 需求数量减-1
                        upStarRequire.setNum(upStarRequire.getNum() - 1);
                        break;
                    }
                    index++;
                }
            }
            if (upStarRequire.getNum() <= 0) {
                baseList.remove(upStarRequire);
            } else {
                if (upStarRequire.getReplace_item() > 0 && isEnoughReplaceItem(playerContext.getId(), upStarRequire, costReplaces)) {
                    baseList.remove(upStarRequire);
                } else {
                    // 素材英雄条件不匹配
                    playerContext.writeError(ErrorCode.HERO_NOT_MATCH);
                    log.error("英雄升星素材不匹配，主英雄ID" + mainHero.getId() + "，素材英雄ID" + eleHeroId.toString() + "，升星条件"
                            + up_star_list + "，当前剩余条件" + JsonUtil.toJson(baseList));
                    return;
                }
            }
        }

        List<ImmutableThing> backRewards = new ArrayList<>();
        for (Hero subHero : eleHeroList) {
            // 补回升级消耗
            for (CHeroLevel cHeroLevel : heroLevelSysCache.getAll()) {
                if (subHero.getLevel() > cHeroLevel.getLevel()) {
                    // 补回金币
                    backRewards.add(ImmutableThing.of(ItemType.IT_GOLD, cHeroLevel.getGold_need()));
                    // 补回经验
                    backRewards.add(ImmutableThing.of(ItemType.IT_HERO_EXP, cHeroLevel.getExp_need()));
                } else {
                    break;
                }
            }
            // 补回升阶消耗
            for (CHeroUpGrade cHeroUpGrade : heroUpGradeSysCache.getAll()) {
                if (subHero.getStage() > cHeroUpGrade.getGrade()) {
                    // 补回升阶资源
                    backRewards.add(ImmutableThing.of(ItemType.IT_HERO_UP_STONE, cHeroUpGrade.getSoul()));
                    backRewards.add(ImmutableThing.of(ItemType.IT_GOLD, cHeroUpGrade.getGold()));
                }
            }
        }
        backRewards = ImmutableThingUtil.mergeThing(backRewards);

        List<ImmutableThing> finalCostList = new ArrayList<>();
        finalCostList.addAll(cHeroStar.getUpstar_cost());
        finalCostList.addAll(costReplaces.values());
        if (!cHeroStar.getNeed_item().isEmpty()) {
            finalCostList.addAll(cHeroStar.getNeed_item());
        }

        finalCostList = ImmutableThingUtil.mergeThing(finalCostList);

        if (ImmutableThingUtil.getAllItemNums(finalCostList) > 0) {
            thingService.cost(role.getId(), finalCostList, GameEvent.HERO_UP_STAR);
        }

        int oriStar = mainHero.getStar();
        heroService.deleteHeros(role.getId(), eleHeroList, GameEvent.HERO_UP_STAR);
        mainHero.setStar(mainHero.getStar() + 1);
        heroService.updateHero(mainHero);

        GResHeroUpStar.Builder builder = GResHeroUpStar.newBuilder();
        if (ImmutableThingUtil.getAllItemNums(backRewards) > 0) {
            Rewards gotList = thingService.add(role.getId(), backRewards, GameEvent.HERO_UP_STAR,
                    NoticeType.SLIENT);
            builder.addAllItemList(PbUtil.buildReward(gotList.getThingSet().asList()));
        }

        builder.setHeroId(mainHero.getId());
        builder.setHeroStar(mainHero.getStar());
        if (tweakCubeService.isInTrench(role.getId(), mainHero.getId())) {
            int[] tweakCubeLvAndStage = tweakCubeService.getTweakCubeLvAndStage(mainHero);
            builder.setTweakCubeLv(tweakCubeLvAndStage[0]);
            builder.setTweakCubeStage(tweakCubeLvAndStage[1]);
        }

        playerContext.write(CmdCode._4020, builder.build());

        eventBus.post(HeroStarUpEvent.of(mainHero, GameEvent.HERO_UP_STAR, oriStar, cHeroStar.getUpstar_cost(), backRewards, eleHeroList));
    }

    /**
     * 替代道具是否足够
     * @param rid
     * @param upStarRequire
     * @param costReplaces
     * @return
     */
    private boolean isEnoughReplaceItem(long rid, UpStarRequire upStarRequire, Map<Integer, ImmutableThing> costReplaces) {
        ImmutableThing replaceItem = costReplaces.get(upStarRequire.getReplace_item());
        if (replaceItem == null) {
            replaceItem = ImmutableThing.of(upStarRequire.getReplace_item(), upStarRequire.getNum());
        } else {
            replaceItem = ImmutableThing.of(upStarRequire.getReplace_item(), replaceItem.getItem_num() + upStarRequire.getNum());
        }
        costReplaces.put(replaceItem.getItem_type(), replaceItem);
        return thingService.enough(rid, replaceItem);
    }


    /**
     * 增加英雄背包上限
     */
    @CMD(id = CmdCode._4027)
    public void heroAddSpace(PlayerContext playerContext, GReqShopBuyHeroCapacity msg) {

        HeroSummon heroSummon = heroSummonService.getHeroSummon(playerContext.getId());

        Asserts.isTrue(heroSummon.getBuySpaceTimes() < heroSpaceSysCache.getMaxTimes(), ErrorCode.BUY_SPACE_MAX_TIMES.getValue(),
                () -> String.format("buyTimes:%s, max times:%s", heroSummon.getBuySpaceTimes(), heroSpaceSysCache.getMaxTimes()));

        CHeroSpace heroSpace = heroSpaceSysCache.getOrThrow(heroSummon.getBuySpaceTimes() + 1);

        Role role = roleService.getOrThrow(playerContext.getId());
        thingService.cost(role.getId(), heroSpace.getPrize(), GameEvent.INCREASE_HERO);

        heroSummon.setBuySpaceTimes(heroSummon.getBuySpaceTimes() + 1);
        heroSummonService.updateHeroSummon(heroSummon);
        role.setHeroNum(role.getHeroNum() + heroSpace.getSpace());
        roleService.updateRole(role);

        GResShopBuyHeroCapacity.Builder builder = GResShopBuyHeroCapacity.newBuilder();
        builder.setHeroCapacity(roleVipService.getHeroCapacity(playerContext.getId()));
        builder.setBuySpaceTimes(heroSummon.getBuySpaceTimes());
        playerContext.write(CmdCode._4027, builder.build());
    }

    @Override
    public void registerBean(IHeroSummon bean) {
        if (summonMap.containsKey(bean.summonType())) {
            throw new RuntimeException("英雄召唤方式" + bean.summonType() + "处理器重复注册");
        }
        summonMap.put(bean.summonType(), bean);
    }

    /**
     * 英雄重生
     * @param playerContext
     */
    @CMD(id = CmdCode._4036)
    public void heroReborn(PlayerContext playerContext, HeroGMsg.GReqHeroReborn msg) {
        HeroGMsg.GResHeroReborn.Builder builder = HeroGMsg.GResHeroReborn.newBuilder();

        Hero hero = heroService.getHero(playerContext.getId(), msg.getHeroId());
        Asserts.notNull(hero, ErrorCode.HERO_NOT_EXIST.getValue(), () -> String.format("找不到英雄数据，heroId:%s,rid:%s", msg.getHeroId(), playerContext.getId()));
        Asserts.isTrue(hero.getIsLock() == 0, ErrorCode.HERO_LOCK.getValue(), "该英雄被锁定了");

        CHeroReborn cHeroReborn = heroRebornSysCache.getConfig(hero.getType(), hero.getStar());

        List<Hero> heroList = Lists.newArrayList(hero);
        Asserts.isTrue(!heroLineUpService.isHeroLockInLineUp(playerContext.getId(), hero.getId()), ErrorCode.HERO_CANT_DELETE_LINEUP.getValue(), "英雄" + hero.getId() + "还在阵上，不能删除");
        Asserts.isTrue(!tweakCubeService.isInTrench(playerContext.getId(), hero.getId()),
                ErrorCode.TWEAK_CUBE_TRENCH_HERO_CANT_OPERATOR.getValue(),
                String.format("槽位上的英雄{%s}不允许该操作", hero.getId()));

        List<Long> heroIds = Lists.newArrayList(msg.getHeroId());
        Asserts.isTrue(!heroLineUpService.isHeroDeletes(playerContext.getId(), heroIds),
                ErrorCode.HERO_CANT_DELETE_LINEUP_ALL.getValue(), "不能删除指定阵型上的所有英雄");

        //计算返回的资源
        List<ImmutableThing> rewardList = heroService.heroCost(hero, 1, 0, 6);
        rewardList.addAll(cHeroReborn.getReback_elem_chip());
        rewardList.addAll(cHeroReborn.getReback_hero_chip());
        rewardList = ImmutableThingUtil.mergeThing(rewardList);

        thingService.cost(playerContext.getId(), cHeroReborn.getCost(), GameEvent.HERO_REBORN);
        heroService.deleteHeros(playerContext.getId(), heroList, GameEvent.HERO_REBORN);

        thingService.add(playerContext.getId(), rewardList, GameEvent.HERO_REBORN);

        builder.setStatus(1);
        playerContext.write(CmdCode._4036, builder.build());

    }

    /**
     * 英雄置换信息
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._4037)
    public void heroSwitch(PlayerContext playerContext, HeroGMsg.GReqSwitchInfo msg) {
        List<CHeroSwitch> list = heroSwitchSysCache.getAll();
        List<Hero> heroList = list.stream().flatMap(
                hero -> heroService.selectHeroListBy(playerContext.getId(), hero.getElem(), hero.getStar()).stream())
                .collect(Collectors.toList());

        GResSwitchInfo.Builder builder = GResSwitchInfo.newBuilder();
        for (Hero hero : heroList) {
            builder.addHero(buildHeroIfLineUp(hero));
        }
        playerContext.write(CmdCode._4037, builder.build());
    }

    /**
     * 根据选择的英雄请求可以置换的列表
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._4038)
    public void heroSwatchTarget(PlayerContext playerContext, HeroGMsg.GReqSwitchTargetList msg) {
        Hero target = heroService.getHero(playerContext.getId(), msg.getHeroId());
        Asserts.notNull(target, ErrorCode.HERO_NOT_EXIST.getValue(), String.format("英雄未找到heroId:%s", msg.getHeroId()));

        CHeroType cHeroType = heroTypeSysCache.getOrThrow(target.getType());

        CHeroSwitch heroSwatch = heroSwitchSysCache.getConfigOrThrow(cHeroType.getElem(), target.getStar());
        List<Hero> heroList = heroSwatch.getElem_target().stream()
                .flatMap(elem -> heroService
                        .selectHeroListBy(playerContext.getId(), elem, HeroConst.HERO_SWITCH_MATERIAL_STAR).stream())
                .filter(hero -> heroTypeSysCache.isCanUpStar(hero.getType(), HeroConst.HERO_SWITCH_TARGET_MIN_STAR))
                .filter(hero -> hero.getType() != target.getType()).collect(Collectors.toList());

        GResSwitchTargetList.Builder builder = GResSwitchTargetList.newBuilder();
        for (Hero hero : heroList) {
            builder.addHero(buildHeroIfLineUp(hero));
        }
        playerContext.write(CmdCode._4038, builder.build());
    }

    /**
     * 置换英雄
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._4039)
    public void heroSwitch(PlayerContext playerContext, HeroGMsg.GReqSwitch msg) {
        Hero hero = heroService.getHero(playerContext.getId(), msg.getHeroId());
        Asserts.notNull(hero, ErrorCode.HERO_NOT_EXIST.getValue(), String.format("英雄未找到heroId:%s", msg.getHeroId()));
        Asserts.isTrue(!heroLineUpService.isHeroLockInLineUp(hero.getRid(), hero.getId()), ErrorCode.HERO_LOCKIN_LINEUP.getValue(), "英雄已经上阵");
        Asserts.isTrue(!tweakCubeService.isInTrench(playerContext.getId(), hero.getId()),
                ErrorCode.TWEAK_CUBE_TRENCH_HERO_CANT_OPERATOR.getValue(),
                String.format("槽位上的英雄{%s}不允许该操作", hero.getId()));
        Asserts.isTrue(hero.getIsLock() == 0, ErrorCode.HERO_LOCK.getValue(), "该英雄被锁定了");
        CHeroType mainHeroType = heroTypeSysCache.getOrThrow(hero.getType());

        CHeroSwitch heroSwitch = heroSwitchSysCache.getConfigOrThrow(mainHeroType.getElem(), hero.getStar());
        Set<Long> targetIds = Sets.newHashSet(msg.getTargetHeroIdList());
        Asserts.isTrue(targetIds.size() == heroSwitch.getNeed_hero(), ErrorCode.NOT_ENOUGH_HEROES_SELECTED.getValue(), String.format("选择的英雄数量不匹配:%s", msg.getHeroId()));

        List<Hero> targets = targetIds.stream().map(heroId -> heroService.getHero(playerContext.getId(), heroId)).collect(Collectors.toList());
        Set<Integer> types = targets.stream().map(Hero::getType).collect(Collectors.toSet());
        Asserts.isTrue(types.size() == 1, ErrorCode.MUST_CHOOSE_THE_SAME_HERO.getValue(), String.format("必须全部选择同样的英雄:%s", types));

        CHeroType cHeroType = heroTypeSysCache.getOrThrow(types.iterator().next());
        Asserts.isTrue(heroSwitch.getElem_target().contains(cHeroType.getElem()), ErrorCode.SWATCH_HERO_ELEMENT_ILLEGAL.getValue(), "置换的英雄不合法");
        Asserts.isTrue(cHeroType.getType() != hero.getType(), ErrorCode.CANT_SWITCH_MYSELF.getValue(), "不能置换自己");

        boolean canUpStar = heroTypeSysCache.isCanUpStar(hero.getType(), HeroConst.HERO_SWITCH_TARGET_MIN_STAR);
        Asserts.isTrue(canUpStar, ErrorCode.SWATCH_HERO_CANNOT_RISE_10_STAR.getValue(), "置换的英雄不能升10星");

        boolean allMatch = targets.stream().allMatch(target -> target.getStar() == 5);
        Asserts.isTrue(allMatch, ErrorCode.MUST_CHOOSE_THE_SAME_HERO.getValue(), "必须全部选择5星英雄");

        Asserts.isTrue(!heroLineUpService.isHeroDeletes(playerContext.getId(), msg.getTargetHeroIdList()),
                ErrorCode.HERO_CANT_DELETE_LINEUP_ALL.getValue(), "不能删除指定阵型上的所有英雄");

        thingService.cost(playerContext.getId(), heroSwitch.getCost(), GameEvent.HERO_SWITCH);
        heroService.deleteHeros(playerContext.getId(), targets, GameEvent.HERO_SWITCH);

        heroEvolveService.evolveBack(hero, NoticeType.SLIENT);

        int oriType = hero.getType();
        hero.setType(cHeroType.getType());
        hero.setFashionId(0);
        heroService.updateHero(hero);

        GResSwitch.Builder builder = GResSwitch.newBuilder();
        builder.setHero(heroService.buildHero(hero));
        playerContext.write(CmdCode._4039, builder.build());

        // 记录日志
        List<Long> deleteIds = targets.stream().map(Hero::getId).collect(Collectors.toList());
        eventBus.post(HeroSwitchEvent.of(hero, GameEvent.HERO_SWITCH, oriType, heroSwitch.getCost(), deleteIds));
    }

    /**
     * 请求回退英雄列表
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._4040)
    public void heroComeBackInfo(PlayerContext playerContext, HeroGMsg.GReqComeBackInfo msg) {
        List<CHeroBack> list = heroBackSysCache.getAll().stream().filter(config -> config.getEvolve_level() == 0)
                .collect(Collectors.toList());
        List<Hero> heroList = list.stream().flatMap(
                hero -> heroService.selectHeroListBy(playerContext.getId(), hero.getElem(), hero.getStar()).stream())
                .collect(Collectors.toList());

        GResComeBackInfo.Builder builder = GResComeBackInfo.newBuilder();
        for (Hero hero : heroList) {
            builder.addHero(buildHeroIfLineUp(hero));
        }
        playerContext.write(CmdCode._4040, builder.build());
    }

    private ResHeroData buildHeroIfLineUp(Hero hero) {
        CHeroType cHeroType = heroTypeSysCache.getOrThrow(hero.getType());
        ResHeroData.Builder builder = ResHeroData.newBuilder();
        builder.setHeroId(hero.getId());
        builder.setHeroType(hero.getType());
        builder.setLevel(hero.getLevel());
        builder.setStage(hero.getStage());
        builder.setStar(hero.getStar());
        builder.setElem(cHeroType.getElem());
        builder.setOccupation(cHeroType.getOccupation());
        builder.setIsLock(hero.getIsLock() == 1 || heroLineUpService.isHeroLockInLineUp(hero.getRid(), hero.getId()) ||
                tweakCubeService.isInTrench(hero.getRid(), hero.getId()) ? 1 : 0);
        builder.setFighting(hero.getFighting());
        int[] tweakCubeLv = tweakCubeService.getTweakCubeLvAndStage(hero);
        builder.setTweakCubeLv(tweakCubeLv[0]);
        builder.setTweakCubeStage(tweakCubeLv[1]);
        return builder.build();
    }

    /**
     * 请求回退
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._4041)
    public void heroComeBack(PlayerContext playerContext, HeroGMsg.GReqComeBack msg) {
        Hero hero = heroService.getHero(playerContext.getId(), msg.getHeroId());
        Asserts.notNull(hero, ErrorCode.HERO_NOT_EXIST.getValue(), String.format("英雄未找到heroId:%s", msg.getHeroId()));
        Asserts.isTrue(!heroLineUpService.isHeroLockInLineUp(hero.getRid(), hero.getId()), ErrorCode.HERO_LOCKIN_LINEUP.getValue(), "英雄已经上阵");
        Asserts.isTrue(!tweakCubeService.isInTrench(playerContext.getId(), hero.getId()),
                ErrorCode.TWEAK_CUBE_TRENCH_HERO_CANT_OPERATOR.getValue(),
                String.format("槽位上的英雄{%s}不允许该操作", hero.getId()));
        Asserts.isTrue(hero.getStar() > HeroConst.HERO_COME_BACK_STAR, ErrorCode.HERO_LOCKIN_LINEUP.getValue(), "英雄已经上阵");
        Asserts.isTrue(hero.getIsLock() == 0, ErrorCode.HERO_LOCK.getValue(), "该英雄被锁定了");

        CHeroType cHeroType = heroTypeSysCache.getOrThrow(hero.getType());
        CHeroBack heroBack = heroBackSysCache.getConfigOrThrow(cHeroType.getElem(), hero.getStar(), hero.getEvolve().getLevel());
        thingService.cost(playerContext.getId(), heroBack.getCost(), GameEvent.HERO_COME_BACK);

        CHeroStar heroStar = heroStarSysCache.getOrThrow(HeroConst.HERO_COME_BACK_STAR);
        int targetLv = Math.min(hero.getLevel(), heroStar.getLevel_limit());
        ImmutableThing reward = ImmutableThing.of(cHeroType.getItem_id(), heroBack.getReback_hero_chip_num());
        List<ImmutableThing> backReward = heroService.heroCost(hero, targetLv, hero.getStage(), HeroConst.HERO_COME_BACK_STAR);
        backReward.add(reward);
        backReward.addAll(heroBack.getReback_item());

        int oriLevel = hero.getLevel();
        int oriStar = hero.getStar();
        hero.setLevel(targetLv);
        hero.setStar(HeroConst.HERO_COME_BACK_STAR);
        hero.getEvolve().reset();
        heroService.updateHero(hero);

        backReward = ImmutableThingUtil.mergeThing(backReward);
        thingService.add(playerContext.getId(), backReward, GameEvent.HERO_COME_BACK);

        GResComeBack.Builder builder = GResComeBack.newBuilder();
        builder.setHero(heroService.buildHero(hero));
        playerContext.write(CmdCode._4041, builder.build());

        eventBus.post(HeroComebackEvent.of(hero, GameEvent.HERO_COME_BACK, oriStar, oriLevel, heroBack.getCost(), backReward));
    }

    /**
     * 选择操作的英雄
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._4042)
    public void choose(PlayerContext playerContext, HeroGMsg.GReqChoose msg) {
        Hero hero = heroService.getHero(playerContext.getId(), msg.getHeroId());
        Asserts.notNull(hero, ErrorCode.HERO_NOT_EXIST.getValue(), String.format("英雄未找到heroId:%s", msg.getHeroId()));
        int lockLineUpType = heroLineUpService.getHeroLockInLineUp(hero.getRid(), hero.getId());
        GResChoose.Builder builder = GResChoose.newBuilder();
        builder.setLineUpType(lockLineUpType);
        playerContext.write(CmdCode._4042, builder.build());
    }


    /**
     * 英雄等级重生
     *
     * @param playerContext
     */
    @CMD(id = CmdCode._4043)
    public void levelReset(PlayerContext playerContext, HeroGMsg.GReqHeroLevelReset msg) {

        Hero hero = heroService.getHero(playerContext.getId(), msg.getHeroId());
        Asserts.notNull(hero, ErrorCode.HERO_NOT_EXIST.getValue(),
                () -> String.format("找不到英雄数据，heroId:%s,rid:%s", msg.getHeroId(), playerContext.getId()));
        Asserts.isTrue(hero.getIsLock() == 0, ErrorCode.HERO_LOCK.getValue(),
                () -> String.format("该英雄被锁定了 heroId:%s", hero.getId()));
        Asserts.isTrue(hero.getStar() <= HeroConst.HERO_LEVEL_RESET_LIMIT,
                ErrorCode.HERO_LEVEL_RESET_LIMIT.getValue(),
                () -> String.format("英雄重生等级错误，heroId:%s,level:%s", msg.getHeroId(), hero.getStar()));

        Asserts.isTrue(!heroLineUpService.isHeroLockInLineUp(playerContext.getId(), hero.getId()),
                ErrorCode.HERO_CANT_DELETE_LINEUP.getValue(),
                () -> String.format("英雄，heroId:%s还在阵上，不能删除", msg.getHeroId(), hero.getLevel()));
        Asserts.isTrue(!tweakCubeService.isInTrench(playerContext.getId(), hero.getId()),
                ErrorCode.TWEAK_CUBE_TRENCH_HERO_CANT_OPERATOR.getValue(),
                () -> String.format("槽位上的英雄{%s}不允许该操作", hero.getId()));

        List<Long> heroIds = Lists.newArrayList(msg.getHeroId());
        Asserts.isTrue(!heroLineUpService.isHeroDeletes(playerContext.getId(), heroIds),
                ErrorCode.HERO_CANT_DELETE_LINEUP_ALL.getValue(),
                () -> String.format("不能删除指定阵型上的所有英雄 heroId:%s", msg.getHeroId(), hero.getLevel()));

        //计算返回的资源
        List<ImmutableThing> rewardList = heroService.heroCostByLevel(hero, 1, 0);
        rewardList = ImmutableThingUtil.mergeThing(rewardList);

        HeroSummon heroSummon = heroSummonService.getHeroSummon(playerContext.getId());
        if (heroSummon.getLevelResetTimes() >= HeroConst.HERO_LEVEL_RESET_DAILY_FREE_TIMES) {
            thingService.cost(playerContext.getId(), HeroConst.HERO_LEVEL_RESET_COST, GameEvent.HERO_REBORN);
        }

        runeInfoService.clearHeroRunes(playerContext.getId(), Collections.singletonList(hero));
        hero.setLevel(1);
        hero.setStage(0);
        heroService.updateHero(hero);

        heroSummon.setLevelResetTimes(heroSummon.getLevelResetTimes() + 1);
        heroSummonService.updateHeroSummon(heroSummon);

        thingService.add(playerContext.getId(), rewardList, GameEvent.HERO_LEVEL_RESET);

        HeroGMsg.GResHeroLevelReset.Builder builder = HeroGMsg.GResHeroLevelReset.newBuilder();
        builder.setHeroId(hero.getId());
        builder.setHeroLevel(hero.getLevel());
        playerContext.write(CmdCode._4043, builder.build());

        eventBus.post(HeroLevelReset.of(hero));
    }

    @CMD(id = CmdCode._4044)
    public void levelResetTimes(PlayerContext playerContext, HeroGMsg.GReqHeroLevelResetTimes msg) {
        GResHeroLevelResetTimes.Builder builder = GResHeroLevelResetTimes.newBuilder();
        HeroSummon heroSummon = heroSummonService.getHeroSummon(playerContext.getId());
        int levelResetTimes = heroSummon.getLevelResetTimes();
        builder.setTimes(levelResetTimes);
        playerContext.write(CmdCode._4044, builder.build());
    }
}
