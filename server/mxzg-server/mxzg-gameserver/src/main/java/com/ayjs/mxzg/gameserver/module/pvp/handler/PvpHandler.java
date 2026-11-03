/**
 *
 */
package com.ayjs.mxzg.gameserver.module.pvp.handler;

import com.ayjs.mxzg.battle.model.BattleResult;
import com.ayjs.mxzg.battle.model.BattleType;
import com.ayjs.mxzg.common.command.serivce.CommandBus;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.DropUtil;
import com.ayjs.mxzg.common.util.RandomUtil;
import com.ayjs.mxzg.config.excel.cache.LanguageSysCache;
import com.ayjs.mxzg.config.excel.cache.PvpPlayRewardSysCache;
import com.ayjs.mxzg.config.excel.cache.PvpRobotRoleSysCache;
import com.ayjs.mxzg.config.excel.cache.PvpRobotSysCache;
import com.ayjs.mxzg.config.excel.cache.PvpTimesRewardSysCache;
import com.ayjs.mxzg.config.excel.constant.PvpConst;
import com.ayjs.mxzg.config.excel.entity.CLanguage;
import com.ayjs.mxzg.config.excel.entity.CPvpPlayReward;
import com.ayjs.mxzg.config.excel.entity.CPvpRobot;
import com.ayjs.mxzg.config.excel.entity.CPvpRobotRole;
import com.ayjs.mxzg.config.excel.entity.CPvpTimesReward;
import com.ayjs.mxzg.config.struct.ClergyPrivilegeType;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.config.struct.ItemType;
import com.ayjs.mxzg.config.struct.LineUpType;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.constant.NoticeType;
import com.ayjs.mxzg.gameserver.module.backpack.service.Rewards;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.battle.BattleHelper;
import com.ayjs.mxzg.gameserver.module.clan.service.ClanService;
import com.ayjs.mxzg.gameserver.module.clergy.service.ClergyService;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroLineUp;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroLineUpService;
import com.ayjs.mxzg.gameserver.module.pvp.domain.PvpInfo;
import com.ayjs.mxzg.gameserver.module.pvp.event.PvpDefEvent;
import com.ayjs.mxzg.gameserver.module.pvp.event.PvpEndEvent;
import com.ayjs.mxzg.gameserver.module.pvp.service.PvpInfoService;
import com.ayjs.mxzg.gameserver.module.pvp.service.PvpSysInfoService;
import com.ayjs.mxzg.gameserver.module.pvp.struct.PvpRecord;
import com.ayjs.mxzg.gameserver.module.role.constant.EntryType;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.gameserver.module.video.constant.VideoType;
import com.ayjs.mxzg.gameserver.module.video.event.VideoRecordEvent;
import com.ayjs.mxzg.module.battle.BattleTemplate;
import com.ayjs.mxzg.module.battle.command.SaveBattleReportCommand;
import com.ayjs.mxzg.protocol.PvpGMsg.GReqBuyPvpTicket;
import com.ayjs.mxzg.protocol.PvpGMsg.GReqPvpBattle;
import com.ayjs.mxzg.protocol.PvpGMsg.GReqPvpBattleHistoryList;
import com.ayjs.mxzg.protocol.PvpGMsg.GReqPvpData;
import com.ayjs.mxzg.protocol.PvpGMsg.GReqPvpLike;
import com.ayjs.mxzg.protocol.PvpGMsg.GReqPvpPlayerRefresh;
import com.ayjs.mxzg.protocol.PvpGMsg.GReqPvpSeasonReward;
import com.ayjs.mxzg.protocol.PvpGMsg.GResBuyPvpTicket;
import com.ayjs.mxzg.protocol.PvpGMsg.GResPvpBattle;
import com.ayjs.mxzg.protocol.PvpGMsg.GResPvpBattleHistoryList;
import com.ayjs.mxzg.protocol.PvpGMsg.GResPvpData;
import com.ayjs.mxzg.protocol.PvpGMsg.GResPvpLike;
import com.ayjs.mxzg.protocol.PvpGMsg.GResPvpPlayerRefresh;
import com.ayjs.mxzg.protocol.PvpGMsg.GResPvpSeasonReward;
import com.ayjs.mxzg.protocol.PvpGMsg.PSPvpRecordData;
import com.ayjs.mxzg.protocol.PvpGMsg.PSRankPlayerData;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.ayjs.mxzg.template.language.LanguageHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * @author YY
 *
 */
@Controller
public class PvpHandler extends ProtocolHandler {

    @Autowired
    private PvpInfoService pvpInfoService;
    @Autowired
    private RoleService roleService;
    @Autowired
    private HeroLineUpService heroLineUpService;
    @Autowired
    private ThingService thingService;
    @Autowired
    private PvpRobotSysCache pvpRobotSysCache;
    @Autowired
    private PvpRobotRoleSysCache pvpRobotRoleSysCache;
    @Autowired
    private LanguageSysCache languageSysCache;
    @Autowired
    private LanguageHelper languageHelper;
    @Autowired
    private PvpPlayRewardSysCache pvpPlayRewardSysCache;
    @Autowired
    private BattleHelper battleHelper;
    @Autowired
    private ClanService clanService;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private PvpSysInfoService pvpSysInfoService;
    @Autowired
    private CommandBus commandBus;
    @Autowired
    private BattleTemplate battleTemplate;
    @Autowired
    private PvpTimesRewardSysCache pvpTimesRewardSysCache;
    @Autowired
    private ClergyService clergyService;

    /**
     * 请求竞技场信息
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._18001)
    public void pvpData(PlayerContext playerContext, GReqPvpData msg) {
        Role role = roleService.getOrThrow(playerContext.getId());

        PvpInfo pvpInfo = pvpInfoService.getPvpInfo(playerContext.getId());

        if (pvpInfo.getChallenge() >= PvpConst.CHALLENGE_ROBOT_COUNT) {
            if (pvpInfo.getOtherRids().isEmpty()) {
                List<Long> pvpRoleList = refreshBattler(role);
                pvpInfo.getOtherRids().addAll(pvpRoleList);
                pvpInfoService.updatePvpInfo(pvpInfo);
            }
        } else {
            if (pvpInfo.getRobotIds().isEmpty()) {
                pvpInfo.getRobotIds().addAll(getRandomRobots());
                pvpInfoService.updatePvpInfo(pvpInfo);
            }
        }

        GResPvpData.Builder builder = GResPvpData.newBuilder();
        if (pvpInfo.getChallenge() >= PvpConst.CHALLENGE_ROBOT_COUNT) {
            for (long rid : pvpInfo.getOtherRids()) {
                Role other = roleService.getOrThrow(rid);
                builder.addList(serializeRankPlayer(other));
            }
        } else {
            for (int robotId : pvpInfo.getRobotIds()) {
                builder.addList(serializeRankRobot(robotId));
            }
        }
        builder.setScore(role.getArenaScore());
        builder.setFreeCount(PvpConst.DAILY_FREE_PLAY - pvpInfo.getNum() > 0
                ? PvpConst.DAILY_FREE_PLAY - pvpInfo.getNum()
                : 0);
        builder.setSeasonEndTime(pvpSysInfoService.getNextPvpTime());
        builder.addAllLikeRids(pvpInfo.getLikeRids());
        builder.addAllSeasonReward(pvpInfo.getSeasonReward());
        builder.setSeasonCount(pvpInfo.getSeasonCount());
        playerContext.write(CmdCode._18001, builder.build());
    }

    /**
     * 随机机器人
     * @return
     */
    private List<Integer> getRandomRobots() {
        List<CPvpRobotRole> robotList = DropUtil.randomDifDrop(pvpRobotRoleSysCache.getAll(), PvpConst.RANDOM_COUNT);
        List<Integer> result = new ArrayList<>();
        robotList.stream().forEach(obj -> result.add(obj.getTeam()));
        return result;
    }

    private PSRankPlayerData serializeRankPlayer(Role role) {
        PSRankPlayerData.Builder builder = PSRankPlayerData.newBuilder();

        builder.setClanId(role.getClanId());
        builder.setClanName(clanService.getClanName(role));
        builder.setHeadId(role.getHeadId());
        builder.setBorderId(role.getBorderId());
        builder.setLevel(role.getLevel());
        builder.setPlayerId(role.getId());
        builder.setName(role.getNick());
        builder.setScore(role.getArenaScore());
        builder.setServerId(role.getServerId());

        // 竞技场的防守阵容
        HeroLineUp pvpLineUp = heroLineUpService.getLineUpByType(role.getId(), LineUpType.PVP_DEF);
        if (pvpLineUp.getFormationMap().isEmpty()) {
            // 没有防守阵型就用主线任务的
            pvpLineUp = heroLineUpService.getLineUpByType(role.getId(), LineUpType.MAIN);
        }
        builder.setCombatNum(heroLineUpService.getLineUpFighting(pvpLineUp));
        return builder.build();
    }


    private PSRankPlayerData serializeRankRobot(int robotId) {
        CPvpRobotRole robot = pvpRobotRoleSysCache.getOrThrow(robotId);

        PSRankPlayerData.Builder builder = PSRankPlayerData.newBuilder();
        builder.setClanId(0);
        builder.setClanName("");
        builder.setHeadId(robot.getHead());
        builder.setLevel(robot.getLevel());
        builder.setPlayerId(robotId);
        CLanguage cLanguage = languageSysCache.getByKey(robot.getName_lang());
        builder.setName(languageHelper.getLanguageBy(cLanguage));
        builder.setScore(robot.getCup());
        builder.setServerId(0);
        //计算机器人战力
        List<CPvpRobot> defRobots = pvpRobotSysCache.getByTeam(robot.getTeam());
        int fighting = battleTemplate.computeMonsterStrength(defRobots);
        builder.setCombatNum(fighting);
        return builder.build();
    }


    /**
     * 获取竞技场匹配对手
     *
     * @param role
     * @return
     */
    @SuppressWarnings("unused")
    @Deprecated
    private List<Long> offlineBattle(Role role) {
        List<Role> findList = new ArrayList<>();
        Set<Long> roleIds = new HashSet<>();
        for (int i = 0; i < 10; i++) {
            int maxCup = role.getArenaScore() + i * 200;
            int minCup = role.getArenaScore() - (i + 1) * 200 / 2;

            for (Role other : roleService.getAllRole()) {
                if (other.getId() == role.getId()) {
                    continue;
                }
                if (roleIds.contains(other.getId())) {
                    continue;
                }
                //主线阵容都没有布阵的玩家直接跳过
                HeroLineUp mainLineUp = heroLineUpService.getLineUpByType(other.getId(), LineUpType.MAIN);
                HeroLineUp pvpLineUp = heroLineUpService.getLineUpByType(other.getId(), LineUpType.PVP_DEF);
                if (pvpLineUp.getFormationMap().isEmpty() && mainLineUp.getFormationMap().isEmpty()) {
                    continue;
                }

                if (other.getLevel() < 6) {
                    continue;
                }
                if (minCup <= other.getArenaScore() && other.getArenaScore() <= maxCup) {
                    findList.add(other);
                    roleIds.add(other.getId());
                }
                if (findList.size() >= 20) {
                    break;
                }
            }
            if (findList.size() >= 20) {
                break;
            }
        }

        List<Long> resultList = new ArrayList<>();
        for (int i = 0; i < PvpConst.RANDOM_COUNT && !findList.isEmpty(); i++) {
            Role other = findList.remove(RandomUtil.getRandomInt(0, findList.size() - 1));
            resultList.add(other.getId());
        }
        return resultList;
    }

    private List<Long> refreshBattler(Role role) {
        List<Role> allRoleList = new ArrayList<>(roleService.getAllRole());
        Collections.sort(allRoleList, SORTER);

        int myIndex = 0;
        for (int i = 0; i < allRoleList.size(); i++) {
            Role me = allRoleList.get(i);
            if (me.getId() == role.getId()) {
                myIndex = i;
                break;
            }
        }

        List<Role> tempList = new ArrayList<>();
        int firstIndex = myIndex - PvpConst.FIND_COUNT / 2;
        int lastIndex = myIndex + PvpConst.FIND_COUNT / 2;
        if (firstIndex < 0) {
            for (int i = 0; i < allRoleList.size(); i++) {
                Role other = allRoleList.get(i);
                if (other.getId() == role.getId()) {
                    continue;
                }
                //主线阵容都没有布阵的玩家直接跳过
                HeroLineUp mainLineUp = heroLineUpService.getLineUpByType(other.getId(), LineUpType.MAIN);
                HeroLineUp pvpLineUp = heroLineUpService.getLineUpByType(other.getId(), LineUpType.PVP_DEF);
                if (pvpLineUp.getFormationMap().isEmpty() && mainLineUp.getFormationMap().isEmpty()) {
                    continue;
                }
                if (other.getLevel() < 6) {
                    continue;
                }
                tempList.add(other);
                if (tempList.size() >= PvpConst.FIND_COUNT) {
                    break;
                }
            }
        } else if (lastIndex >= allRoleList.size()) {
            for (int i = allRoleList.size() - 1; i >= 0; i--) {
                Role other = allRoleList.get(i);
                if (other.getId() == role.getId()) {
                    continue;
                }
                //主线阵容都没有布阵的玩家直接跳过
                HeroLineUp mainLineUp = heroLineUpService.getLineUpByType(other.getId(), LineUpType.MAIN);
                HeroLineUp pvpLineUp = heroLineUpService.getLineUpByType(other.getId(), LineUpType.PVP_DEF);
                if (pvpLineUp.getFormationMap().isEmpty() && mainLineUp.getFormationMap().isEmpty()) {
                    continue;
                }
                if (other.getLevel() < 6) {
                    continue;
                }
                tempList.add(other);
                if (tempList.size() >= PvpConst.FIND_COUNT) {
                    break;
                }
            }
        } else {
            for (int i = firstIndex; i <= lastIndex; i++) {
                Role other = allRoleList.get(i);
                if (other.getId() == role.getId()) {
                    continue;
                }
                //主线阵容都没有布阵的玩家直接跳过
                HeroLineUp mainLineUp = heroLineUpService.getLineUpByType(other.getId(), LineUpType.MAIN);
                HeroLineUp pvpLineUp = heroLineUpService.getLineUpByType(other.getId(), LineUpType.PVP_DEF);
                if (pvpLineUp.getFormationMap().isEmpty() && mainLineUp.getFormationMap().isEmpty()) {
                    continue;
                }
                if (other.getLevel() < 6) {
                    continue;
                }
                tempList.add(other);
                if (tempList.size() >= PvpConst.FIND_COUNT) {
                    break;
                }
            }
        }
        int n = 0;
        if (myIndex < PvpConst.LOW_RANK) {
            n = 2;
        } else {
            n = 1;
        }
        Collections.shuffle(tempList);

        List<Long> resultList = new ArrayList<>();
        int findLow = PvpConst.RANDOM_COUNT - n;

        int index = 0;
        while (index < tempList.size()) {
            Role other = tempList.get(index);
            //找n个比自己战力低的
            if (other.getFighting() < role.getFighting()) {
                resultList.add(other.getId());
                tempList.remove(index);
                if (resultList.size() >= findLow) {
                    break;
                }
            } else {
                index++;
            }
        }
        index = 0;
        while (index < tempList.size()) {
            Role other = tempList.get(index);
            //找3 - n个比自己战力高的
            if (other.getFighting() > role.getFighting()) {
                resultList.add(other.getId());
                tempList.remove(index);
                if (resultList.size() >= PvpConst.RANDOM_COUNT) {
                    break;
                }
            } else {
                index++;
            }
        }
        //随机找
        for (int i = 0; i < tempList.size() && resultList.size() < PvpConst.RANDOM_COUNT; i++) {
            Role other = tempList.get(i);
            resultList.add(other.getId());
        }
        return resultList;
    }

    private static Comparator<Role> SORTER = new Comparator<Role>() {
        @Override
        public int compare(Role o1, Role o2) {
            int result = Long.compare(o2.getArenaScore(), o1.getArenaScore());
            if (result != 0)
                return result;
            result = Integer.compare(o1.getArenaRankTime(), o2.getArenaRankTime());
            if (result != 0) {
                return result;
            }
            result = Integer.compare(o2.getLevel(), o1.getLevel());
            if (result != 0) {
                return result;
            }
            return Long.compare(o1.getId(), o2.getId());
        }
    };


    /**
     * 挑战PVP对手
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._18002, entry = EntryType.MAIN_PVP)
    public void pvpBattle(PlayerContext playerContext, GReqPvpBattle msg) {
        PvpInfo pvpInfo = pvpInfoService.getPvpInfo(playerContext.getId());
        if (pvpInfo.getNum() >= PvpConst.DAILY_FREE_PLAY) {
            ImmutableThing cost = ImmutableThing.of(900501, 1);
            thingService.cost(playerContext.getId(), cost, GameEvent.PVP);
        }
        //进行战斗
        if (pvpInfo.getChallenge() >= PvpConst.CHALLENGE_ROBOT_COUNT) {
            //打人
            vsPlayer(playerContext, pvpInfo, msg.getPlayerId());
        } else {
            //打机器人
            vsRobot(playerContext, pvpInfo, (int) msg.getPlayerId());
        }
    }

    private void vsRobot(PlayerContext playerContext, PvpInfo pvpInfo, int robotId) {
        //判断对手是不是在自己的对手集合中
        Asserts.isTrue(pvpInfo.getRobotIds().contains(robotId), ErrorCode.ERROR_PARAM.getValue(),
                "参数ID:" + robotId + "可挑战列表:" + pvpInfo.getRobotIds());

        Role role = roleService.getOrThrow(playerContext.getId());
        CPvpRobotRole pvpRobotRole = pvpRobotRoleSysCache.getOrThrow(robotId);

        CLanguage cLanguage = languageSysCache.getByKey(pvpRobotRole.getName_lang());
        String robotName = languageHelper.getLanguageBy(cLanguage);

        //打机器人
        List<CPvpRobot> defRobots = pvpRobotSysCache.getByTeam(pvpRobotRole.getTeam());
        BattleResult battleResult = battleHelper.invokePVEBattle(BattleType.ARENA, playerContext.getId(), defRobots, robotName);
        String battleId = battleResult.getReport().getBattleId();

        PvpRecord myRecord = null;

        int cup11 = role.getArenaScore();
        int cup22 = pvpRobotRole.getCup();

        //对方的积分变化量
        int otherDeltaCup = 0;

        boolean isWin = battleResult.isWin();
        if (isWin) {
            pvpInfo.setChallenge(pvpInfo.getChallenge() + 1);

            //更新我的积分
            int[] cups = calculateCups(cup11, cup22);
            myRecord = this.vsRobotRecord(role, pvpRobotRole, isWin, cups[0], battleId);
            role.setArenaScore(role.getArenaScore() + cups[0]);
            if (role.getArenaScore() > role.getMaxCup()) {
                role.setMaxCup(role.getArenaScore());
            }
            roleService.updateRole(role);
            //更新对方的积分
            cups = calculateCups(cup22, cup11);

            otherDeltaCup = -cups[1];
        } else {
            //挑战记录，挑战失败不扣积分
            myRecord = this.vsRobotRecord(role, pvpRobotRole, isWin, 0, battleId);
        }

        //保存战报
        commandBus.invoke(SaveBattleReportCommand.of(battleResult.getReport()));

        pvpInfo.getRecords().add(0, myRecord);
        while (pvpInfo.getRecords().size() > PvpConst.RECORD_MAX_COUNT) {
            pvpInfo.getRecords().remove(PvpConst.RECORD_MAX_COUNT);
        }
        pvpInfo.setNum(pvpInfo.getNum() + 1);
        pvpInfo.setSeasonCount(pvpInfo.getSeasonCount() + 1);
        pvpInfoService.updatePvpInfo(pvpInfo);

        CPvpPlayReward cPvpPlayReward = DropUtil.randomDrop(pvpPlayRewardSysCache.getAll());
        //神职加成
        GResPvpBattle.Builder builder = GResPvpBattle.newBuilder();

        List<ImmutableThing> rewards = clergyService.clergyEarnings(role, ClergyPrivilegeType.PVP, cPvpPlayReward.getReward());

        builder.setChanceStatus(rewards.size() > 0 ? 1 : 0);

        rewards.addAll(cPvpPlayReward.getReward());
        rewards = ImmutableThingUtil.mergeThing(rewards);

        Rewards rewardList = thingService.add(role.getId(), rewards, GameEvent.PVP, NoticeType.SLIENT);

        builder.setIsWin(isWin ? 1 : 0);
        builder.setSelfScore(myRecord.getCupDelta());
        builder.setEnemyScore(otherDeltaCup);
        builder.addAllList(PbUtil.buildReward(rewardList.getThingSet().asList()));
        builder.setReport(battleResult.getReport());
        builder.setPlayerId(robotId);
        builder.setSelfCup(role.getArenaScore());
        builder.setEnemyCup(cup22 + otherDeltaCup);
        builder.setEnemyName(robotName);
        builder.setHeadId(pvpRobotRole.getHead());
        builder.setBorderId(0);
        playerContext.write(CmdCode._18002, builder.build());

        eventBus.post(PvpEndEvent.of(role.getId(), isWin, role.getArenaScore()));
    }

    private void vsPlayer(PlayerContext playerContext, PvpInfo pvpInfo, long otherPlayerId) {

        //判断对手是不是在自己的对手集合中
        Asserts.isTrue(pvpInfo.getOtherRids().contains(otherPlayerId), ErrorCode.ERROR_PARAM.getValue(),
                "参数ID:" + otherPlayerId + "可挑战列表:" + pvpInfo.getOtherRids());

        Role role = roleService.getOrThrow(playerContext.getId());
        Role other = roleService.getOrThrow(otherPlayerId);

        // 竞技场的防守阵容
        HeroLineUp pvpLineUp = heroLineUpService.getLineUpByType(other.getId(), LineUpType.PVP_DEF);
        if (pvpLineUp.getFormationMap().isEmpty()) {
            // 没有防守阵型就用主线任务的
            pvpLineUp = heroLineUpService.getLineUpByType(other.getId(), LineUpType.MAIN);
        }

        //打人
        BattleResult battleResult = battleHelper.invokePVPBattle(BattleType.ARENA, LineUpType.MAIN,
                playerContext.getId(), LineUpType.valueOf(pvpLineUp.getType()), other.getId());
        boolean isWin = battleResult.isWin();

        String battleId = battleResult.getReport().getBattleId();

        PvpRecord myRecord = null;
        PvpRecord otherRecord = null;

        int cup11 = role.getArenaScore();
        int cup22 = other.getArenaScore();

        if (isWin) {
            pvpInfo.setChallenge(pvpInfo.getChallenge() + 1);

            //更新我的积分
            int[] cups = calculateCups(cup11, cup22);
            myRecord = this.vsPlayerRecord(role, other, isWin, cups[0], battleId, 1);
            role.setArenaScore(role.getArenaScore() + cups[0]);
            if (role.getArenaScore() > role.getMaxCup()) {
                role.setMaxCup(role.getArenaScore());
            }
            roleService.updateRole(role);
            //更新对方的积分
            cups = calculateCups(cup22, cup11);
            otherRecord = this.vsPlayerRecord(other, role, !isWin, -cups[1], battleId, 2);
            int otherCup = other.getArenaScore() - cups[1];
            if (otherCup <= 0) {
                otherCup = 0;
            }
            other.setArenaScore(otherCup);
            roleService.updateRole(other);
        } else {
            //挑战失败双方积分不发生变化
            myRecord = this.vsPlayerRecord(role, other, isWin, 0, battleId, 1);
            otherRecord = this.vsPlayerRecord(other, role, !isWin, 0, battleId, 2);
        }

        //保存战报
        commandBus.invoke(SaveBattleReportCommand.of(battleResult.getReport()));


        pvpInfo.getRecords().add(0, myRecord);
        while (pvpInfo.getRecords().size() > PvpConst.RECORD_MAX_COUNT) {
            pvpInfo.getRecords().remove(PvpConst.RECORD_MAX_COUNT);
        }
        pvpInfo.setNum(pvpInfo.getNum() + 1);
        pvpInfo.setSeasonCount(pvpInfo.getSeasonCount() + 1);
        pvpInfoService.updatePvpInfo(pvpInfo);

        //敌对玩家的对战记录
        //玩家的对战记录总是以自己会进攻方，或者说在记录中总是显示在左边
        PvpInfo otherPvpInfo = pvpInfoService.getPvpInfo(other.getId());
        otherPvpInfo.getRecords().add(0, otherRecord);
        while (otherPvpInfo.getRecords().size() > PvpConst.RECORD_MAX_COUNT) {
            otherPvpInfo.getRecords().remove(PvpConst.RECORD_MAX_COUNT);
        }
        pvpInfoService.updatePvpInfo(otherPvpInfo);

        CPvpPlayReward cPvpPlayReward = DropUtil.randomDrop(pvpPlayRewardSysCache.getAll());
        //神职加成
        GResPvpBattle.Builder builder = GResPvpBattle.newBuilder();
        List<ImmutableThing> rewards = clergyService.clergyEarnings(role, ClergyPrivilegeType.PVP, cPvpPlayReward.getReward());

        builder.setChanceStatus(rewards.size() > 0 ? 1 : 0);

        rewards.addAll(cPvpPlayReward.getReward());
        rewards = ImmutableThingUtil.mergeThing(rewards);

        Rewards rewardList = thingService.add(role.getId(), rewards, GameEvent.PVP, NoticeType.SLIENT);

        builder.setIsWin(isWin ? 1 : 0);
        builder.setSelfScore(myRecord.getCupDelta());
        builder.setEnemyScore(otherRecord.getCupDelta());
        builder.addAllList(PbUtil.buildReward(rewardList.getThingSet().asList()));
        builder.setReport(battleResult.getReport());
        builder.setPlayerId(other.getId());
        builder.setSelfCup(role.getArenaScore());
        builder.setEnemyCup(other.getArenaScore());
        builder.setEnemyName(other.getNick());
        builder.setHeadId(other.getHeadId());
        builder.setBorderId(other.getBorderId());
        playerContext.write(CmdCode._18002, builder.build());

        eventBus.post(PvpEndEvent.of(role.getId(), isWin, role.getArenaScore()));
        eventBus.post(PvpDefEvent.of(other.getId(), other.getArenaScore()));
        eventBus.post(VideoRecordEvent.of(VideoType.PVP, 0, battleResult.getReport(), ""));
    }


    private PvpRecord vsPlayerRecord(Role atk, Role def, boolean result, int cupDelta, String battleId, int type) {
        PvpRecord pvpRecord = new PvpRecord();
        pvpRecord.setBattleId(battleId);
        pvpRecord.setAtkId(atk.getId());
        pvpRecord.setAtkLv(atk.getLevel());

        pvpRecord.setCupDelta(cupDelta);

        pvpRecord.setDefHead(def.getHeadId());
        pvpRecord.setDefName(def.getNick());
        pvpRecord.setDefLv(def.getLevel());
        pvpRecord.setDefBorder(def.getBorderId());
        pvpRecord.setResult(result ? 1 : 0);

        pvpRecord.setType(type);

        return pvpRecord;
    }

    private PvpRecord vsRobotRecord(Role atk, CPvpRobotRole pvpRobotRole, boolean result, int cupDelta, String battleId) {
        CLanguage cLanguage = languageSysCache.getByKey(pvpRobotRole.getName_lang());

        PvpRecord pvpRecord = new PvpRecord();
        pvpRecord.setBattleId(battleId);
        pvpRecord.setAtkId(atk.getId());
        pvpRecord.setAtkLv(atk.getLevel());
        pvpRecord.setCupDelta(cupDelta);
        pvpRecord.setDefHead(pvpRobotRole.getHead());
        pvpRecord.setDefName(cLanguage == null ? "" : languageHelper.getLanguageBy(cLanguage));
        pvpRecord.setDefLv(pvpRobotRole.getLevel());
        pvpRecord.setResult(result ? 1 : 0);
        pvpRecord.setType(1);
        return pvpRecord;
    }


    public final static int[] calculateCups(int attackerCups, int defenderCups) {
        int[] reslut = new int[2];

        // 计算奖杯数
        int k = 20;
        int expectedfactor = 170;
        int mincup = 1;
        int maxcup = 24;

        double EA = 1 / (1 + Math.pow(10, 1.0 * (defenderCups - attackerCups)
                / expectedfactor));

        int K = k + Math.abs(defenderCups - attackerCups) % 10;

        reslut[0] = (int) Math.ceil(K * (1 - EA));
        reslut[1] = K - reslut[0];
        if (reslut[1] > maxcup) {
            reslut[1] = maxcup;
        }
        if (reslut[1] < mincup) {
            reslut[1] = mincup;
        }

        if (reslut[0] < mincup) {
            reslut[0] = mincup;
        }
        if (reslut[0] > maxcup) {
            reslut[0] = maxcup;
        }
        return reslut;
    }


    /**
     * 刷新对手
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._18003)
    public void refreshPvpPlayer(PlayerContext playerContext, GReqPvpPlayerRefresh msg) {
        Role role = roleService.getOrThrow(playerContext.getId());

        PvpInfo pvpInfo = pvpInfoService.getPvpInfo(playerContext.getId());

        if (pvpInfo.getChallenge() >= PvpConst.CHALLENGE_ROBOT_COUNT) {
            pvpInfo.getOtherRids().clear();
            List<Long> pvpRoleList = refreshBattler(role);
            pvpInfo.getOtherRids().addAll(pvpRoleList);
            pvpInfoService.updatePvpInfo(pvpInfo);
        } else {
            pvpInfo.getRobotIds().clear();
            pvpInfo.getRobotIds().addAll(getRandomRobots());
            pvpInfoService.updatePvpInfo(pvpInfo);
        }

        GResPvpPlayerRefresh.Builder builder = GResPvpPlayerRefresh.newBuilder();
        if (pvpInfo.getChallenge() >= PvpConst.CHALLENGE_ROBOT_COUNT) {
            for (long rid : pvpInfo.getOtherRids()) {
                Role other = roleService.getOrThrow(rid);
                builder.addList(serializeRankPlayer(other));
            }
        } else {
            for (int robotId : pvpInfo.getRobotIds()) {
                builder.addList(serializeRankRobot(robotId));
            }
        }
        playerContext.write(CmdCode._18003, builder.build());
    }

    /**
     * 挑战记录
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._18004)
    public void pvpBattleHistory(PlayerContext playerContext, GReqPvpBattleHistoryList msg) {
        PvpInfo pvpInfo = pvpInfoService.getPvpInfo(playerContext.getId());

        Role role = roleService.getOrThrow(playerContext.getId());


        GResPvpBattleHistoryList.Builder builder = GResPvpBattleHistoryList.newBuilder();

        pvpInfo.getRecords().stream().forEach(record -> {
            PSPvpRecordData.Builder ele = PSPvpRecordData.newBuilder();
            ele.setBattleId(record.getBattleId());
            ele.setAtkName(role.getNick());
            ele.setAtkHead(role.getHeadId());
            ele.setAtkBorder(role.getBorderId());
            ele.setAtkLv(record.getAtkLv());
            ele.setDefName(record.getDefName());
            ele.setDefLv(record.getDefLv());
            ele.setDefHead(record.getDefHead());
            ele.setDefBorder(record.getDefBorder());
            ele.setCupDelta(record.getCupDelta());
            ele.setResult(record.getResult());
            ele.setType(record.getType());
            builder.addList(ele.build());
        });
        playerContext.write(CmdCode._18004, builder.build());
    }

    /**
     * 竞技场购买挑战门票
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._18005)
    public void pvpBuyTicket(PlayerContext playerContext, GReqBuyPvpTicket msg) {

        Asserts.isTrue(msg.getItemNum() > 0, ErrorCode.ERROR_PARAM.getValue(), () -> "item num:" + msg.getItemNum());

        Role role = roleService.getOrThrow(playerContext.getId());
        ImmutableThing costThing = ImmutableThing.of(ItemType.IT_GEM,
                PvpConst.TICKET_COST_GEM * msg.getItemNum());
        thingService.cost(role.getId(), costThing, GameEvent.PVP_BUY_TICKET);

        ImmutableThing rewardThing = ImmutableThing.of(ItemType.IT_PVP_TICKET, msg.getItemNum());

        thingService.add(role.getId(), rewardThing, GameEvent.PVP_BUY_TICKET);
        playerContext.write(CmdCode._18005, GResBuyPvpTicket.getDefaultInstance());
    }

    /**
     * 竞技场点赞
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._18007)
    public void pvpLike(PlayerContext playerContext, GReqPvpLike msg) {

        Asserts.isTrue(roleService.isRole(msg.getRid()), ErrorCode.ERROR_PARAM.getValue(), "不是玩家的ID" + msg.getRid());

        PvpInfo pvpInfo = pvpInfoService.getPvpInfo(playerContext.getId());
        Asserts.isTrue(pvpInfo.getLikeRids().size() < PvpConst.LIKE_TIMES_DAILY, ErrorCode.PVP_LIKE_COUNT_MAX.getValue(), "今天的点赞次数已经用光");
        Asserts.isTrue(!pvpInfo.getLikeRids().contains(msg.getRid()), ErrorCode.PVP_LIKED.getValue(), "今天已经点赞过该玩家");

        PvpInfo otherPvpInfo = pvpInfoService.getPvpInfo(msg.getRid());

        synchronized (otherPvpInfo) {
            otherPvpInfo.setBelike(otherPvpInfo.getBelike() + 1);
            pvpInfoService.updatePvpInfo(otherPvpInfo);
        }
        pvpInfo.getLikeRids().add(msg.getRid());
        pvpInfoService.updatePvpInfo(pvpInfo);

        thingService.add(playerContext.getId(), PvpConst.LIKE_REWARD, GameEvent.PVP_LIKE);

        GResPvpLike.Builder builder = GResPvpLike.newBuilder();
        builder.setRid(msg.getRid());
        builder.setBelike(otherPvpInfo.getBelike());
        playerContext.write(CmdCode._18007, builder.build());
    }

    /**
     * 竞技场领取赛季累计挑战次数奖励
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._18008)
    public void getSeasonReward(PlayerContext playerContext, GReqPvpSeasonReward msg) {
        PvpInfo pvpInfo = pvpInfoService.getPvpInfo(playerContext.getId());
        Asserts.isTrue(!pvpInfo.getSeasonReward().contains(msg.getType()), ErrorCode.PVP_SEASON_REWARD.getValue(), "已经领取了该赛季奖励" + msg.getType());

        CPvpTimesReward cPvpTimesReward = pvpTimesRewardSysCache.getOrThrow(msg.getType());
        Asserts.isTrue(pvpInfo.getSeasonCount() >= cPvpTimesReward.getTimes(), ErrorCode.PVP_SEASON_COUNT.getValue(), "未达到领取该赛季奖励的挑战次数" + msg.getType());

        pvpInfo.getSeasonReward().add(msg.getType());
        pvpInfoService.updatePvpInfo(pvpInfo);

        thingService.add(playerContext.getId(), cPvpTimesReward.getReward(), GameEvent.PVP_SEASON_TIME);

        GResPvpSeasonReward.Builder builder = GResPvpSeasonReward.newBuilder();
        builder.setType(msg.getType());
        playerContext.write(CmdCode._18008, builder.build());
    }
}
