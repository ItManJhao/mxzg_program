/**
 *
 */
package com.ayjs.mxzg.gameserver.module.adven.service;

import cn.hutool.core.collection.CollectionUtil;
import cn.hutool.core.util.RandomUtil;
import com.ayjs.mxzg.battle.command.HeroInitCommand;
import com.ayjs.mxzg.battle.model.BattleType;
import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.Faction;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.model.mirror.BattlerVo;
import com.ayjs.mxzg.battle.model.mirror.HeroVo;
import com.ayjs.mxzg.common.command.serivce.CommandBus;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.GJsonUtils;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.common.util.time.TimeConstants;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.AdventureRobotRoleSysCache;
import com.ayjs.mxzg.config.excel.cache.AdventureRobotSysCache;
import com.ayjs.mxzg.config.excel.cache.AdventurerewardSysCache;
import com.ayjs.mxzg.config.excel.cache.HeroTypeSysCache;
import com.ayjs.mxzg.config.excel.cache.SystemSysCache;
import com.ayjs.mxzg.config.excel.entity.CAdventureRobot;
import com.ayjs.mxzg.config.excel.entity.CAdventureRobotRole;
import com.ayjs.mxzg.config.excel.entity.CAdventurereward;
import com.ayjs.mxzg.config.excel.entity.CHeroType;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.config.struct.LineUpType;
import com.ayjs.mxzg.gameserver.module.adven.constant.AdvenDefendType;
import com.ayjs.mxzg.gameserver.module.adven.constant.AdvenLvType;
import com.ayjs.mxzg.gameserver.module.adven.dao.AdvenMissionDao;
import com.ayjs.mxzg.gameserver.module.adven.domain.AdvenMission;
import com.ayjs.mxzg.gameserver.module.adven.domain.AdvenMissionData;
import com.ayjs.mxzg.gameserver.module.adven.event.AdvenBoxEvent;
import com.ayjs.mxzg.gameserver.module.adven.event.AdvenPassEvent;
import com.ayjs.mxzg.gameserver.module.adven.struct.AdvenSelectAssist;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.battle.BattleHelper;
import com.ayjs.mxzg.gameserver.module.hero.command.QueryHerosCommand;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroLineUp;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroLineUpService;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.mail.constant.MailScene;
import com.ayjs.mxzg.gameserver.module.mail.service.MailService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.module.battle.BattleTemplate;
import com.ayjs.mxzg.protocol.AdvenGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * @author YY
 *
 */
@Slf4j
@Service
public class AdvenMissionService {

    @Autowired
    private AdvenMissionDao advenMissionDao;
    @Autowired
    private AdventurerewardSysCache adventurerewardSysCache;
    @Autowired
    private RoleService roleService;
    @Autowired
    private HeroLineUpService heroLineUpService;
    @Autowired
    private AdventureRobotSysCache adventureRobotSysCache;
    @Autowired
    private AdventureRobotRoleSysCache adventureRobotRoleSysCache;
    @Autowired
    private BattleHelper battleHelper;
    @Autowired
    private ThingService thingService;
    @Autowired
    private HeroTypeSysCache heroTypeSysCache;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private BattleTemplate battleTemplate;
    @Autowired
    private HeroService heroService;
    @Autowired
    private CommandBus commandBus;
    @Autowired
    private MailService mailService;
    @Autowired
    private SystemSysCache systemSysCache;
    // 找可能对手上限,在这个数量的结果集中随机
    private static int FIND_DEFENSE_LIMIT = 200;
    //战力扩张（百分数）
    private static int FIGHTING_EXPAND_RATE = 10;

    /***
     * 获取试炼数据,会创建和隔天重置对象
     * @param rid
     * @return
     */
    public AdvenMission getAdvenMission(long rid) {
        return getAdvenMission(rid, true);
    }

    /***
     * 获取试炼对象
     * @param rid
     * @param createOrReset
     *          是否创建和隔天重置
     * @return
     */
    public AdvenMission getAdvenMission(long rid, boolean createOrReset) {
        AdvenMission advenMission = advenMissionDao.get(rid);
        if (!createOrReset)
            return advenMission;
        if (advenMission == null) {
            advenMission = createAdvenMission(rid);
        } else {
            resetAdvenMission(advenMission);
        }
        return advenMission;
    }

    /**
     * 初始化试炼数据
     *
     * @param rid
     * @return
     */
    public AdvenMission createAdvenMission(long rid) {
        AdvenMission advenMission = new AdvenMission();
        advenMission.setRid(rid);
        advenMission.setMissionId(1);
        advenMission.setMissionData(new HashMap<>());
        advenMission.setHeroHpRecord(new HashMap<>());
        advenMission.setNextResetTime(DateTimeUtil.tomorrowBreak());
        advenMission.setReceivedMissionId(new HashSet<>());
        advenMission.setLvTime(0);
        advenMission.setLv(AdvenLvType.NORMAL.getLv());
        advenMissionDao.add(advenMission);
        matchDefender(advenMission, advenMission.getMissionId());
        return advenMission;
    }

    /**
     * 匹配对手
     *
     * @param advenMission
     * @param missionId
     */
    public void matchDefender(AdvenMission advenMission, int missionId) {

        Map<Integer, AdvenMissionData> missionData = advenMission.getMissionData();
        AdvenMissionData advenMissionData = missionData.get(missionId);
        if (Objects.isNull(advenMissionData)) {
            advenMissionData = new AdvenMissionData();
            advenMissionData.setState((byte) 0);
            advenMissionData.setMissionId(missionId);
            missionData.put(missionId, advenMissionData);
        }
        // 需要过滤的Rid
        Set<Long> filterRid = new HashSet<>();
        Set<String> filterNick = new HashSet<>();
        filterRid.add(advenMission.getRid());
        for (AdvenMissionData data : missionData.values()) {
            if (Objects.isNull(data) || data.getDefRid() <= 0) {
                continue;
            }
            filterRid.add(data.getDefRid());
            filterNick.add(data.getDefNick());
        }

        Role role = roleService.getOrThrow(advenMission.getRid());

        CAdventurereward cAdventurereward = adventurerewardSysCache.getConfigByMissionIdAndLv(missionId, advenMission.getLv());
        int lowFighting = (int) (role.getMaxFighting() / 100.0 * cAdventurereward.getEnemy_rate_low());
        int upFighting = (int) (role.getMaxFighting() / 100.0 * cAdventurereward.getEnemy_rate_up());
        int fightingExpand = (int) (role.getMaxFighting() / 100.0 * FIGHTING_EXPAND_RATE);

        List<Role> allRole = roleService.getAllRole();
        if (allRole.isEmpty()) {
            log.warn("role is empty");
            return;
        }
        // 新号第一天全部匹配机器人
        List<Role> targetRoles = new ArrayList<>();
        if (!DateTimeUtil.isSameDate((int) (role.getCreateTime() / TimeConstants.ONE_SECOND_MILLIS), DateTimeUtil.currentSecond())) {
            int loop = 0;
            int minRate = cAdventurereward.getEnemy_rate_low();
            int maxRate = cAdventurereward.getEnemy_rate_up();
            while (targetRoles.size() == 0 && (minRate > 0 || maxRate < 100)) {
                minRate -= loop * FIGHTING_EXPAND_RATE;
                maxRate += loop * FIGHTING_EXPAND_RATE;
                int lowFightingTemp = (int) (role.getMaxFighting() / 100.0 * (minRate < 0 ? 0 : minRate));
                int upFightingTemp = (int) (role.getMaxFighting() / 100.0 * (maxRate > 100 ? 100 : maxRate));
                targetRoles = allRole.stream()
                        .filter(r -> r.getFighting() > 0
                                && r.getFighting() >= lowFightingTemp
                                && r.getFighting() <= upFightingTemp
                                && !filterRid.contains(r.getId())
                                && r.getId() != role.getId())
                        .limit(FIND_DEFENSE_LIMIT).collect(Collectors.toList());
                loop++;
            }
        }


        BattlerDo battlerDo = null;
        if (targetRoles.isEmpty()) {
            // 匹配机器人
            String robotNick = roleService.randomNick(filterNick);
            advenMissionData.setDefNick(robotNick);
            advenMissionData.setDefType((byte) AdvenDefendType.Robot.getValue());

            CAdventureRobotRole robotRole = matchRobot(lowFighting, upFighting);
            Asserts.notNull(robotRole, ErrorCode.CONFIG_NOT_EXISTS.getValue(),
                    () -> String.format("Fighting:%s not match robot", role.getFighting()));

            advenMissionData.setDefLevel(robotRole.getLevel());
            advenMissionData.setDefHeadId(robotRole.getHead());
            List<CAdventureRobot> robotList = adventureRobotSysCache.getAdventureRobot(robotRole.getTeam());

            advenMissionData.setFighting(battleTemplate.computeMonsterStrength(robotList));

            battlerDo = battleHelper.queryNpcBattler(robotList, robotNick);
        } else {
            Role targetRole = RandomUtil.randomEle(targetRoles);
            advenMissionData.setDefRid(targetRole.getId());
            advenMissionData.setDefNick(targetRole.getNick());
            advenMissionData.setFighting(targetRole.getFighting());
            advenMissionData.setDefLevel(targetRole.getLevel());
            advenMissionData.setDefHeadId(targetRole.getHeadId());
            advenMissionData.setDefType((byte) AdvenDefendType.RealRole.getValue());

            battlerDo = battleHelper.queryPlayerBattler(LineUpType.MAIN, targetRole.getId(), Faction.DEFENDER);
        }
        BattlerVo battlerVo = battlerDo.toBattlerVo();
        advenMissionData.setBattlerVo(battlerVo);

        advenMissionDao.update(advenMission);
    }

    /**
     * 匹配机器人
     */
    private CAdventureRobotRole matchRobot(int lowFighting, int upFighting) {
        CAdventureRobotRole robotRole = null;
        // 按照战力范围找机器人
        List<CAdventureRobotRole> robotRoles = adventureRobotRoleSysCache.getAll().stream()
                .filter(robot -> robot.getFighting() >= lowFighting && robot.getFighting() <= upFighting)
                .limit(FIND_DEFENSE_LIMIT).collect(Collectors.toList());
        if (robotRoles.isEmpty()) {
            // 战力范围内找不到，则战力上限向上找
            Optional<CAdventureRobotRole> upRobotOpt = adventureRobotRoleSysCache.getAll().stream()
                    .filter(robot -> robot.getFighting() > upFighting).findFirst();
            if (upRobotOpt.isPresent()) {
                robotRole = upRobotOpt.get();
            } else {
                // 向上也找不到，战力下限向下找
                Optional<CAdventureRobotRole> lowRobotOpt = adventureRobotRoleSysCache.getAll().stream()
                        .filter(robot -> robot.getFighting() < lowFighting).findFirst();
                if (lowRobotOpt.isPresent()) {
                    robotRole = lowRobotOpt.get();
                }
            }
        } else {
            robotRole = RandomUtil.randomEle(robotRoles);
        }
        return robotRole;
    }

    /**
     * 每日重置英雄试炼数据
     *
     * @param advenMission
     */
    public void resetAdvenMission(AdvenMission advenMission) {

        resetAssist(advenMission);

        if (TimeDateUtil.getCurrentTimeInt() <= advenMission.getNextResetTime()) {
            return;
        }

        if (!TimeDateUtil.isToday(advenMission.getLvTime())) {
            return;
        }

        //重置每日数据
        CAdventurereward adventureReward = adventurerewardSysCache.getConfigByMissionIdAndLv(advenMission.getMissionId(), advenMission.getLv());
        int resetBeginIdx = adventureReward.getReset_begin_idx();
        if (advenMission.getLastLv() != advenMission.getLv()) {
            resetBeginIdx = 1;
        }

        if (advenMission.getLastLvTime() < DateTimeUtil.yesterdayBreak()) {
            resetBeginIdx = 1;
        }

        advenMission.setNextResetTime(DateTimeUtil.tomorrowBreak());
        advenMission.setMissionId(resetBeginIdx);
        Map<Integer, AdvenMissionData> missionData = advenMission.getMissionData();
        if (Objects.nonNull(missionData)) {
            missionData.clear();
        }
        if (Objects.nonNull(advenMission.getHeroHpRecord())) {
            advenMission.getHeroHpRecord().clear();
        }
        if (Objects.nonNull(advenMission.getReceivedMissionId())) {
            advenMission.getReceivedMissionId().clear();
        }
        //advenMission.getNextResetTime() 寻找对手
        List<ImmutableThing> reward = new ArrayList<>();
        if (resetBeginIdx > 1) {
            for (int i = 1; i < resetBeginIdx; i++) {
                CAdventurereward cAdventurereward = adventurerewardSysCache.getConfigByMissionIdAndLv(i, advenMission.getLv());
                if (cAdventurereward.getType() == 1) {
                    // 随机对手
                    matchDefender(advenMission, i);
                } else {
                    AdvenMissionData advenMissionData = new AdvenMissionData();
                    advenMissionData.setMissionId(i);
                    missionData.put(advenMissionData.getMissionId(), advenMissionData);
                }
                AdvenMissionData advenMissionData = missionData.get(i);
                advenMissionData.setState((byte) 1);

                reward.addAll(cAdventurereward.getReward());
                // 抛出继承关卡通关事件,宝箱关卡不抛出事件
                if (cAdventurereward.getType() == 1) {
                    eventBus.post(AdvenPassEvent.of(advenMission.getRid(), cAdventurereward.getIdx(), true, cAdventurereward.getShow_mission()));
                } else {
                    eventBus.post(AdvenBoxEvent.of(advenMission.getRid()));
                }
            }
            // 匹配下一关数据
            matchDefender(advenMission, resetBeginIdx);
        } else {
            matchDefender(advenMission, 1);
        }

        advenMission.getRewards().clear();

        int yesterdayNum = advenMission.getBeSelectNum();
        advenMission.setBeSelectNum(0);
        //发送邮件
        if (yesterdayNum > 0) {
            mailService.insert(mailService.newMailNoTitle(advenMission.getRid(), MailScene.ADVEN_BE_SELECT
                    , null, ImmutableThingUtil.multiplyThing(systemSysCache.getAdventureAssistReward(), yesterdayNum)
                    , GameEvent.ADVEN_REWARD));
        }
        if (CollectionUtil.isNotEmpty(reward)) {
            advenMission.getRewards().addAll(reward);
            advenMission.setRewards(ImmutableThingUtil.mergeThing(advenMission.getRewards()));
        }
        advenMissionDao.update(advenMission);

        if (ImmutableThingUtil.getAllItemNums(reward) > 0) {
            // 增加跳过的关卡奖励
            thingService.add(advenMission.getRid(), reward, GameEvent.ADVEN_REWARD);
        }
    }

    private void resetAssist(AdvenMission advenMission) {
        if (TimeDateUtil.getCurrentTimeInt() < advenMission.getAssistExpireTime()) {
            return;
        }
        //必须清除昨天的助战
        List<AdvenSelectAssist> collect = advenMission.getSelectAssists().stream().filter(advenSelectAssist ->
                advenSelectAssist.isHadBattle()).collect(Collectors.toList());
        if (collect.size() > 0) {
            HeroLineUp heroLineUp = heroLineUpService.getLineUpByType(advenMission.getRid(), LineUpType.ADVEN);
            collect.forEach(advenSelectAssist -> {
                heroLineUp.getFormationMap().remove(advenSelectAssist.getHeroVo().getId());
            });
            heroLineUpService.updateHeroLineUp(heroLineUp);
        }
        advenMission.getSelectAssists().clear();

        advenMission.getAssistHeros().clear();
        advenMission.setAssistExpireTime(DateTimeUtil.tomorrowBreak());
        updateAdvenMission(advenMission);
    }

    public void updateAdvenMission(AdvenMission advenMission) {
        advenMissionDao.update(advenMission);
    }

    public AdvenGMsg.GResTrialData toGResTrialData(AdvenMissionData advenMissionData, int lv) {
        AdvenGMsg.GResTrialData.Builder builder = AdvenGMsg.GResTrialData.newBuilder();

        CAdventurereward adventureReward = adventurerewardSysCache.getConfigByMissionIdAndLv(advenMissionData.getMissionId(), lv);
        builder.setMissionId(advenMissionData.getMissionId());
        builder.setStatus(advenMissionData.getState());
        if (adventureReward.getType() == 1) {
            // 战斗关卡
            String defNick = advenMissionData.getDefNick();
            if (Objects.isNull(defNick)) {
                defNick = "";
                log.error("toGResTrialData def nick is null,{}", GJsonUtils.toJson(advenMissionData));
            }
            builder.setDefNick(defNick);
            builder.setDefFighting(advenMissionData.getFighting());
            builder.setDefLevel(advenMissionData.getDefLevel());
            builder.setDefHeadId(advenMissionData.getDefHeadId());
            BattlerVo battlerVo = advenMissionData.getBattlerVo();
            if (Objects.nonNull(battlerVo)) {
                List<HeroVo> heroVos = battlerVo.getHeros();
                List<AdvenGMsg.GResTrialHeroData> heroDataList = heroVos.stream().map(this::toGResTrialHeroData).collect(Collectors.toList());
                builder.addAllHeroData(heroDataList);
                builder.setDefFormationId(battlerVo.getFormationId());
            }
        }
        return builder.build();
    }

    public AdvenGMsg.GResTrialHeroData toGResTrialHeroData(HeroVo heroVo) {
        AdvenGMsg.GResTrialHeroData.Builder builder = AdvenGMsg.GResTrialHeroData.newBuilder();

        CHeroType cHeroType = heroTypeSysCache.getOrThrow(heroVo.getHeroId());
        builder.setPos(heroVo.getPos());
        builder.setType(heroVo.getHeroId());
        builder.setStar(heroVo.getStar());
        builder.setLevel(heroVo.getLevel());
        builder.setElem(cHeroType.getElem());
        builder.setHp(heroVo.getHp());
        builder.setMaxHp(heroVo.getMaxHp());
        return builder.build();
    }

    public BattlerVo createPlayerVo(long rid) {
        HeroLineUp lineUpByType = heroLineUpService.getLineUpByType(rid, LineUpType.ADVEN);
        AdvenMission advenMission = getAdvenMission(rid);

        List<Long> heroIds = new ArrayList<>(lineUpByType.getFormationMap().keySet());
        Asserts.isTrue(heroIds.size() > 0, ErrorCode.ADVEN_CAN_NOT_BATTLE.getValue(), "没有队伍。");
        List<Hero> heros = new ArrayList<>();
        HeroVo assistVo = null;
        for (Long heroId : heroIds) {
            Hero hero = heroService.getHero(rid, heroId);
            if (hero != null) {
                heros.add(hero);
            } else {
                AdvenSelectAssist advenSelectAssist = advenMission.getSelectAssists().stream()
                        .filter(assiestData -> assiestData.getHeroVo().getId() == heroId).findFirst().orElse(null);
                Asserts.notNull(advenSelectAssist, ErrorCode.ADVEN_CAN_NOT_BATTLE.getValue(), String.format("不存在该英雄：{%s}", heroId));
                assistVo = advenSelectAssist.getHeroVo();
            }
        }

        QueryHerosCommand command = QueryHerosCommand.createOfOnlyHero(heros);
        commandBus.invoke(command);
        List<HeroDo> heroDos = new ArrayList<>();
        heroDos.addAll(command.getHeroDos());
        if (assistVo != null) {
            HeroInitCommand initCommand = HeroInitCommand.createOf(Arrays.asList(assistVo));
            commandBus.invoke(initCommand);
            heroDos.addAll(initCommand.getHeroDos());
        }

        //设置位置
        heroDos.forEach(heroDo -> heroDo.setPosition(lineUpByType.getFormationMap().get(heroDo.getId()).getPos()));

        BattlerDo playerDo = battleHelper.queryPlayerBattler(BattleType.TRIAL, heroDos, rid, Faction.ATTACKER);
        return playerDo.toBattlerVo();
    }

    public int getFightPowerLimit(int lv) {
        AdvenLvType advenLvType = AdvenLvType.lvOf(lv);
        if (advenLvType == null)
            return 0;
        switch (advenLvType) {
            case HIGH:
                return systemSysCache.getAdventureSecondLevelNeedScore();
            case NIGHTMARE:
                return systemSysCache.getAdventureThirdLevelNeedScore();

            default:
                return 0;
        }
    }

    /**
     * 获取当前上阵的援助英雄
     * @param rid
     * @param heroId
     * @return
     */
    public HeroVo getMySelectAssist(long rid, long heroId) {
        HeroVo heroVo = null;
        for (AdvenSelectAssist advenSelectAssist : this.getAdvenMission(rid).getSelectAssists()) {
            if (advenSelectAssist.getHeroVo().getId() == heroId) {
                heroVo = advenSelectAssist.getHeroVo();
            }
        }
        return heroVo;
    }

}
