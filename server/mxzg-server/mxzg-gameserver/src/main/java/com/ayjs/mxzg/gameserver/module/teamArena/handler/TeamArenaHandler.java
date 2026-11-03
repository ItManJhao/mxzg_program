package com.ayjs.mxzg.gameserver.module.teamArena.handler;

import cn.hutool.core.collection.CollectionUtil;
import com.ayjs.mxzg.battle.command.BattleCommand;
import com.ayjs.mxzg.battle.model.BattleType;
import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.Faction;
import com.ayjs.mxzg.battle.model.HeroDo;
import com.ayjs.mxzg.battle.model.HeroHpInfo;
import com.ayjs.mxzg.battle.model.UnitType;
import com.ayjs.mxzg.battle.model.mirror.BattlerVo;
import com.ayjs.mxzg.battle.model.mirror.HeroVo;
import com.ayjs.mxzg.common.command.serivce.CommandBus;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.exception.ErrorCodeException;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.JsonUtil;
import com.ayjs.mxzg.common.util.gson.GsonUtils;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.teamArena.TeamArenaChallengeRewardSysCache;
import com.ayjs.mxzg.config.excel.cache.teamArena.TeamArenaConst;
import com.ayjs.mxzg.config.excel.entity.teamArena.CTeamArenaChallengeReward;
import com.ayjs.mxzg.config.struct.AttributeType;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.constant.ServerConfig;
import com.ayjs.mxzg.gameserver.infrastructure.gm.GMCommand;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.GMCmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.battle.BattleHelper;
import com.ayjs.mxzg.gameserver.module.clan.domain.Clan;
import com.ayjs.mxzg.gameserver.module.clan.service.ClanService;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroLineUp;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.hero.struct.HeroPosition;
import com.ayjs.mxzg.gameserver.module.rank.constant.RankType;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.teamArena.domain.ArenaTeam;
import com.ayjs.mxzg.gameserver.module.teamArena.domain.ArenaTeamBattleRecord;
import com.ayjs.mxzg.gameserver.module.teamArena.domain.ArenaTeamBattleRecordDetail;
import com.ayjs.mxzg.gameserver.module.teamArena.event.TeamArenaRecordEvent;
import com.ayjs.mxzg.gameserver.module.teamArena.service.TeamArenaBattleRecordService;
import com.ayjs.mxzg.gameserver.module.teamArena.service.TeamArenaRankService;
import com.ayjs.mxzg.gameserver.module.teamArena.service.TeamArenaRedService;
import com.ayjs.mxzg.gameserver.module.teamArena.service.TeamArenaService;
import com.ayjs.mxzg.gameserver.remote.cross.event.CrossConnectedEvent;
import com.ayjs.mxzg.message.module.role.dao.CrossRoleRedisDao;
import com.ayjs.mxzg.message.module.role.domain.CrossRole;
import com.ayjs.mxzg.message.module.teamArena.domain.ArenaTeamMember;
import com.ayjs.mxzg.message.module.teamArena.domain.RoleAction;
import com.ayjs.mxzg.message.module.teamArena.domain.RoleSimpleMessage;
import com.ayjs.mxzg.message.module.teamArena.domain.TeamArenaRankData;
import com.ayjs.mxzg.message.module.teamArena.domain.TeamArenaState;
import com.ayjs.mxzg.message.module.teamArena.domain.TeamArenaTime;
import com.ayjs.mxzg.message.module.teamArena.message.TeamArenaBattleReqMessage;
import com.ayjs.mxzg.message.module.teamArena.message.TeamArenaBattleResMessage;
import com.ayjs.mxzg.message.module.teamArena.message.TeamArenaChangeStateReqMessage;
import com.ayjs.mxzg.message.module.teamArena.message.TeamArenaDefendResMessage;
import com.ayjs.mxzg.message.module.teamArena.message.TeamArenaGMReqMessage;
import com.ayjs.mxzg.message.module.teamArena.message.TeamArenaGetMemberLineUpReqMessage;
import com.ayjs.mxzg.message.module.teamArena.message.TeamArenaGetMemberLineUpResMessage;
import com.ayjs.mxzg.message.module.teamArena.message.TeamArenaGetStateReqMessage;
import com.ayjs.mxzg.message.module.teamArena.message.TeamArenaLineUpReqMessage;
import com.ayjs.mxzg.message.module.teamArena.message.TeamArenaLineUpResMessage;
import com.ayjs.mxzg.message.module.teamArena.message.TeamArenaRefreshDefendReqMessage;
import com.ayjs.mxzg.message.module.teamArena.message.TeamArenaRefreshDefendResMessage;
import com.ayjs.mxzg.message.module.teamArena.message.TeamArenaSignReqMessage;
import com.ayjs.mxzg.message.module.teamArena.message.TeamArenaSignResMessage;
import com.ayjs.mxzg.module.battle.BattleTemplate;
import com.ayjs.mxzg.protocol.BattleGMsg;
import com.ayjs.mxzg.protocol.HeroGMsg;
import com.ayjs.mxzg.protocol.RoleGMsg;
import com.ayjs.mxzg.protocol.TeamArenaGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.ayjs.rpc.annotation.RemoteMethod;
import com.ayjs.rpc.dispatcher.MessageDispatcher;
import com.ayjs.rpc.dispatcher.MessageHandler;
import com.ayjs.rpc.util.ProtostuffUtil;
import com.google.protobuf.InvalidProtocolBufferException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;


/**
 * 组队竞技场
 *
 * @Author: CWJ
 * @Date: 2020/4/9
 **/
@Component
@Slf4j
public class TeamArenaHandler extends ProtocolHandler implements MessageHandler {
    @Autowired
    private TeamArenaService teamArenaService;
    @Autowired
    private TeamArenaBattleRecordService teamArenaBattleRecordService;
    @Autowired
    private RoleService roleService;
    @Autowired
    private TeamArenaRankService teamArenaRankService;
    @Autowired
    private MessageDispatcher messageDispatcher;
    @Autowired
    private BattleHelper battleHelper;
    @Autowired
    private TeamArenaTestHandler teamArenaTestHandler;
    @Autowired
    private CommandBus commandBus;
    @Autowired
    private BattleTemplate battleTemplate;
    @Autowired
    private TeamArenaChallengeRewardSysCache teamArenaChallengeRewardSysCache;
    @Autowired
    private TeamArenaConst teamArenaConst;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private ThingService thingService;
    @Autowired
    private ServerConfig serverConfig;
    @Autowired
    private ClanService clanService;
    @Autowired
    private HeroService heroService;
    @Autowired
    private CrossRoleRedisDao crossRoleRedisDao;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private TeamArenaRedService teamArenaRedService;

//    private Map<Long, List<BattleGMsg.BattleReport>> reportMap = new HashMap<>();
//    private Map<Long, TeamArenaGMsg.GResTeamArenaBattle> resBattleMap = new HashMap<>();

    @CMD(id = CmdCode._66050)
    public void rank(PlayerContext playerContext, TeamArenaGMsg.GReqTeamArenaRank req) {
        Role role = roleService.getOrThrow(playerContext.getId());
        TeamArenaGMsg.GResTeamArenaRank.Builder builder = TeamArenaGMsg.GResTeamArenaRank.newBuilder();
        Long teamId = teamArenaService.getTeamIdByRid(role.getId());
        builder.setSelf(teamArenaRankService.selfRank(teamId == null ? 0 : teamId));
        builder.addAllRankList(teamArenaRankService.showRanks(RankType.TEAM_ARENA.getRankCount()));
        ArenaTeam team = teamArenaService.getTeamByRid(playerContext.getId());
        builder.setHadSign(team == null ? false : team.isHadSign());
        playerContext.write(CmdCode._66050, builder.build());
    }


    @CMD(id = CmdCode._66051)
    public void getState(PlayerContext playerContext, TeamArenaGMsg.GReqTeamArenaState req) {
        TeamArenaTime teamArenaTime = teamArenaService.loadTeamArenaTime();
        if (teamArenaTime == null || teamArenaTime.getCurrState() == null) {
            playerContext.write(CmdCode._66051, TeamArenaGMsg.GResTeamArenaState.getDefaultInstance());
            return;
        }
        TeamArenaGMsg.GResTeamArenaState.Builder builder = TeamArenaGMsg.GResTeamArenaState.newBuilder();
        builder.setCurrState(teamArenaTime.getCurrState().getState());
        builder.setNextStateTime(teamArenaTime.getNextStateTime());
        playerContext.write(CmdCode._66051, builder.build());
    }

    @CMD(id = CmdCode._66052)
    public void getChallengeReward(PlayerContext playerContext, TeamArenaGMsg.GReqTeamArenaGetChallengeReward req) {
        ArenaTeam team = teamArenaService.getTeamByRid(playerContext.getId());
        Asserts.notNull(team, ErrorCode.TEAM_ARENA_NOT_HAD_TEAM.getValue(), "玩家没有加入队伍");

        CTeamArenaChallengeReward config = teamArenaChallengeRewardSysCache.getOrThrow(req.getIdx());

        Asserts.isTrue(team.getHadChallengeCount() >= config.getNeed_count(),
                ErrorCode.TEAM_ARENA_CHALLENGE_COUNT_LOW.getValue(),
                String.format("挑战次数{%s}不足{%s}", team.getHadChallengeCount(), config.getNeed_count()));

        Set<Integer> rewardIds = team.getMemberReward().get(playerContext.getId());
        if (Objects.isNull(rewardIds)) {
            rewardIds = new HashSet<>();
            team.getMemberReward().put(playerContext.getId(), rewardIds);
        }

        Asserts.isTrue(!rewardIds.contains(req.getIdx()), ErrorCode.TEAM_ARENA_REWARD_HAD_GET.getValue(),
                String.format("奖励已经领取{%s}-{%s}", rewardIds, req.getIdx()));

        rewardIds.add(req.getIdx());
        teamArenaService.update(team);

        thingService.add(playerContext.getId(), config.getReward(), GameEvent.TEAM_ARENA_CHALLENGE);

        playerContext.write(CmdCode._66052, TeamArenaGMsg.GResTeamArenaGetChallengeReward.getDefaultInstance());
        teamArenaRedService.sendRedState(playerContext.getId());
    }

    private BattlerVo resetHp(BattlerVo battlerVo, Map<Long, HeroHpInfo> heroHpInfoMap) {
        if (Objects.nonNull(heroHpInfoMap)) {
            for (HeroVo heroVo : battlerVo.getHeros()) {
                if (heroHpInfoMap.containsKey(heroVo.getId())) {
                    heroVo.getAttributes().put(AttributeType.HP.getValue(), Math.max(0, heroHpInfoMap.get(heroVo.getId()).getCurrentHp()));
                }
            }
        }
        return battlerVo;
    }

    @CMD(id = CmdCode._66053)
    public void getDefend(PlayerContext playerContext, TeamArenaGMsg.GReqGetDefendTeam req) {
        teamArenaService.checkAction(RoleAction.GET_DEFEND);
        ArenaTeam team = teamArenaService.getTeamByRid(playerContext.getId());

        Asserts.notNull(team, ErrorCode.TEAM_ARENA_NOT_HAD_TEAM.getValue(), String.format("玩家未加入队伍{%s}", playerContext.getId()));
        Asserts.isTrue(playerContext.getId() == team.getCaptainId(), ErrorCode.TEAM_ARENA_NOT_CAPTAIN.getValue(),
                String.format("玩家{%s}不是队长{%s}", playerContext.getId(), team.getCaptainId()));

        Asserts.isTrue(team.isHadSign(), ErrorCode.TEAM_ARENA_HAD_SIGN.getValue(), String.format("队伍未报名{%s}", team.isHadSign()));

        TeamArenaGMsg.GResGetDefendTeam.Builder builder = TeamArenaGMsg.GResGetDefendTeam.newBuilder();
        for (TeamArenaRankData teamArenaRankData : team.getDefends()) {
            builder.addTeam(teamArenaService.builderSimpleTeamPb(teamArenaRankData));
        }
        playerContext.write(CmdCode._66053, builder.build());

    }

    @CMD(id = CmdCode._66054)
    public void sign(PlayerContext playerContext, TeamArenaGMsg.GReqGetDefendTeam req) {

        teamArenaService.checkAction(RoleAction.SIGN);

        ArenaTeam team = teamArenaService.getTeamByRid(playerContext.getId());
        Asserts.isTrue(!team.isHadSign(), ErrorCode.TEAM_ARENA_HAD_SIGN.getValue(), String.format("队伍已经报名{%s}", team.isHadSign()));

        Asserts.isTrue(team.getMembers().size() >= teamArenaService.getMemberMaxNum(),
                ErrorCode.TEAM_ARENA_MEMBER_LOW.getValue(), String.format("队伍成员不足{%s}", team.getMembers().size()));

        doSign(playerContext, team);

        team.getMembers().forEach(member -> {
            PlayerContext online = contextManager.getOnline(member.getRid());
            if (online != null) {
                getData(online, TeamArenaGMsg.GReqTeamArenaData.getDefaultInstance());
            }
        });


    }

    private void doSign(PlayerContext playerContext, ArenaTeam team) {
        team.setHadSign(true);
        teamArenaService.update(team);

        TeamArenaSignReqMessage.TeamArenaSignReqMessageBuilder remoteBuilder = TeamArenaSignReqMessage.builder();
        remoteBuilder.teamId(team.getTeamId());
        remoteBuilder.captainId(team.getCaptainId());
        remoteBuilder.members(team.getMembers());
        remoteBuilder.teamName(team.getTeamName());
        remoteBuilder.createTime(team.getCreateTime());
        TeamArenaGMsg.GResTeamArenaSign.Builder builder = TeamArenaGMsg.GResTeamArenaSign.newBuilder();
        builder.setTeam(teamArenaService.builderTeamPB(team));
        if (playerContext != null) {
            playerContext.write(CmdCode._66054, builder.build());
        }

        messageDispatcher.dispatch(remoteBuilder.build(), response -> {
            TeamArenaSignResMessage res = (TeamArenaSignResMessage) response;
            List<TeamArenaRankData> defend = res.getDefend();
            team.setDefends(defend == null ? new ArrayList<>() : defend);
            teamArenaService.update(team);

            if (playerContext != null) {
                rank(playerContext, TeamArenaGMsg.GReqTeamArenaRank.getDefaultInstance());
            }
        });
    }

    @CMD(id = CmdCode._66055)
    public void refreshDefend(PlayerContext playerContext, TeamArenaGMsg.GReqGetDefendTeam req) {
        teamArenaService.checkAction(RoleAction.GET_DEFEND);

        TeamArenaTime teamArenaTime = teamArenaService.loadTeamArenaTime();

        Asserts.isTrue(teamArenaTime.getCurrState() != null && teamArenaTime.getCurrState().canAction(RoleAction.SIGN),
                ErrorCode.TEAM_ARENA_STATE_ILLEGAL.getValue(),
                String.format("组队竞技场状态错误：{%s}，不允许该操作{%s}", teamArenaTime.getCurrState(), RoleAction.SIGN));

        ArenaTeam team = teamArenaService.getTeamByRid(playerContext.getId());
        Asserts.isTrue(team.isHadSign(), ErrorCode.TEAM_ARENA_HAD_SIGN.getValue(), String.format("队伍未报名{%s}", team.isHadSign()));

        TeamArenaRefreshDefendReqMessage.TeamArenaRefreshDefendReqMessageBuilder remoteBuilder = TeamArenaRefreshDefendReqMessage.builder();
        remoteBuilder.teamId(team.getTeamId());

        messageDispatcher.dispatch(remoteBuilder.build(), response -> {
            TeamArenaRefreshDefendResMessage res = (TeamArenaRefreshDefendResMessage) response;
            team.setDefends(res.getDefend() == null ? new ArrayList<>() : res.getDefend());
            teamArenaService.update(team);

            TeamArenaGMsg.GResTeamArenaRefreshDefend.Builder builder = TeamArenaGMsg.GResTeamArenaRefreshDefend.newBuilder();
            for (TeamArenaRankData teamArenaRankData : res.getDefend()) {
                builder.addDefend(teamArenaService.builderSimpleTeamPb(teamArenaRankData));
            }
            playerContext.write(CmdCode._66055, builder.build());
        });

    }

    @CMD(id = CmdCode._66056)
    public void battle(PlayerContext playerContext, TeamArenaGMsg.GReqTeamArenaBattle req) {

        teamArenaService.checkAction(RoleAction.BATTLE);

        ArenaTeam team = teamArenaService.getTeamByRid(playerContext.getId());

        Asserts.notNull(team, ErrorCode.TEAM_ARENA_NOT_HAD_TEAM.getValue(), String.format("玩家未加入队伍{%s}", playerContext.getId()));
        Asserts.isTrue(playerContext.getId() == team.getCaptainId(), ErrorCode.TEAM_ARENA_NOT_CAPTAIN.getValue(),
                String.format("玩家{%s}不是队长{%s}", playerContext.getId(), team.getCaptainId()));

        Asserts.isTrue(team.isHadSign(), ErrorCode.TEAM_ARENA_NOT_SIGN.getValue(),
                String.format("队伍没有报名{%s}", team.isHadSign()));

        TeamArenaRankData defend = team.getDefends().stream().filter(defendTemp ->
                defendTemp.getTeamData().getTeamId() == req.getDefendTeamId()).findFirst().orElse(null);
        Asserts.notNull(defend, ErrorCode.TEAM_ARENA_NOT_SIGN.getValue(),
                String.format("队伍没有报名{%s}", team.isHadSign()));

        Asserts.isTrue(team.getCanChallengeCount() > 0, ErrorCode.TEAM_ARENA_CHALLENGE_COUNT_LOW.getValue(),
                String.format("挑战次数不足{%s}", team.getCanChallengeCount()));

        List<BattlerVo> attackVos = new ArrayList<>();
        team.getMembers().forEach(member -> {
            BattlerDo battlerDo = battleHelper.queryPlayerBattler(teamArenaService.getLineUpType(member.getRid()), member.getRid(), Faction.ATTACKER);
            attackVos.add(battlerDo.toBattlerVo());
        });

        TeamArenaLineUpReqMessage reqMessage = new TeamArenaLineUpReqMessage();
        reqMessage.setTeamId(req.getDefendTeamId());
        reqMessage.setServerId(defend.getTeamData().getServerId());
        messageDispatcher.dispatch(reqMessage, response -> {
            if (team.getCanChallengeCount() <= 0) {
                return;
            }

            TeamArenaLineUpResMessage defendMessage = (TeamArenaLineUpResMessage) response;
            boolean win = false;
            List<BattleGMsg.BattleReport> reports = new ArrayList<>();
            List<byte[]> battleVoBytes = defendMessage.getBattleVos();
            List<BattlerVo> defendVos = new ArrayList<>();
            if (CollectionUtil.isNotEmpty(battleVoBytes)) {
                battleVoBytes.forEach(battleVoByte -> {
                    defendVos.add(ProtostuffUtil.deserialize(battleVoByte, BattlerVo.class));
                });
            } else {
                log.error("获取队伍{}阵容失败", defendMessage.getTeamId());
            }
            if (defendVos.size() <= 0) {
                log.error("获取队伍{}阵容失败", defendMessage.getTeamId());
                return;
            }
            int attackIndex = 0;
            int defendIndex = 0;
            Map<Long, HeroHpInfo> attackerHpInfo = null;
            Map<Long, HeroHpInfo> defendHpInfo = null;

            int battleTime = TimeDateUtil.getCurrentTimeInt();
            while (attackIndex < attackVos.size() && defendIndex < defendVos.size()) {
                BattlerVo attackVo = resetHp(attackVos.get(attackIndex), attackerHpInfo);
                BattlerVo defendVo = resetHp(defendVos.get(defendIndex), defendHpInfo);

                ArenaTeamMember attackMember = team.getMembers().get(attackIndex);
                Role memberRole = roleService.getOrThrow(attackMember.getRid());
                BattlerDo attack = battleTemplate.queryBattler(attackVo, memberRole.getNick(), Faction.ATTACKER, UnitType.HERO);
                attack.setRoleInfo(memberRole.getServerId(), memberRole.getHeadId(), memberRole.getBorderId(), memberRole.getLevel(),
                        attackMember.getFighting());

                ArenaTeamMember defendMember = defend.getTeamData().getMembers().get(defendIndex);
                RoleSimpleMessage defendRole = defend.getTeamData().getSimpleMap().get(defendMember.getRid());
                BattlerDo defender = battleTemplate.queryBattler(defendVo, defendRole.getRoleName(), Faction.DEFENDER, UnitType.HERO);

                defender.setRoleInfo(defendRole.getServerId(), defendRole.getHeadId(), defendRole.getBorderId(),
                        defendRole.getLevel(), defendMessage.getFighting().get(defendIndex));

                BattleCommand battleCommand = BattleCommand.createOf(BattleType.TEAM_ARENA, attack, defender);
                commandBus.invoke(battleCommand);

                if (battleCommand.getResult().isWin()) {
                    defendIndex++;
                    try {
                        attackerHpInfo = battleCommand.getResult().getHeroByFaction(Faction.ATTACKER).stream().
                                collect(Collectors.toMap(HeroDo::getId, HeroHpInfo::createOf));
                    } catch (Exception e) {
                        log.error("血量转化异常{}", GsonUtils.toJson(battleCommand.getResult().getHeroByFaction(Faction.DEFENDER)));
                        return;
                    }
                    defendHpInfo = null;
                    if (defendIndex >= defendVos.size()) {
                        win = true;
                    }
                } else {
                    attackIndex++;
                    attackerHpInfo = null;
                    try {
                        defendHpInfo = battleCommand.getResult().getHeroByFaction(Faction.DEFENDER).stream().
                                collect(Collectors.toMap(HeroDo::getId, HeroHpInfo::createOf));
                    } catch (Exception e) {
                        log.error("血量转化异常{}", GsonUtils.toJson(battleCommand.getResult().getHeroByFaction(Faction.DEFENDER)));
                        return;
                    }

                }
                reports.add(battleCommand.getReport());
            }
            if (reports.size() == 0) {
                log.error("战报为空！{}-{}", JsonUtil.toJson(team), JsonUtil.toJson(defend));
                return;
            }
            team.setHadChallengeCount(team.getHadChallengeCount() + 1);
            if (team.getCanChallengeCount() >= teamArenaConst.getTeamArenaTimesMax()) {
                team.setLastAddTime(TimeDateUtil.getCurrentTimeInt());
            }
            team.setCanChallengeCount(team.getCanChallengeCount() - 1);
            teamArenaService.update(team);

            TeamArenaBattleReqMessage battleReq = new TeamArenaBattleReqMessage();
            battleReq.setDefendTeamId(defend.getTeamData().getTeamId());
            battleReq.setTeamId(team.getTeamId());
            battleReq.setWin(win);

            messageDispatcher.dispatch(battleReq, battleRes -> {

                TeamArenaBattleResMessage battleResMessage = (TeamArenaBattleResMessage) battleRes;
                TeamArenaGMsg.GResTeamArenaBattle.Builder builder = TeamArenaGMsg.GResTeamArenaBattle.newBuilder();
                int addScore = battleResMessage.getAddScore();
                team.setScore(battleResMessage.getScore());
                defend.setScore(battleResMessage.getDefScore());
                teamArenaService.update(team);

                int defendAddRank = battleResMessage.getDefendAddRank();

                builder.setAttackAddScore(addScore);
                builder.setAttackTeam(teamArenaService.builderSimpleTeamPb(team));
                builder.setAttackRank(battleResMessage.getRank());
                builder.setAttackScore(battleResMessage.getScore());
                builder.setAttackAddRank(battleResMessage.getAddRank());

                builder.setDefendRank(battleResMessage.getDefendNewRank());
                builder.setDefendAddRank(defendAddRank);
                builder.setDefendTeam(teamArenaService.builderSimpleTeamPb(defend));
                builder.setDefendScore(defend.getScore());
                builder.setDefendReduceScore(battleResMessage.getDefReduceScore());

                builder.setReport(reports.get(0));
                builder.setReportSum(reports.size() - 1);
                builder.setReportIndex(0);

                defend.setRank(battleResMessage.getDefendNewRank());
                long winTeamId = battleReq.isWin() ? team.getTeamId() : defend.getTeamData().getTeamId();

                eventBus.post(TeamArenaRecordEvent.of(reports, winTeamId, battleResMessage.getAddRank(), addScore,
                        battleTime, defendAddRank, teamArenaService.builderTeamRankData(team, battleResMessage.getRank()),
                        defend, battleResMessage.getDefReduceScore()));

                TeamArenaGMsg.GResTeamArenaBattle resBuilder = builder.build();
                teamArenaService.getReportMap().put(team.getTeamId(), reports);
                teamArenaService.getResBattleMap().put(team.getTeamId(), resBuilder);

                playerContext.write(CmdCode._66056, resBuilder);

                teamArenaService.broadcastTeam(team);
                teamArenaRedService.sendRedState(playerContext.getId());
            });
        });

    }

    @CMD(id = CmdCode._66057)
    public void battleReport(PlayerContext playerContext, TeamArenaGMsg.GReqTeamArenaBattleReport req) {
        Long teamId = teamArenaService.getTeamIdByRid(playerContext.getId());
        TeamArenaGMsg.GResTeamArenaBattle resBattle = teamArenaService.getResBattleMap().get(teamId);
        Asserts.notNull(resBattle, ErrorCode.SYSTEM_ERROR.getValue(), String.format("不存在战报{%s}", req.getTeamId()));
        List<BattleGMsg.BattleReport> battleReports = teamArenaService.getReportMap().get(teamId);
        Asserts.notNull(battleReports, ErrorCode.SYSTEM_ERROR.getValue(), "不存在战报");
        Asserts.isTrue(req.getReportIndex() < battleReports.size() && req.getReportIndex() > 0,
                ErrorCode.SYSTEM_ERROR.getValue(), "不存在战报");

        TeamArenaGMsg.GResTeamArenaBattleReport.Builder builder = TeamArenaGMsg.GResTeamArenaBattleReport.newBuilder();

        builder.setAttackAddScore(resBattle.getAttackAddScore());
        builder.setAttackTeam(resBattle.getAttackTeam());
        builder.setAttackRank(resBattle.getAttackRank());
        builder.setAttackScore(resBattle.getAttackScore());
        builder.setAttackAddRank(resBattle.getAttackAddRank());

        builder.setDefendAddRank(resBattle.getDefendAddRank());
        builder.setDefendRank(resBattle.getDefendRank());
        builder.setDefendScore(resBattle.getDefendScore());
        builder.setDefendReduceScore(resBattle.getDefendReduceScore());

        builder.setReport(battleReports.get(req.getReportIndex()));
        builder.setReportSum(battleReports.size() - 1);
        builder.setReportIndex(req.getReportIndex());

        playerContext.write(CmdCode._66057, builder.build());
        if (req.getReportIndex() >= battleReports.size() - 1) {
            teamArenaService.getResBattleMap().remove(teamId);
            teamArenaService.getReportMap().remove(teamId);
        }
    }

    @CMD(id = CmdCode._66058)
    public void battleRecord(PlayerContext playerContext, TeamArenaGMsg.GReqTeamArenaBattleRecord req) {
        Long teamId = teamArenaService.getTeamIdByRid(playerContext.getId());
        if (teamId == null) {
            playerContext.write(CmdCode._66058, TeamArenaGMsg.GResTeamArenaBattleRecord.getDefaultInstance());
            return;
        }

        Asserts.notNull(teamId, ErrorCode.TEAM_ARENA_NOT_HAD_TEAM.getValue(), String.format("玩家未加入队伍{%s}", playerContext.getId()));
        List<ArenaTeamBattleRecord> teamRecord = teamArenaBattleRecordService.getTeamRecord(teamId);
        TeamArenaGMsg.GResTeamArenaBattleRecord.Builder builder = TeamArenaGMsg.GResTeamArenaBattleRecord.newBuilder();
        teamRecord.forEach(record -> {
            TeamArenaGMsg.PBTeamArenaBattleRecord.Builder recordBuilder = TeamArenaGMsg.PBTeamArenaBattleRecord.newBuilder();
            recordBuilder.setRecordId(record.getId());
            recordBuilder.setAttackAddRank(record.getAddRank());
            recordBuilder.setAddScore(record.getAddScore());
            recordBuilder.setAttackTeam(teamArenaService.builderRank(record.getAttack()));

            recordBuilder.setDefendAddRank(record.getDefendAddRank());
            recordBuilder.setDefendTeam(teamArenaService.builderRank(record.getDefend()));
            recordBuilder.setDefendReduceScore(record.getDefendReduceScore());

            recordBuilder.setWinTeamId(record.getWinTeamId());
            recordBuilder.setBattleTime(record.getBattleTime());
            builder.addRecord(recordBuilder);
        });
        playerContext.write(CmdCode._66058, builder.build());
    }


    @CMD(id = CmdCode._66059)
    public void battleRecordDetail(PlayerContext playerContext, TeamArenaGMsg.GReqTeamArenaBattleRecordDetail req) {
        Long teamId = teamArenaService.getTeamIdByRid(playerContext.getId());
        Asserts.notNull(teamId, ErrorCode.TEAM_ARENA_NOT_HAD_TEAM.getValue(), String.format("玩家未加入队伍{%s}", playerContext.getId()));
        List<ArenaTeamBattleRecordDetail> teamRecordDetails = teamArenaBattleRecordService.getDetails(req.getRecordId());
        TeamArenaGMsg.GResTeamArenaBattleRecordDetail.Builder builder = TeamArenaGMsg.GResTeamArenaBattleRecordDetail.newBuilder();
        teamRecordDetails.forEach(detail -> {
            TeamArenaGMsg.PBTeamArenaBattleRecordDetail.Builder recordBuilder = TeamArenaGMsg.PBTeamArenaBattleRecordDetail.newBuilder();
            recordBuilder.setBattleReportId(detail.getReportId());
            recordBuilder.setBattleLog(detail.getBattleLog());
            recordBuilder.setAttackTeamName(detail.getAttackTeamName());
            recordBuilder.setDefendTeamName(detail.getDefendTeamName());
            recordBuilder.setBattleTime(detail.getBattleTime());
            recordBuilder.setBattleRound(detail.getBattleRound());
            builder.addDetail(recordBuilder);
        });
        playerContext.write(CmdCode._66059, builder.build());
    }

    @CMD(id = CmdCode._66060)
    public void getData(PlayerContext playerContext, TeamArenaGMsg.GReqTeamArenaData req) {
        ArenaTeam team = teamArenaService.getTeamByRid(playerContext.getId());
        if (team == null) {
            playerContext.write(CmdCode._66060, TeamArenaGMsg.GResTeamArenaData.getDefaultInstance());
            return;
        }

        TeamArenaGMsg.GResTeamArenaData.Builder builder = TeamArenaGMsg.GResTeamArenaData.newBuilder();
        builder.setChallengeCount(team.getCanChallengeCount());
        builder.setLastAddTime(team.getLastAddTime());
        builder.setHadChallengeCount(team.getHadChallengeCount());
        Set<Integer> rewardIds = team.getMemberReward().get(playerContext.getId());
        if (rewardIds != null) {
            builder.addAllRewardIdx(rewardIds);
        }
        playerContext.write(CmdCode._66060, builder.build());
    }

    @CMD(id = CmdCode._66061)
    public void roleInfo(PlayerContext playerContext, TeamArenaGMsg.GReqTeamArenaRankRoleInfo req) {
        long rid = req.getRoleId();
        if (rid <= 0) {
            // 参数错误
            playerContext.writeError(ErrorCode.ERROR_PARAM, rid);
            return;
        }
        int serverId = req.getServerId();
        RoleGMsg.GResPlayerDetaile.Builder builder = RoleGMsg.GResPlayerDetaile.newBuilder();
        // 本服还是跨服数据
        if (serverId == 0 || serverConfig.matchServerId(serverId)) {
            Role otherRole = roleService.getOrThrow(rid);
            builder.setPlayerId(otherRole.getId());
            builder.setClanId(otherRole.getClanId());
            builder.setLevel(otherRole.getLevel());
            builder.setRank(otherRole.getArenaScore());
            builder.setServerId(otherRole.getServerId());
            builder.setHeadId(otherRole.getHeadId());
            builder.setBorderId(otherRole.getBorderId());
            builder.setNick(otherRole.getNick());
            if (otherRole.getClanId() > 0) {
                Clan clan = clanService.getOrThrow(otherRole.getClanId());
                if (clan != null) {
                    builder.setClanName(clan.getClanName());
                }
            }
            builder.setFighting(otherRole.getFighting());

            HeroLineUp heroLineUp = teamArenaService.getLineUp(req.getRoleId());
            for (HeroPosition hpos : heroLineUp.getFormationMap().values()) {
                Hero hero = heroService.getHero(otherRole.getId(), hpos.getHeroId());
                if (hero != null) {
                    builder.addHeroData(heroService.serializeBriefData(hero, hpos.getPos()));
                }
            }
            playerContext.write(CmdCode._2004, builder.build());
        } else {
            TeamArenaGetMemberLineUpReqMessage message = new TeamArenaGetMemberLineUpReqMessage();
            message.setRoleId(req.getRoleId());
            message.setServerId(req.getServerId());

            messageDispatcher.dispatch(message, response -> {
                TeamArenaGetMemberLineUpResMessage resMessage = (TeamArenaGetMemberLineUpResMessage) response;
                CrossRole crossRole = crossRoleRedisDao.get(rid);
                Asserts.isTrue(Objects.nonNull(crossRole) && crossRole.getId() > 0,
                        ErrorCode.ROLE_NOT_EXIST.getValue(),
                        () -> String.format("cross role is null rid:%s serverId:%s", rid, serverId));
                builder.setPlayerId(rid);
                builder.setHeadId(crossRole.getHeadId());
                builder.setClanId(crossRole.getClanId());
                builder.setNick(crossRole.getNick());
                builder.setLevel(crossRole.getLevel());
                builder.setServerId(crossRole.getServerId());
                if (Objects.nonNull(crossRole.getClanName())) {
                    builder.setClanName(crossRole.getClanName());
                }
                builder.setRank(crossRole.getArenaScore());
                builder.setFighting(crossRole.getFighting());
                if (CollectionUtil.isNotEmpty(resMessage.getLineUp())) {
                    resMessage.getLineUp().forEach(heroByte -> {
                        try {
                            builder.addHeroData(HeroGMsg.ResHeroBriefData.parseFrom(heroByte));
                        } catch (InvalidProtocolBufferException e) {
                            throw new ErrorCodeException(ErrorCode.TEAM_ARENA_LINE_UP_ERROR.getValue(), "获取阵容失败" + req.getRoleId());
                        }
                    });

                }
                builder.setBorderId(crossRole.getBorderId());
                playerContext.write(CmdCode._2004, builder.build());
            });

        }
    }

    @RemoteMethod
    public TeamArenaLineUpResMessage getLineUp(TeamArenaLineUpReqMessage req) {
        TeamArenaLineUpResMessage.TeamArenaLineUpResMessageBuilder builder = TeamArenaLineUpResMessage.builder();
        ArenaTeam team = teamArenaService.get(req.getTeamId());
        if (Objects.nonNull(team)) {
            List<byte[]> vos = teamArenaService.builderTeamVos(team);
            List<Integer> fightingList = teamArenaService.builderFightingList(team);
            builder.teamId(req.getTeamId());
            builder.battleVos(vos);
            builder.fighting(fightingList);
            builder.attackTeam(req.getAttackTeam());
        }
        return builder.build();
    }

    @RemoteMethod
    public void defend(TeamArenaDefendResMessage req) {
        ArenaTeam team = teamArenaService.get(req.getDefendTeamId());
        team.setScore(req.getDefendNewScore());
        teamArenaService.update(team);
        teamArenaService.broadcastTeam(team);
    }

    @RemoteMethod
    public TeamArenaGetMemberLineUpResMessage getMemberLineUp(TeamArenaGetMemberLineUpReqMessage req) {
        TeamArenaGetMemberLineUpResMessage res = new TeamArenaGetMemberLineUpResMessage();

        HeroLineUp heroLineUp = teamArenaService.getLineUp(req.getRoleId());
        for (HeroPosition hpos : heroLineUp.getFormationMap().values()) {
            Hero hero = heroService.getHero(req.getRoleId(), hpos.getHeroId());
            if (hero != null) {
                res.getLineUp().add(heroService.serializeBriefData(hero, hpos.getPos()).toByteArray());
            }
        }
        return res;
    }

    @RemoteMethod
    public void updateState(TeamArenaChangeStateReqMessage req) {
        teamArenaService.setNewState(req.getTime());
    }

    @GMCommand(command = GMCmdCode.TEAM_ARENA_SET_STATE)
    public void setState(Role role, List<String> param) {
        Integer state = Integer.valueOf(param.get(0));
        messageDispatcher.dispatch(TeamArenaGMReqMessage.createOf(TeamArenaState.stateOf(state)));
    }

    @GMCommand(command = GMCmdCode.TEAM_ARENA_CREATE)
    public void create(Role role, List<String> param) {
        if (param.size() > 0) {
            teamArenaTestHandler.buildTestTeam(role);
        } else {
            teamArenaTestHandler.buildTestEnviroment();
        }
    }

    @GMCommand(command = GMCmdCode.TEAM_ARENA_ONE_KEY)
    public void oneKey(Role role, List<String> param) {
        messageDispatcher.dispatch(TeamArenaGMReqMessage.createOf(TeamArenaState.CHALLENGE));
        teamArenaTestHandler.buildTestEnviroment();
        teamArenaTestHandler.buildTestTeam(role);
        signAll(role, param);
    }

    @GMCommand(command = GMCmdCode.TEAM_ARENA_SIGN)
    public void signAll(Role role, List<String> param) {
        List<ArenaTeam> all = teamArenaService.getAll();
        all = all.stream().filter(team -> !team.isHadSign() && team.getMembers().size() >= 3).collect(Collectors.toList());
        all.forEach(team -> {
            doSign(null, team);
        });
    }

    @GMCommand(command = GMCmdCode.TEAM_ARENA_ADD_COUNT)
    public void addCount(Role role, List<String> param) {
        ArenaTeam team = teamArenaService.getTeamByRid(role.getId());
        team.setCanChallengeCount(100);
        teamArenaService.update(team);
    }

    @Subscribe(async = Subscribe.AsyncType.Async)
    public void listen(CrossConnectedEvent event) {
        teamArenaService.settle();
        messageDispatcher.dispatch(new TeamArenaGetStateReqMessage(), res -> {
            TeamArenaChangeStateReqMessage req = (TeamArenaChangeStateReqMessage) res;
            teamArenaService.setNewState(req.getTime());
        });
    }

}
