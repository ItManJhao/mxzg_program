package com.ayjs.mxzg.gameserver.module.teamArena.service;

import cn.hutool.core.collection.CollectionUtil;
import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.Faction;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.lifecycle.Lifecycle;
import com.ayjs.mxzg.common.lifecycle.LifecycleInfo;
import com.ayjs.mxzg.common.lifecycle.Ordinal;
import com.ayjs.mxzg.common.lifecycle.Priority;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.GJsonUtils;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.teamArena.TeamArenaChallengeRewardSysCache;
import com.ayjs.mxzg.config.excel.cache.teamArena.TeamArenaConst;
import com.ayjs.mxzg.config.excel.cache.teamArena.TeamArenaRankRewardSysCache;
import com.ayjs.mxzg.config.excel.entity.teamArena.CTeamArenaChallengeReward;
import com.ayjs.mxzg.config.excel.entity.teamArena.CTeamArenaRankReward;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.ImmutableThing;
import com.ayjs.mxzg.config.struct.ImmutableThingUtil;
import com.ayjs.mxzg.config.struct.LineUpType;
import com.ayjs.mxzg.gameserver.infrastructure.constant.ServerConfig;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.battle.BattleHelper;
import com.ayjs.mxzg.gameserver.module.hero.domain.Hero;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroLineUp;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroLineUpService;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.hero.struct.HeroPosition;
import com.ayjs.mxzg.gameserver.module.mail.constant.MailScene;
import com.ayjs.mxzg.gameserver.module.mail.domain.Mail;
import com.ayjs.mxzg.gameserver.module.mail.service.MailService;
import com.ayjs.mxzg.gameserver.module.mail.struct.MailParams;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.server.constant.ServerParamType;
import com.ayjs.mxzg.gameserver.module.server.service.ServerParamService;
import com.ayjs.mxzg.gameserver.module.teamArena.dao.ArenaTeamApplyDao;
import com.ayjs.mxzg.gameserver.module.teamArena.dao.ArenaTeamBattleRecordDao;
import com.ayjs.mxzg.gameserver.module.teamArena.dao.ArenaTeamDao;
import com.ayjs.mxzg.gameserver.module.teamArena.dao.ArenaTeamInviteDao;
import com.ayjs.mxzg.gameserver.module.teamArena.domain.ArenaTeam;
import com.ayjs.mxzg.gameserver.module.teamArena.domain.ArenaTeamApply;
import com.ayjs.mxzg.gameserver.module.teamArena.domain.ArenaTeamBattleRecord;
import com.ayjs.mxzg.gameserver.module.teamArena.domain.ArenaTeamInvite;
import com.ayjs.mxzg.gameserver.module.teamArena.event.TeamArenaSettleEvent;
import com.ayjs.mxzg.gameserver.module.teamArena.event.TeamArenaStateChangeEvent;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.message.module.teamArena.domain.ArenaTeamData;
import com.ayjs.mxzg.message.module.teamArena.domain.ArenaTeamMember;
import com.ayjs.mxzg.message.module.teamArena.domain.RoleAction;
import com.ayjs.mxzg.message.module.teamArena.domain.RoleSimpleMessage;
import com.ayjs.mxzg.message.module.teamArena.domain.TeamArenaRankData;
import com.ayjs.mxzg.message.module.teamArena.domain.TeamArenaState;
import com.ayjs.mxzg.message.module.teamArena.domain.TeamArenaTime;
import com.ayjs.mxzg.message.module.teamArena.message.TeamArenaSettleRecordReqMessage;
import com.ayjs.mxzg.message.module.teamArena.message.TeamArenaSettleRecordResMessage;
import com.ayjs.mxzg.message.module.teamArena.message.TeamArenaUpdateTeamReqMessage;
import com.ayjs.mxzg.protocol.BattleGMsg;
import com.ayjs.mxzg.protocol.HeroPalaceGMsg;
import com.ayjs.mxzg.protocol.TeamArenaGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.ayjs.rpc.dispatcher.MessageDispatcher;
import com.ayjs.rpc.util.ProtostuffUtil;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.Lists;
import lombok.Getter;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;
import java.util.stream.Collectors;

/**
 * @Author: CWJ
 * @Date: 2020/4/9
 **/
@Service
@Slf4j
public class TeamArenaService implements Lifecycle {

    @Autowired
    private ArenaTeamDao arenaTeamDao;
    @Autowired
    private ArenaTeamApplyDao arenaTeamApplyDao;
    @Autowired
    private ArenaTeamInviteDao arenaTeamInviteDao;
    @Autowired
    private RoleService roleService;
    @Autowired
    private HeroLineUpService heroLineUpService;
    @Autowired
    private HeroService heroService;
    @Autowired
    private ServerParamService serverParamService;
    @Autowired
    private MailService mailService;
    @Autowired
    private ArenaTeamBattleRecordDao arenaTeamBattleRecordDao;
    @Autowired
    private TeamArenaBattleRecordService teamArenaBattleRecordService;
    @Autowired
    private TeamArenaConst teamArenaConst;
    @Autowired
    private BattleHelper battleHelper;
    @Autowired
    private TeamArenaRankService teamArenaRankService;
    @Autowired
    private ContextManager contextManager;

    @Getter
    private ConcurrentMap<Long, Long> role2Team = new ConcurrentHashMap<>();
    @Autowired
    private MessageDispatcher messageDispatcher;
    @Autowired
    private ServerConfig serverConfig;
    @Autowired
    private TeamArenaRankRewardSysCache teamArenaRankRewardSysCache;
    @Autowired
    private TeamArenaChallengeRewardSysCache teamArenaChallengeRewardSysCache;
    @Autowired
    private EventBus eventBus;
    @Autowired
    private TeamArenaRedService teamArenaRedService;


    //先锁队伍，再锁玩家
    public static final String TEAM_ARENA_ROLE = "TEAM_ARENA_ROLE";
    public static final String TEAM_ARENA_TEAM = "TEAM_ARENA_TEAM";

    @Getter
    private Map<Long, List<BattleGMsg.BattleReport>> reportMap = new HashMap<>();
    @Getter
    private Map<Long, TeamArenaGMsg.GResTeamArenaBattle> resBattleMap = new HashMap<>();

    @Override
    public LifecycleInfo getInfo() {
        return LifecycleInfo.valueOf(Priority.MEDIUM, Ordinal._1, String.format("TEAM_ARENA"));
    }

    @Override
    public void start() throws Exception {
        List<ArenaTeam> arenaTeams = arenaTeamDao.listAll();
        arenaTeams.forEach(team -> {
            team.getMembers().forEach(member -> {
                Long old = role2Team.put(member.getRid(), team.getTeamId());
                if (Objects.nonNull(old)) {
                    throw new RuntimeException("one player join two team,you need fix the data");
                }
            });
        });
    }

    public TeamArenaTime loadTeamArenaTime() {
        return serverParamService.getOrCreate(ServerParamType.TEAM_ARENA, () -> new TeamArenaTime()).parseJson(TeamArenaTime.class);
    }

    public void updateTeamArenaTime(TeamArenaTime entity) {
        serverParamService.save(ServerParamType.TEAM_ARENA, () -> entity);
    }

    public ArenaTeam get(long teamId) {
        if (teamId == 0) {
            log.info("try to get entity ,the id={}", teamId);
            return null;
        }
        ArenaTeam team = arenaTeamDao.get(teamId);
        if (team == null) {
            return null;
        }

        TeamArenaTime teamArenaTime = loadTeamArenaTime();
        if (team.getCanChallengeCount() < teamArenaConst.getTeamArenaTimesMax() &&
                teamArenaTime.getCurrState() == TeamArenaState.CHALLENGE) {
            int now = TimeDateUtil.getCurrentTimeInt();
            if (team.getLastAddTime() < loadTeamArenaTime().getStateChangeTime()) {
                team.setLastAddTime(loadTeamArenaTime().getStateChangeTime());
            }
            int interval = now - team.getLastAddTime();
            int addCount = interval / teamArenaConst.getTeamArenaTimesGetTime();
            if (addCount > 0) {
                team.setCanChallengeCount(team.getCanChallengeCount() + addCount);
                if (team.getCanChallengeCount() >= teamArenaConst.getTeamArenaTimesMax()) {
                    team.setCanChallengeCount(teamArenaConst.getTeamArenaTimesMax());
                    team.setLastAddTime(now);
                } else {
                    team.setLastAddTime(team.getLastAddTime() + addCount * teamArenaConst.getTeamArenaTimesGetTime());
                }
                update(team);
            }
        }

        return team;
    }

    public void update(ArenaTeam team) {
        arenaTeamDao.update(team);
    }

    public void add(ArenaTeam team) {
        arenaTeamDao.add(team);
    }

    public void removeTeams(List<ArenaTeam> teams) {
        arenaTeamDao.remove(teams);
    }

    public ArenaTeam getTeamByRid(long rid) {
        Long teamId = getTeamIdByRid(rid);
        return Objects.isNull(teamId) ? null : get(teamId);
    }

    public Long getTeamIdByRid(long rid) {
        return role2Team.get(rid);
    }

    public List<ArenaTeamApply> getAppliesByRid(long rid) {
        return arenaTeamApplyDao.list("applyId", rid);
    }

    public List<ArenaTeamApply> getAppliesByTeamId(long teamId) {
        return arenaTeamApplyDao.list("teamId", teamId);
    }

    public void removeApplies(List<ArenaTeamApply> entities) {
        arenaTeamApplyDao.remove(entities);
    }

    public void add(ArenaTeamApply apply) {
        arenaTeamApplyDao.add(apply);
    }

    public List<ArenaTeamInvite> getInvitesByRid(long rid) {
        return arenaTeamInviteDao.list("inviteId", rid);
    }

    public List<ArenaTeamInvite> getInvitesByTeamId(long teamId) {
        return arenaTeamInviteDao.list("teamId", teamId);
    }

    public void remove(List<ArenaTeamInvite> entities) {
        arenaTeamInviteDao.remove(entities);
    }

    public void add(ArenaTeamInvite invite) {
        arenaTeamInviteDao.add(invite);
    }

    public void addTeamBattleRecord(ArenaTeamBattleRecord record) {
        arenaTeamBattleRecordDao.add(record);
    }

    public List<ArenaTeam> getAll() {
        return arenaTeamDao.listAll();
    }

    public int getMemberMaxNum() {
        return 3;
    }

    public HeroLineUp getLineUp(long rid) {
        HeroLineUp lineUpByType = heroLineUpService.getLineUpByType(rid, LineUpType.TEAM_ARENA);
        return lineUpByType.getFormationMap().size() != 0 ? lineUpByType : heroLineUpService.getLineUpByType(rid, LineUpType.MAIN);
    }

    public LineUpType getLineUpType(long rid) {
        HeroLineUp lineUpByType = heroLineUpService.getLineUpByType(rid, LineUpType.TEAM_ARENA);
        return lineUpByType.getFormationMap().size() != 0 ? LineUpType.TEAM_ARENA : LineUpType.MAIN;
    }

    public TeamArenaGMsg.PBMemberInfo.Builder builderMember(Long memberId) {
        TeamArenaGMsg.PBMemberInfo.Builder memberBuilder = TeamArenaGMsg.PBMemberInfo.newBuilder();
        memberBuilder.setMember(PbUtil.builderRoleInfo(roleService.getOrThrow(memberId)));

        HeroLineUp heroLineUp = getLineUp(memberId);
        for (HeroPosition hpos : heroLineUp.getFormationMap().values()) {
            Hero hero = heroService.getHero(memberId, hpos.getHeroId());
            if (hero != null) {
                memberBuilder.addHeroData(heroService.serializeBriefData(hero, hpos.getPos()));
            }
        }
        memberBuilder.setFighting(heroLineUpService.getLineUpFighting(heroLineUp));
        memberBuilder.setFormationId(heroLineUp.getFormationId());
        memberBuilder.setGoddessType(heroLineUp.getGoddessType());

        return memberBuilder;
    }

    public HeroPalaceGMsg.PSRoleSimpleInfo.Builder builderSimpleRole(RoleSimpleMessage member) {
        HeroPalaceGMsg.PSRoleSimpleInfo.Builder builder = HeroPalaceGMsg.PSRoleSimpleInfo.newBuilder();
        builder.setLevel(member.getLevel());
        builder.setNick(member.getRoleName());
        builder.setPlayerId(member.getRid());
        builder.setHeadId(member.getHeadId());
        builder.setBorderId(member.getBorderId());
        builder.setServerId(member.getServerId());
        builder.setClanId(member.getClanId());
        builder.setImageId(member.getImage());
        builder.setFighting(member.getFighting());
        return builder;
    }

    /***
     * 队伍详细信息
     * @param team
     * @return
     */
    public TeamArenaGMsg.PBTeam builderTeamPB(ArenaTeam team) {
        TeamArenaGMsg.PBTeam.Builder teamPb = TeamArenaGMsg.PBTeam.newBuilder();
        teamPb.setAutoAgree(team.isAutoAgree());
        teamPb.setCaptainId(team.getCaptainId());
        teamPb.setMinFighting(team.getMinFighting());
        teamPb.setMinLv(team.getMinLv());
        teamPb.setTeamId(team.getTeamId());
        teamPb.setTeamName(team.getTeamName());
        team.getMembers().forEach(member -> {
            TeamArenaGMsg.PBMemberInfo.Builder builder = builderMember(member.getRid());
            builder.setHidden(member.isHidden());
            teamPb.addMember(builder);
        });
        teamPb.setHadSign(team.isHadSign());
        return teamPb.build();
    }

    /***
     * 只有简单的玩家都头像信息
     * @param teamArenaRankData
     * @return
     */
    public TeamArenaGMsg.PBSimpleTeam builderSimpleTeamPb(TeamArenaRankData teamArenaRankData) {
        TeamArenaGMsg.PBSimpleTeam.Builder teamPb = TeamArenaGMsg.PBSimpleTeam.newBuilder();
        teamPb.setTeamId(teamArenaRankData.getTeamData().getTeamId());
        teamPb.setTeamName(teamArenaRankData.getTeamData().getTeamName());
        teamPb.setCaptainId(teamArenaRankData.getTeamData().getCaptainId());
        teamArenaRankData.getTeamData().getMembers().forEach(member -> {
            TeamArenaGMsg.PBMemberSimpleInfo.Builder builder = TeamArenaGMsg.PBMemberSimpleInfo.newBuilder();
            builder.setMember(builderSimpleRole(teamArenaRankData.getTeamData().getSimpleMap().get(member.getRid())));
            builder.setHidden(member.isHidden());
            teamPb.addMember(builder);
        });
        teamPb.setScore(teamArenaRankData.getScore());
        teamPb.setFighting(teamArenaRankData.getTeamData().getMembers().stream().mapToInt(ArenaTeamMember::getFighting).sum());
        return teamPb.build();
    }

    public TeamArenaGMsg.PSTeamArenaRank builderRank(TeamArenaRankData teamArenaRankData) {
        TeamArenaGMsg.PSTeamArenaRank.Builder builder = TeamArenaGMsg.PSTeamArenaRank.newBuilder();
        builder.setRank(teamArenaRankData.getRank());
        builder.setTeamId(teamArenaRankData.getTeamData().getTeamId());
        builder.setScore(teamArenaRankData.getScore());
        builder.setTeamName(teamArenaRankData.getTeamData().getTeamName());
        int sum = 0;
        if (teamArenaRankData.getTeamData().getMembers() == null) {
            log.error("队伍成员为空！" + GJsonUtils.toJson(teamArenaRankData));
        } else {
            for (ArenaTeamMember member : teamArenaRankData.getTeamData().getMembers()) {
                TeamArenaGMsg.PBMemberSimpleInfo.Builder memberBuilder = TeamArenaGMsg.PBMemberSimpleInfo.newBuilder();
                memberBuilder.setMember(builderSimpleRole(teamArenaRankData.getTeamData().getSimpleMap().get(member.getRid())));
                memberBuilder.setHidden(member.isHidden());
                sum += member.getFighting();
                builder.addMember(memberBuilder);
            }
        }
        builder.setCaptainId(teamArenaRankData.getTeamData().getCaptainId());
        builder.setFighting(sum);
        return builder.build();
    }

    /***
     * 只有简单的玩家都头像信息
     * @return
     */
    public TeamArenaGMsg.PBSimpleTeam.Builder builderSimpleTeamPb(ArenaTeam team) {
        TeamArenaGMsg.PBSimpleTeam.Builder teamPb = TeamArenaGMsg.PBSimpleTeam.newBuilder();
        teamPb.setTeamId(team.getTeamId());
        teamPb.setTeamName(team.getTeamName());
        teamPb.setCaptainId(team.getCaptainId());
        team.getMembers().forEach(member -> {
            TeamArenaGMsg.PBMemberSimpleInfo.Builder builder = TeamArenaGMsg.PBMemberSimpleInfo.newBuilder();
            builder.setMember(PbUtil.builderRoleInfo(roleService.getOrThrow(member.getRid())));
            builder.setHidden(member.isHidden());
            teamPb.addMember(builder);
        });
        teamPb.setScore(team.getScore());
        teamPb.setMinFighting(team.getMinFighting());
        teamPb.setMinLv(team.getMinLv());
        teamPb.setFighting(team.getMembers().stream().mapToInt(ArenaTeamMember::getFighting).sum());
        return teamPb;
    }

    public void doJoinTeam(long rid, ArenaTeam team) {
        ArenaTeamMember member = createMember(rid, false);

        team.getMembers().add(member);
        update(team);
        getRole2Team().put(rid, team.getTeamId());

        if (team.getMembers().size() >= getMemberMaxNum()) {
            Mail mail = mailService.newSimpleMail(team.getCaptainId(), MailScene.TEAM_ARENA_TEAM_NUM_MAX,
                    null, GameEvent.TEAM_ARENA_NUM_MAX);
            mailService.insert(mail);
        }
    }

    public ArenaTeamMember createMember(long rid, boolean hidden) {
        ArenaTeamMember member = new ArenaTeamMember();
        member.setRid(rid);
        member.setHidden(hidden);
        member.setFighting(heroLineUpService.getLineUpFighting(getLineUp(rid)));
        return member;
    }

    public void doExitTeam(long memberId, ArenaTeam team) {
        team.getMembers().removeIf(member -> member.getRid() == memberId);
        role2Team.remove(memberId);
        if (team.getMembers().size() <= 0) {
            removeTeams(Collections.singletonList(team));
        } else {
            if (team.getCaptainId() == memberId) {
                team.setCaptainId(team.getMembers().get(0).getRid());
            }
            update(team);
        }
    }

    public void removeAllTeam() {
        //通知客户端
        role2Team.clear();
        removeTeams(getAll());
        teamArenaBattleRecordService.removeAll();
    }

    public ArenaTeam doCreate(String teamName, boolean autoAgree, int minFighting, int minLv, long captainId) {
        ArenaTeam team = new ArenaTeam();
        team.setCaptainId(captainId);
        team.setTeamName(teamName);
        team.setAutoAgree(autoAgree);
        team.setMinFighting(minFighting);
        team.setMinLv(minLv);
        team.setScore(1000);
        team.setCreateTime(TimeDateUtil.getCurrentTimeInt());

        team.setCanChallengeCount(teamArenaConst.getTeamArenaInitialTimes());
        team.setLastAddTime(TimeDateUtil.getCurrentTimeInt());

        add(team);

        doJoinTeam(captainId, team);

        ArenaTeamMember member1 = team.getMembers().stream().filter(member -> member.getRid() == captainId).findFirst().orElse(null);
        member1.setHidden(true);

        return team;
    }

    public synchronized void setNewState(TeamArenaTime newTeamArenaTime) {
        TeamArenaTime teamArenaTime = loadTeamArenaTime();

        if (teamArenaTime.getRemoveTeamTime() < newTeamArenaTime.getRemoveTeamTime()) {
            removeAllTeam();
            teamArenaTime.setRemoveTeamTime(newTeamArenaTime.getRemoveTeamTime());
            updateTeamArenaTime(teamArenaTime);
        }

        if (teamArenaTime.getStateChangeTime() == newTeamArenaTime.getStateChangeTime()) {
            return;
        }

        //新状态跟旧状态之间间隔了TEAM，清除队伍和战斗记录
        if (teamArenaTime.getStateChangeTime() != newTeamArenaTime.getStateChangeTime()) {
            TeamArenaState curr = teamArenaTime.getCurrState();
            while (curr != null && curr != newTeamArenaTime.getCurrState()) {
                curr = curr.nextState();
                if (curr == TeamArenaState.TEAM) {
                    removeAllTeam();
                    teamArenaRankService.clearRank();
                } else if (curr == TeamArenaState.OVER) {
                    settle();
                } else if (curr == TeamArenaState.SETTLE) {
                    arenaTeamApplyDao.remove(arenaTeamApplyDao.listAll());
                    arenaTeamInviteDao.remove(arenaTeamInviteDao.listAll());
                    //清除战报
                    resBattleMap.clear();
                    reportMap.clear();
                }
            }
        }

        teamArenaTime.setStateChangeTime(newTeamArenaTime.getStateChangeTime());
        teamArenaTime.setCurrState(newTeamArenaTime.getCurrState());
        teamArenaTime.setNextStateTime(newTeamArenaTime.getNextStateTime());
        log.info("team_arena update state:{}", teamArenaTime.getCurrState());

        updateTeamArenaTime(teamArenaTime);

        eventBus.post(TeamArenaStateChangeEvent.of(teamArenaTime.getCurrState()));
    }

    public void checkAction(RoleAction action) {
        TeamArenaTime teamArenaTime = loadTeamArenaTime();

        Asserts.isTrue(teamArenaTime.getCurrState() != null && teamArenaTime.getCurrState().canAction(action),
                ErrorCode.TEAM_ARENA_STATE_ILLEGAL.getValue(),
                String.format("组队竞技场状态错误：{%s}，不允许该操作{%s}", teamArenaTime.getCurrState(), action));
    }

    public void settle() {
        TeamArenaTime teamArenaTime = loadTeamArenaTime();
        messageDispatcher.dispatch(TeamArenaSettleRecordReqMessage.of(teamArenaTime.getLastSettleTime(), serverConfig.getSubServerIds()), res -> {
            TeamArenaSettleRecordResMessage settleRecordRes = (TeamArenaSettleRecordResMessage) res;

            log.info("req请求领奖记录：" + settleRecordRes.getSettleTime() + "--" + (settleRecordRes.getRank() == null ? 0 : settleRecordRes.getRank().size()));
            List<TeamArenaRankData> rank = settleRecordRes.getRank();
            if (teamArenaTime.getLastSettleTime() >= settleRecordRes.getSettleTime()) {
                log.info("请求结算，时间少于当前时间");
                return;
            }
            teamArenaTime.setLastSettleTime(settleRecordRes.getSettleTime());
            updateTeamArenaTime(teamArenaTime);
            try {
                mailChallenge();
            } catch (Exception e) {
                log.error("次数奖励发送失败", e);
            }
            try {
                mailRank(rank);
            } catch (Exception e) {
                log.error("排名奖励发送异常", e);
            }

        });
    }

    /***
     * 挑战奖励
     */
    private void mailChallenge() {
        List<Mail> mails = Lists.newArrayList();
        for (ArenaTeam team : getAll()) {
            if (team.getHadChallengeCount() <= 0) {
                continue;
            }
            List<CTeamArenaChallengeReward> rewardConfigs = teamArenaChallengeRewardSysCache.getAll().stream().filter(config ->
                    config.getNeed_count() <= team.getHadChallengeCount()).collect(Collectors.toList());
            if (rewardConfigs.size() <= 0) {
                return;
            }
            for (ArenaTeamMember member : team.getMembers()) {
                try {
                    Set<Integer> rewardIds = team.getMemberReward().get(member.getRid());
                    if (rewardIds == null) {
                        rewardIds = new HashSet<>();
                        Set<Integer> old = team.getMemberReward().putIfAbsent(member.getRid(), rewardIds);
                        if (old != null) {
                            rewardIds = old;
                        }
                    }
                    Set<Integer> finalRewardIds = rewardIds;
                    List<CTeamArenaChallengeReward> notGetList = rewardConfigs.stream().filter(config ->
                            !finalRewardIds.contains(config.getIdx())).collect(Collectors.toList());
                    rewardIds.addAll(notGetList.stream().mapToInt(CTeamArenaChallengeReward::getIdx).collect(ArrayList::new, ArrayList::add, ArrayList::addAll));
                    if (notGetList.size() > 0) {
                        List<ImmutableThing> getRewards = notGetList.stream().map(CTeamArenaChallengeReward::getReward)
                                .flatMap(Collection::stream).collect(Collectors.toList());
                        getRewards = ImmutableThingUtil.mergeThing(getRewards);
                        Mail mail = mailService.newSimpleMail(member.getRid(), MailScene.TEAM_ARENA_CHALLENGE_REWARD,
                                getRewards, GameEvent.TEAM_ARENA_CHALLENGE);
                        mails.add(mail);
                        teamArenaRedService.sendRedState(member.getRid());
                        sendData(team, member.getRid());
                    }
                } catch (Exception e) {
                    log.error(String.format("结算玩家{%s}挑战奖励异常", member.getRid()), e);
                }
            }
            update(team);
        }
        if (mails.size() > 0) {
            mailService.insertMails(mails);
        }
    }

    public void sendData(ArenaTeam team, long memberId) {
        TeamArenaGMsg.GResTeamArenaData.Builder builder = TeamArenaGMsg.GResTeamArenaData.newBuilder();
        builder.setChallengeCount(team.getCanChallengeCount());
        builder.setLastAddTime(team.getLastAddTime());
        builder.setHadChallengeCount(team.getHadChallengeCount());
        Set<Integer> rewardIds = team.getMemberReward().get(memberId);
        if (rewardIds != null) {
            builder.addAllRewardIdx(rewardIds);
        }
        contextManager.write(memberId, CmdCode._66060, builder.build());
    }

    private void mailRank(List<TeamArenaRankData> rank) {
        if (rank == null) {
            return;
        }
        TeamArenaSettleEvent event = TeamArenaSettleEvent.of();
        rank.forEach(teamArenaRankData -> {
            long memberId = teamArenaRankData.getTeamData().getMembers().get(0).getRid();
            if (serverConfig.matchServerId(teamArenaRankData.getTeamData().getSimpleMap().get(memberId).getServerId())) {
                CTeamArenaRankReward config = teamArenaRankRewardSysCache.getByRank(teamArenaRankData.getRank());
                if (config == null) {
                    log.error("该排名不存在奖励{}", teamArenaRankData.getRank());
                } else {
                    List<Mail> mails = new ArrayList<>();
                    teamArenaRankData.getTeamData().getMembers().forEach(member -> {
                        Mail mail = mailService.newMailNoTitle(member.getRid(), MailScene.TEAM_ARENA_RANK,
                                MailParams.build(teamArenaRankData.getRank()), config.getReward(), GameEvent.TEAM_ARENA_RANK);
                        mails.add(mail);
                    });
                    mailService.insertMails(mails);
                }
            }
            if (teamArenaRankData.getRank() <= 5) {
                List<Long> roles = event.getRank2Roles().get(teamArenaRankData.getRank());
                if (Objects.isNull(roles)) {
                    roles = new ArrayList<>();
                    event.getRank2Roles().put(teamArenaRankData.getRank(), roles);
                }
                for (ArenaTeamMember member : teamArenaRankData.getTeamData().getMembers()) {
                    roles.add(member.getRid());
                }
            }
        });

        if (CollectionUtil.isNotEmpty(event.getRank2Roles())) {
            eventBus.post(event);
        }
    }


    public TeamArenaRankData builderTeamRankData(ArenaTeam team, int rank) {
        TeamArenaRankData teamArenaRankData = new TeamArenaRankData();
        ArenaTeamData data = new ArenaTeamData();
        data.setTeamId(team.getTeamId());
        data.setTeamName(team.getTeamName());
        data.setCaptainId(team.getCaptainId());
        List<ArenaTeamMember> members = new ArrayList<>();
        Map<Long, RoleSimpleMessage> simpleMap = new HashMap<>();
        team.getMembers().forEach(memberTemp -> {
            ArenaTeamMember member = new ArenaTeamMember();
            member.setFighting(memberTemp.getFighting());
            member.setHidden(memberTemp.isHidden());
            member.setRid(memberTemp.getRid());
            members.add(member);

            Role role = roleService.getOrThrow(memberTemp.getRid());
            RoleSimpleMessage simpleMessage = new RoleSimpleMessage();
            simpleMessage.setLevel(role.getLevel());
            simpleMessage.setHeadId(role.getHeadId());
            simpleMessage.setBorderId(role.getBorderId());
            simpleMessage.setImage(role.getImageId());
            simpleMessage.setRoleName(role.getNick());
            simpleMessage.setServerId(role.getServerId());
            simpleMessage.setClanName("");
            simpleMessage.setFighting(role.getFighting());
            simpleMessage.setRid(role.getId());
            simpleMap.put(memberTemp.getRid(), simpleMessage);

            data.setServerId(role.getServerId());
        });
        data.setMembers(members);
        data.setSimpleMap(simpleMap);

        teamArenaRankData.setScore(team.getScore());
        teamArenaRankData.setTeamData(data);
        teamArenaRankData.setRank(rank);
        return teamArenaRankData;
    }

    public List<byte[]> builderTeamVos(ArenaTeam team) {
        List<byte[]> vos = new ArrayList<>();
        team.getMembers().forEach(member -> {
            BattlerDo battlerDo = battleHelper.queryPlayerBattler(getLineUpType(member.getRid()), member.getRid(), Faction.ATTACKER);
            Role memberRole = roleService.getOrThrow(member.getRid());
            battlerDo.setRoleInfo(memberRole.getServerId(), memberRole.getHeadId(), memberRole.getBorderId(), memberRole.getLevel(), memberRole.getFighting());
            vos.add(ProtostuffUtil.serialize(battlerDo.toBattlerVo()));
        });
        return vos;
    }

    public List<Integer> builderFightingList(ArenaTeam team) {
        List<Integer> res = new ArrayList<>();
        team.getMembers().forEach(member -> {
            res.add(member.getFighting());
        });
        return res;
    }

    public void sendSelfRank(long rid) {
        TeamArenaGMsg.GResTeamArenaRank.Builder builder = TeamArenaGMsg.GResTeamArenaRank.newBuilder();
        ArenaTeam team = getTeamByRid(rid);
        builder.setSelf(teamArenaRankService.selfRank(team == null ? 0 : team.getTeamId()));
        if (team != null) {
            builder.setHadSign(team == null ? false : team.isHadSign());
        }
        contextManager.write(rid, CmdCode._66050, builder.build());
    }

    public void broadcastTeam(ArenaTeam team) {
        if (team == null || team.getMembers().size() <= 0) {
            return;
        }
        TeamArenaGMsg.GResTeamArenaRank.Builder builder = TeamArenaGMsg.GResTeamArenaRank.newBuilder();
        builder.setSelf(teamArenaRankService.selfRank(team.getTeamId()));

        builder.setHadSign(team == null ? false : team.isHadSign());

        team.getMembers().forEach(member -> {
            contextManager.write(member.getRid(), CmdCode._66050, builder.build());
            TeamArenaGMsg.GResTeam.Builder teamPB = TeamArenaGMsg.GResTeam.newBuilder();
            teamPB.setTeam(builderTeamPB(team));
            contextManager.write(member.getRid(), CmdCode._66001, teamPB.build());
            sendSelfRank(member.getRid());
        });

    }

    public void updateToCross(List<ArenaTeam> teams) {
        if (CollectionUtil.isNotEmpty(teams)) {
            List<ArenaTeamData> list = new ArrayList<>();
            teams.forEach(team -> {
                if (team.isHadSign()) {
                    ArenaTeamData teamData = new ArenaTeamData();
                    teamData.setTeamId(team.getTeamId());
                    teamData.setCaptainId(team.getCaptainId());
                    teamData.setMembers(ImmutableList.copyOf(team.getMembers()));
                    teamData.setTeamName(team.getTeamName());
                    teamData.setCreateTime(team.getCreateTime());
                    list.add(teamData);
                }
            });

            messageDispatcher.dispatch(TeamArenaUpdateTeamReqMessage.createOf(list));
        }
    }
}
