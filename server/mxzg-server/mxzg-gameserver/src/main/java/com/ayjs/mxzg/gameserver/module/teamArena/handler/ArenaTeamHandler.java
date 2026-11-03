package com.ayjs.mxzg.gameserver.module.teamArena.handler;

import cn.hutool.core.collection.CollectionUtil;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.InternerPool;
import com.ayjs.mxzg.common.util.StringUtil;
import com.ayjs.mxzg.config.excel.cache.OpenConditionSysCache;
import com.ayjs.mxzg.config.excel.cache.SystemSysCache;
import com.ayjs.mxzg.config.excel.entity.COpenCondition;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.mail.constant.MailScene;
import com.ayjs.mxzg.gameserver.module.mail.domain.Mail;
import com.ayjs.mxzg.gameserver.module.mail.service.MailService;
import com.ayjs.mxzg.gameserver.module.mail.struct.MailParams;
import com.ayjs.mxzg.gameserver.module.role.constant.EntryType;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.sensitive.service.SensitiveWordService;
import com.ayjs.mxzg.gameserver.module.teamArena.domain.ArenaTeam;
import com.ayjs.mxzg.gameserver.module.teamArena.domain.ArenaTeamApply;
import com.ayjs.mxzg.gameserver.module.teamArena.domain.ArenaTeamInvite;
import com.ayjs.mxzg.gameserver.module.teamArena.service.TeamArenaRedService;
import com.ayjs.mxzg.gameserver.module.teamArena.service.TeamArenaService;
import com.ayjs.mxzg.message.module.teamArena.domain.ArenaTeamMember;
import com.ayjs.mxzg.message.module.teamArena.domain.RoleAction;
import com.ayjs.mxzg.protocol.TeamArenaGMsg;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.ayjs.mxzg.template.constant.GameConstant;
import com.google.common.collect.ImmutableList;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Objects;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.stream.Collectors;

/**
 * 组队竞技场队伍
 *
 * @Author: CWJ
 * @Date: 2020/4/16
 **/
@Component
public class ArenaTeamHandler extends ProtocolHandler {

    @Autowired
    private TeamArenaService teamArenaService;
    @Autowired
    private SensitiveWordService sensitiveWordService;
    @Autowired
    private MailService mailService;
    @Autowired
    private RoleService roleService;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private OpenConditionSysCache openConditionSysCache;
    @Autowired
    private TeamArenaRedService teamArenaRedService;
    @Autowired
    private SystemSysCache systemSysCache;

    @CMD(id = CmdCode._66001)
    public void getTeam(PlayerContext playerContext, TeamArenaGMsg.GReqTeam req) {
        ArenaTeam team = teamArenaService.getTeamByRid(playerContext.getId());
        if (Objects.isNull(team)) {
            playerContext.write(CmdCode._66001, TeamArenaGMsg.GResTeam.getDefaultInstance());
            return;
        }
        TeamArenaGMsg.GResTeam.Builder builder = TeamArenaGMsg.GResTeam.newBuilder();
        builder.setTeam(teamArenaService.builderTeamPB(team));
        playerContext.write(CmdCode._66001, builder.build());

    }

    @CMD(id = CmdCode._66002)
    public void search(PlayerContext playerContext, TeamArenaGMsg.GReqTeamSearch req) {
        List<ArenaTeam> teams = teamArenaService.getAll();
        teams = teams.stream().filter(team -> team.getTeamName().indexOf(req.getTeamName()) >= 0).collect(Collectors.toList());
        TeamArenaGMsg.GResTeamSearch.Builder builder = TeamArenaGMsg.GResTeamSearch.newBuilder();
        List<ArenaTeamApply> appliesByRid = teamArenaService.getAppliesByRid(playerContext.getId());
        teams.forEach(temp -> {
            TeamArenaGMsg.PBSimpleTeam.Builder simpleTeam = teamArenaService.builderSimpleTeamPb(temp);
            simpleTeam.setIsRequest(appliesByRid.stream().anyMatch(apply -> apply.getTeamId() == temp.getTeamId()));
            builder.addTeam(teamArenaService.builderSimpleTeamPb(temp));
        });
        builder.setIsJoin(teamArenaService.getTeamIdByRid(playerContext.getId()) != null);
        playerContext.write(CmdCode._66002, builder.build());
    }

    @CMD(id = CmdCode._66003)
    public void create(PlayerContext playerContext, TeamArenaGMsg.GReqTeamCreate req) {

        teamArenaService.checkAction(RoleAction.MEMBER_CHANGE_TEAM);

        ArenaTeam team = null;
        long captainId = playerContext.getId();
        //长度
        checkTeamName(req.getTeamName(), roleService.getOrThrow(captainId));

        synchronized (InternerPool.intern(TeamArenaService.TEAM_ARENA_ROLE, captainId)) {
            Asserts.isNull(teamArenaService.getTeamIdByRid(captainId), ErrorCode.TEAM_ARENA_HAD_TEAM.getValue(),
                    String.format("玩家已经加入队伍{%s}", captainId));

            Asserts.isTrue(!teamArenaService.getAll().stream().anyMatch(teamTemp -> teamTemp.getTeamName().equals(req.getTeamName()))
                    , ErrorCode.TEAM_ARENA_NAME_HAD_EXIST.getValue(), String.format("名字已存在{%s}", req.getTeamName()));

            team = teamArenaService.doCreate(req.getTeamName(), req.getAutoAgree(), req.getMinFighting(), req.getMinLv(), captainId);

        }
        TeamArenaGMsg.GResTeamCreate.Builder builder = TeamArenaGMsg.GResTeamCreate.newBuilder();
        builder.setTeam(teamArenaService.builderTeamPB(team));
        playerContext.write(CmdCode._66003, builder.build());

        teamArenaService.broadcastTeam(team);
    }


    private void checkTeamName(String teamName, Role role) {
        int size = StringUtil.getShowLength(teamName);
        Asserts.isTrue(size >= 1 && size <= systemSysCache.getClanNameLength(),
                ErrorCode.CLAN_NAME_TOO_LONG.getValue(), String.format("team name:%s", teamName));

        Asserts.isTrue(GameConstant.NAME_PATTERN.matcher(teamName).matches(), ErrorCode.TEAM_ARENA_NAME_ILLEGAL.getValue(),
                String.format("队伍名格式不对!name:%s", teamName));

        // 敏感字符验证
        Asserts.isTrue(sensitiveWordService.wordCanUse(teamName, role), ErrorCode.TEAM_ARENA_NAME_ILLEGAL.getValue(),
                () -> String.format("team name:%s contains sensitive word :%s", teamName,
                        sensitiveWordService.findConfigSensitiveWord(teamName, role)));
    }

    @CMD(id = CmdCode._66004)
    public void inviteList(PlayerContext playerContext, TeamArenaGMsg.GReqTeamInviteList req) {

        List<ArenaTeamInvite> invites = teamArenaService.getInvitesByRid(playerContext.getId());
        invites.sort(new Comparator<ArenaTeamInvite>() {
            @Override
            public int compare(ArenaTeamInvite o1, ArenaTeamInvite o2) {
                return o1.getInviteTime() - o2.getInviteTime();
            }
        });
        TeamArenaGMsg.GResTeamInviteList.Builder builder = TeamArenaGMsg.GResTeamInviteList.newBuilder();
        List<ArenaTeamInvite> remove = new ArrayList<>();
        invites.forEach(temp -> {
            ArenaTeam teamTemp = teamArenaService.get(temp.getTeamId());
            if (teamTemp == null) {
                remove.add(temp);
            } else {
                builder.addTeam(teamArenaService.builderTeamPB(teamTemp));
            }
        });
        if (CollectionUtil.isNotEmpty(remove)) {
            teamArenaService.remove(remove);
        }
        playerContext.write(CmdCode._66004, builder.build());

    }

    @CMD(id = CmdCode._66005)
    public void applyList(PlayerContext playerContext, TeamArenaGMsg.GReqTeamApplyList req) {
        ArenaTeam team = teamArenaService.getTeamByRid(playerContext.getId());
        Asserts.notNull(team, ErrorCode.TEAM_ARENA_NOT_HAD_TEAM.getValue(), String.format("玩家未加入队伍{%s}", playerContext.getId()));
        Asserts.isTrue(playerContext.getId() == team.getCaptainId(), ErrorCode.TEAM_ARENA_NOT_CAPTAIN.getValue(),
                String.format("玩家{%s}不是队长{%s}", playerContext.getId(), team.getCaptainId()));

        List<ArenaTeamApply> applies = teamArenaService.getAppliesByTeamId(team.getTeamId());

        applies.sort(new Comparator<ArenaTeamApply>() {
            @Override
            public int compare(ArenaTeamApply o1, ArenaTeamApply o2) {
                return o1.getApplyTime() - o2.getApplyTime();
            }
        });

        TeamArenaGMsg.GResTeamApplyList.Builder builder = TeamArenaGMsg.GResTeamApplyList.newBuilder();
        List<ArenaTeamApply> remove = new ArrayList<>();
        applies.forEach(apply -> {
            Long teamId = teamArenaService.getTeamIdByRid(apply.getApplyId());
            if (teamId != null) {
                remove.add(apply);
            } else {
                builder.addApplyInfo(teamArenaService.builderMember(apply.getApplyId()));
            }
        });
        if (CollectionUtil.isNotEmpty(remove)) {
            teamArenaService.removeApplies(remove);
        }
        playerContext.write(CmdCode._66005, builder.build());

    }

    @CMD(id = CmdCode._66006)
    public void handleInvite(PlayerContext playerContext, TeamArenaGMsg.GReqTeamHandleInvite req) {

        teamArenaService.checkAction(RoleAction.MEMBER_CHANGE_TEAM);

        ArenaTeam team = null;
        synchronized (InternerPool.intern(TeamArenaService.TEAM_ARENA_TEAM, req.getTeamId())) {
            synchronized (InternerPool.intern(TeamArenaService.TEAM_ARENA_ROLE, playerContext.getId())) {
                team = teamArenaService.get(req.getTeamId());
                Asserts.notNull(team, ErrorCode.TEAM_ARENA_NOT_EXIST.getValue(), String.format("队伍不存在{%s}", req.getTeamId()));

                Asserts.isNull(teamArenaService.getTeamIdByRid(playerContext.getId()), ErrorCode.TEAM_ARENA_NOT_HAD_TEAM.getValue(),
                        String.format("玩家{%s}已经加入队伍{%s}", playerContext.getId(), req.getTeamId()));

                Asserts.isTrue(teamArenaService.getMemberMaxNum() >= team.getMembers().size(), ErrorCode.TEAM_ARENA_TEAM_MEMBER_MAX.getValue(),
                        String.format("成员已满，最大数量{%s}-{%s}", teamArenaService.getMemberMaxNum(), team.getMembers().size()));

                ArenaTeamInvite invite = teamArenaService.getInvitesByRid(playerContext.getId()).stream().
                        filter(inviteTemp -> inviteTemp.getTeamId() == req.getTeamId()).findFirst().orElse(null);
                Asserts.notNull(invite,
                        ErrorCode.TEAM_ARENA_NOT_APPLY.getValue(), String.format("玩家{%s}未收到队伍{%s}的邀请", playerContext.getId(), team.getTeamId()));

                ArenaTeamApply apply = teamArenaService.getAppliesByTeamId(team.getTeamId()).stream().
                        filter(applyTemp -> applyTemp.getApplyId() == playerContext.getId()).findFirst().orElse(null);

                teamArenaService.doJoinTeam(playerContext.getId(), team);
                teamArenaService.remove(Arrays.asList(invite));
                if (apply != null)
                    teamArenaService.removeApplies(Arrays.asList(apply));

            }
        }
        TeamArenaGMsg.GResTeamHandleInvite.Builder builder = TeamArenaGMsg.GResTeamHandleInvite.newBuilder();
        builder.setTeam(teamArenaService.builderTeamPB(team));
        playerContext.write(CmdCode._66006, builder.build());

        teamArenaService.broadcastTeam(team);

        teamArenaRedService.sendRedState(playerContext.getId());
        teamArenaRedService.sendRedState(team.getCaptainId());

    }


    @CMD(id = CmdCode._66007)
    public void apply(PlayerContext playerContext, TeamArenaGMsg.GReqTeamApply req) {
        ArenaTeam team = teamArenaService.get(req.getTeamId());
        Asserts.isTrue(!teamArenaService.getAppliesByRid(playerContext.getId()).stream().anyMatch(apply -> apply.getTeamId() == team.getTeamId()),
                ErrorCode.TEAM_ARENA_NOT_HAD_TEAM.getValue(), String.format("玩家{%s}已经申请了该队伍{%s}", playerContext.getId(), req.getTeamId()));
        Asserts.notNull(team, ErrorCode.TEAM_ARENA_NOT_HAD_TEAM.getValue(), String.format("队伍{%s}不存在", req.getTeamId()));

        ApplyResult result = null;

        TeamArenaGMsg.GResTeamApply.Builder builder = TeamArenaGMsg.GResTeamApply.newBuilder();
        if (teamArenaService.getTeamIdByRid(playerContext.getId()) != null) {
            result = ApplyResult.HAD_JOIN;
            builder.setCode(result.code);
            builder.setTeamId(req.getTeamId());
            playerContext.write(CmdCode._66007, builder.build());
            return;
        }

        if (team.getMembers().size() >= teamArenaService.getMemberMaxNum()) {
            result = ApplyResult.TEAM_MAX;
            builder.setCode(result.code);
            builder.setTeamId(req.getTeamId());
            playerContext.write(CmdCode._66007, builder.build());
            return;
        }
        Role role = roleService.getOrThrow(playerContext.getId());
        COpenCondition openCondition = openConditionSysCache.getCondition(EntryType.MAIN_LADDER_WAR);
        if (team.getMinFighting() > role.getFighting() || team.getMinLv() > role.getLevel() || role.getLevel() < openCondition.getCondition_value()) {
            result = ApplyResult.TEAM_CONDITION;
            builder.setCode(result.code);
            builder.setTeamId(req.getTeamId());
            playerContext.write(CmdCode._66007, builder.build());
            Asserts.notNull(team, ErrorCode.TEAM_ARENA_NOT_HAD_TEAM.getValue(), String.format("队伍{%s}不存在", req.getTeamId()));
            return;
        }

        if (team.isAutoAgree()) {
            teamArenaService.doJoinTeam(playerContext.getId(), team);
            result = ApplyResult.JOIN;
            builder.setCode(result.code);
            builder.setTeamId(req.getTeamId());
            playerContext.write(CmdCode._66007, builder.build());
            teamArenaService.broadcastTeam(team);
            //清除邀请
            ArenaTeamInvite invite = teamArenaService.getInvitesByRid(playerContext.getId()).stream().filter(inviteTemp ->
                    inviteTemp.getTeamId() == team.getTeamId()
            ).findFirst().orElse(null);
            if (invite != null) {
                teamArenaService.remove(Arrays.asList(invite));
                teamArenaRedService.sendRedState(playerContext.getId());
            }
        } else {
            ArenaTeamApply apply = new ArenaTeamApply();
            apply.setApplyId(playerContext.getId());
            apply.setTeamId(req.getTeamId());
            teamArenaService.add(apply);
            result = ApplyResult.APPLY_SUCCESS;
            builder.setCode(result.code);
            builder.setTeamId(req.getTeamId());
            playerContext.write(CmdCode._66007, builder.build());

            teamArenaRedService.sendRedState(team.getCaptainId());
        }

    }

    @CMD(id = CmdCode._66008)
    public void exit(PlayerContext playerContext, TeamArenaGMsg.GReqTeamExit req) {

        teamArenaService.checkAction(RoleAction.MEMBER_CHANGE_TEAM);

        Long teamId = teamArenaService.getTeamIdByRid(playerContext.getId());
        ArenaTeam team = null;
        Asserts.notNull(teamId, ErrorCode.TEAM_ARENA_NOT_HAD_TEAM.getValue(), String.format("玩家未加入队伍{%s}", playerContext.getId()));

        synchronized (InternerPool.intern(TeamArenaService.TEAM_ARENA_TEAM, teamId)) {
            synchronized (InternerPool.intern(TeamArenaService.TEAM_ARENA_ROLE, playerContext.getId())) {
                team = teamArenaService.get(teamId);
                Asserts.notNull(team, ErrorCode.TEAM_ARENA_NOT_HAD_TEAM.getValue(), String.format("玩家未加入队伍{%s}", playerContext.getId()));
                Asserts.isTrue(!team.isHadSign(), ErrorCode.TEAM_ARENA_HAD_SIGN.getValue(), String.format("队伍已经报名{%s}", playerContext.getId()));

                teamArenaService.doExitTeam(playerContext.getId(), team);
            }
        }
        playerContext.write(CmdCode._66008, TeamArenaGMsg.GResTeamExit.getDefaultInstance());

        teamArenaService.sendSelfRank(playerContext.getId());
        teamArenaService.broadcastTeam(team);
    }


    @CMD(id = CmdCode._66009)
    public void kickOut(PlayerContext playerContext, TeamArenaGMsg.GReqTeamKickOut req) {

        teamArenaService.checkAction(RoleAction.MEMBER_CHANGE_TEAM);

        ArenaTeam team = teamArenaService.getTeamByRid(playerContext.getId());
        Asserts.notNull(team, ErrorCode.TEAM_ARENA_NOT_HAD_TEAM.getValue(), String.format("玩家未加入队伍{%s}", playerContext.getId()));

        Asserts.isTrue(playerContext.getId() == team.getCaptainId(), ErrorCode.TEAM_ARENA_NOT_CAPTAIN.getValue(),
                String.format("玩家{%s}不是队长{%s}", playerContext.getId(), team.getCaptainId()));
        synchronized (InternerPool.intern(TeamArenaService.TEAM_ARENA_TEAM, team.getTeamId())) {
            synchronized (InternerPool.intern(TeamArenaService.TEAM_ARENA_ROLE, req.getMemberId())) {
                Asserts.isTrue(team.getMembers().stream().filter(member -> member.getRid() == playerContext.getId()).findAny().isPresent(),
                        ErrorCode.TEAM_ARENA_NOT_HAD_TEAM.getValue(), String.format("玩家未加入队伍{%s}", playerContext.getId()));
                Asserts.isTrue(!team.isHadSign(), ErrorCode.TEAM_ARENA_HAD_SIGN.getValue(), String.format("队伍已经报名{%s}", playerContext.getId()));

                teamArenaService.doExitTeam(req.getMemberId(), team);
            }
        }
        TeamArenaGMsg.GResTeamKickOut.Builder builder = TeamArenaGMsg.GResTeamKickOut.newBuilder();
        builder.setTeam(teamArenaService.builderTeamPB(team));
        playerContext.write(CmdCode._66009, TeamArenaGMsg.GResTeamExit.getDefaultInstance());

        teamArenaService.broadcastTeam(team);

        PlayerContext memberContext = contextManager.getOnline(req.getMemberId());
        if (memberContext != null) {
            memberContext.write(CmdCode._66019, TeamArenaGMsg.GResTeamArenaBeKickOut.getDefaultInstance());
            getTeam(memberContext, TeamArenaGMsg.GReqTeam.getDefaultInstance());
        }

//        teamArenaService.sendSelfRank(req.getMemberId());
    }

    @CMD(id = CmdCode._66010)
    public void handleApply(PlayerContext playerContext, TeamArenaGMsg.GReqTeamHandleApply req) {

        ArenaTeam team = teamArenaService.getTeamByRid(playerContext.getId());
        Asserts.notNull(team, ErrorCode.TEAM_ARENA_NOT_HAD_TEAM.getValue(), String.format("玩家未加入队伍{%s}", playerContext.getId()));
        Asserts.isTrue(playerContext.getId() == team.getCaptainId(), ErrorCode.TEAM_ARENA_NOT_CAPTAIN.getValue(),
                String.format("玩家{%s}不是队长{%s}", playerContext.getId(), team.getCaptainId()));

        Asserts.isTrue(!team.isHadSign(), ErrorCode.TEAM_ARENA_HAD_SIGN.getValue(), String.format("队伍已经报名{%s}", team.isHadSign()));

        if (req.getOp() == 2) {
            ArenaTeamApply apply = teamArenaService.getAppliesByTeamId(team.getTeamId()).stream().
                    filter(applyTemp -> applyTemp.getApplyId() == req.getMemberId()).findFirst().orElse(null);
            Asserts.notNull(apply,
                    ErrorCode.TEAM_ARENA_NOT_APPLY.getValue(), String.format("玩家{%s}未申请该队伍{%s}", req.getMemberId(), team.getTeamId()));
            teamArenaService.removeApplies(Arrays.asList(apply));
        } else {
            synchronized (InternerPool.intern(TeamArenaService.TEAM_ARENA_TEAM, team.getTeamId())) {
                synchronized (InternerPool.intern(TeamArenaService.TEAM_ARENA_ROLE, req.getMemberId())) {

                    Asserts.isNull(teamArenaService.getTeamIdByRid(req.getMemberId()), ErrorCode.TEAM_ARENA_NOT_HAD_TEAM.getValue(),
                            String.format("玩家{%s}已经加入队伍{%s}", req.getMemberId(), teamArenaService.getTeamIdByRid(playerContext.getId())));

                    Asserts.isTrue(teamArenaService.getMemberMaxNum() >= team.getMembers().size(), ErrorCode.TEAM_ARENA_TEAM_MEMBER_MAX.getValue(),
                            String.format("成员已满，最大数量{%s}-{%s}", teamArenaService.getMemberMaxNum(), team.getMembers().size()));

                    ArenaTeamApply apply = teamArenaService.getAppliesByTeamId(team.getTeamId()).stream().
                            filter(applyTemp -> applyTemp.getApplyId() == req.getMemberId()).findFirst().orElse(null);
                    Asserts.notNull(apply,
                            ErrorCode.TEAM_ARENA_NOT_APPLY.getValue(), String.format("玩家{%s}未申请该队伍{%s}", req.getMemberId(), team.getTeamId()));

                    teamArenaService.doJoinTeam(apply.getApplyId(), team);
                    teamArenaService.removeApplies(Arrays.asList(apply));

                    ArenaTeamInvite invite = teamArenaService.getInvitesByTeamId(team.getTeamId()).stream().
                            filter(inviteTemp -> inviteTemp.getInviteId() == apply.getApplyId()).findFirst().orElse(null);
                    if (invite != null) {
                        teamArenaService.remove(Arrays.asList(invite));
                    }

                    TeamArenaGMsg.GReqTeamHandleApply.Builder builder = TeamArenaGMsg.GReqTeamHandleApply.newBuilder();
                    playerContext.write(CmdCode._66010, builder.build());

                    Mail mail = mailService.newMailNoTitle(apply.getApplyId(), MailScene.TEAM_ARENA_APPLY_PASS, MailParams.build(team.getTeamName()),
                            null, GameEvent.TEAM_ARENA_APPLY_PASS);
                    mailService.insert(mail);
                }
            }
        }

        TeamArenaGMsg.GResTeamHandleApply.Builder builder = TeamArenaGMsg.GResTeamHandleApply.newBuilder();
        builder.setMemberId(req.getMemberId());
        builder.setOp(req.getOp());
        builder.setTeam(teamArenaService.builderTeamPB(team));
        playerContext.write(CmdCode._66010, builder.build());

        teamArenaService.broadcastTeam(team);
        teamArenaRedService.sendRedState(team.getCaptainId());
        teamArenaRedService.sendRedState(req.getMemberId());
    }

    @CMD(id = CmdCode._66011)
    public void invite(PlayerContext playerContext, TeamArenaGMsg.GReqTeamInvite req) {

        ArenaTeam team = teamArenaService.getTeamByRid(playerContext.getId());

        Asserts.notNull(team, ErrorCode.TEAM_ARENA_NOT_HAD_TEAM.getValue(), String.format("玩家未加入队伍{%s}", playerContext.getId()));
        Asserts.isTrue(playerContext.getId() == team.getCaptainId(), ErrorCode.TEAM_ARENA_NOT_CAPTAIN.getValue(),
                String.format("玩家{%s}不是队长{%s}", playerContext.getId(), team.getCaptainId()));

        Long teamIdByRid = teamArenaService.getTeamIdByRid(req.getRid());
        Asserts.isNull(teamIdByRid, ErrorCode.TEAM_ARENA_NOT_HAD_TEAM.getValue(),
                String.format("玩家{%s}已经加入队伍{%s}", req.getRid(), teamIdByRid));

        Role invitedRole = roleService.getOrThrow(req.getRid());
        COpenCondition openCondition = openConditionSysCache.getCondition(EntryType.MAIN_LADDER_WAR);
        Asserts.isTrue(invitedRole.getLevel() >= openCondition.getCondition_value(), ErrorCode.ROLE_LEVEL_LOW.getValue(),
                String.format("玩家{%s}等级不足{%s}", req.getRid(), openCondition.getCondition_value()));

        List<ArenaTeamInvite> invites = teamArenaService.getInvitesByTeamId(team.getTeamId());
        ArenaTeamInvite invite = invites.stream().
                filter(inviteTemp -> inviteTemp.getInviteId() == req.getRid()).findFirst().orElse(null);
        Asserts.isNull(invite, ErrorCode.TEAM_ARENA_HAD_INVITE.getValue(), String.format("玩家{%s}已经被邀请{%s}",
                req.getRid(), team.getTeamId()));

        invite = new ArenaTeamInvite();
        invite.setInviteId(req.getRid());
        invite.setTeamId(team.getTeamId());
        teamArenaService.add(invite);

        TeamArenaGMsg.GResTeamInvite.Builder builder = TeamArenaGMsg.GResTeamInvite.newBuilder();
        builder.setRid(req.getRid());
        playerContext.write(CmdCode._66011, builder.build());

        teamArenaRedService.sendRedState(req.getRid());
    }


    @CMD(id = CmdCode._66012)
    public void reset(PlayerContext playerContext, TeamArenaGMsg.GReqTeamReset req) {
        ArenaTeam team = teamArenaService.getTeamByRid(playerContext.getId());
        long captainId = playerContext.getId();

        Asserts.notNull(team, ErrorCode.TEAM_ARENA_HAD_TEAM.getValue(), String.format("玩家未已经加入队伍{%s}", captainId));
        Asserts.isTrue(playerContext.getId() == team.getCaptainId(), ErrorCode.TEAM_ARENA_NOT_CAPTAIN.getValue(),
                String.format("玩家{%s}不是队长{%s}", playerContext.getId(), team.getCaptainId()));

        if (!team.getTeamName().equals(req.getTeamName())) {
            checkTeamName(req.getTeamName(), roleService.getOrThrow(playerContext.getId()));
            Asserts.isTrue(!teamArenaService.getAll().stream().anyMatch(teamTemp -> teamTemp.getTeamName().equals(req.getTeamName()))
                    , ErrorCode.TEAM_ARENA_HAD_TEAM.getValue(), String.format("名字已存在{%s}", req.getTeamName()));
        }

        team.setCaptainId(captainId);
        team.setTeamName(req.getTeamName());
        team.setAutoAgree(req.getAutoAgree());
        team.setMinFighting(req.getMinFighting());
        team.setMinLv(req.getMinLv());
        teamArenaService.update(team);

        TeamArenaGMsg.GResTeamReset.Builder builder = TeamArenaGMsg.GResTeamReset.newBuilder();
        builder.setTeam(teamArenaService.builderTeamPB(team));
        playerContext.write(CmdCode._66012, builder.build());

        teamArenaService.updateToCross(Arrays.asList(team));

        teamArenaService.broadcastTeam(team);

    }

    @CMD(id = CmdCode._66013)
    public void recommend(PlayerContext playerContext, TeamArenaGMsg.GReqTeamRecommend req) {
        List<ArenaTeam> teams = teamArenaService.getAll();
        teams = teams.stream().filter(teamTemp -> teamTemp.getMembers().size() < teamArenaService.getMemberMaxNum()).collect(Collectors.toList());
        Long teamId = teamArenaService.getTeamIdByRid(playerContext.getId());
        if (teamId != null) {
            teams = teams.stream().filter(teamTemp -> teamTemp.getTeamId() != teamId.longValue()).collect(Collectors.toList());
        }
        teams.sort(new Comparator<ArenaTeam>() {
            @Override
            public int compare(ArenaTeam o1, ArenaTeam o2) {
                return o1.getMembers().stream().mapToInt(ArenaTeamMember::getFighting).sum() -
                        o2.getMembers().stream().mapToInt(ArenaTeamMember::getFighting).sum();
            }
        });

        TeamArenaGMsg.GResTeamRecommend.Builder builder = TeamArenaGMsg.GResTeamRecommend.newBuilder();
        List<ArenaTeamApply> appliesByRid = teamArenaService.getAppliesByRid(playerContext.getId());
        if (teams.size() > 0)
            teams.subList(0, Math.min(teams.size(), 5)).forEach(temp -> {
                TeamArenaGMsg.PBSimpleTeam.Builder simpleTeam = teamArenaService.builderSimpleTeamPb(temp);
                simpleTeam.setIsRequest(appliesByRid.stream().anyMatch(apply -> apply.getTeamId() == temp.getTeamId()));
                builder.addTeam(simpleTeam);
            });
        builder.setIsJoin(teamArenaService.getTeamIdByRid(playerContext.getId()) != null);
        playerContext.write(CmdCode._66013, builder.build());
    }

    @CMD(id = CmdCode._66014)
    public void saveLineUp(PlayerContext playerContext, TeamArenaGMsg.GReqTeamArenaLineUp req) {

        ArenaTeam team = teamArenaService.getTeamByRid(playerContext.getId());

        Asserts.notNull(team, ErrorCode.TEAM_ARENA_NOT_HAD_TEAM.getValue(), String.format("玩家未加入队伍{%s}", playerContext.getId()));
        Asserts.isTrue(playerContext.getId() == team.getCaptainId(), ErrorCode.TEAM_ARENA_NOT_CAPTAIN.getValue(),
                String.format("玩家{%s}不是队长{%s}", playerContext.getId(), team.getCaptainId()));

        Asserts.isTrue(req.getLineUpList().stream().distinct().count() == req.getLineUpCount()
                , ErrorCode.TEAM_ARENA_MEMBER_ILLEGAL.getValue(),
                String.format("成员错误，成员重复{%s}", req.getLineUpList()));

        Asserts.isTrue(req.getHiddenMemberList().stream().distinct().count() == req.getHiddenMemberCount()
                , ErrorCode.TEAM_ARENA_MEMBER_ILLEGAL.getValue(),
                String.format("成员错误，成员重复{%s}", req.getLineUpList()));

        List<Long> memberList = new ArrayList<>();
        team.getMembers().stream().mapToLong(ArenaTeamMember::getRid).forEach(rid -> {
            memberList.add(rid);
        });
        Asserts.isTrue(memberList.containsAll(req.getLineUpList()) && team.getMembers().size() == req.getLineUpCount()
                , ErrorCode.TEAM_ARENA_MEMBER_ILLEGAL.getValue(),
                String.format("成员错误，当前成员：{%s}，请求{%s}", team.getMembers(), req.getLineUpList()));

        Asserts.isTrue(memberList.containsAll(req.getHiddenMemberList()), ErrorCode.TEAM_ARENA_MEMBER_ILLEGAL.getValue(),
                String.format("隐藏成员错误，当前成员：{%s}，请求{%s}", team.getMembers(), req.getHiddenMemberList()));

        CopyOnWriteArrayList<ArenaTeamMember> members = new CopyOnWriteArrayList<>();
        req.getLineUpList().forEach(memberId -> {
            members.add(teamArenaService.createMember(memberId, req.getHiddenMemberList().contains(memberId)));
        });

        team.setMembers(members);
        teamArenaService.update(team);

        TeamArenaGMsg.GResTeamArenaLineUp.Builder builder = TeamArenaGMsg.GResTeamArenaLineUp.newBuilder();
        builder.setTeam(teamArenaService.builderTeamPB(team));
        playerContext.write(CmdCode._66014, builder.build());

        teamArenaService.broadcastTeam(team);

        teamArenaService.updateToCross(Arrays.asList(team));
    }

    @CMD(id = CmdCode._66015)
    public void changeCaptain(PlayerContext playerContext, TeamArenaGMsg.GReqTeamArenaChangeCaptain req) {

        ArenaTeam team = teamArenaService.getTeamByRid(playerContext.getId());

        Asserts.notNull(team, ErrorCode.TEAM_ARENA_NOT_HAD_TEAM.getValue(), String.format("玩家未加入队伍{%s}", playerContext.getId()));
        Asserts.isTrue(playerContext.getId() == team.getCaptainId(), ErrorCode.TEAM_ARENA_NOT_CAPTAIN.getValue(),
                String.format("玩家{%s}不是队长{%s}", playerContext.getId(), team.getCaptainId()));

        synchronized (InternerPool.intern(TeamArenaService.TEAM_ARENA_TEAM, team.getTeamId())) {
            synchronized (InternerPool.intern(TeamArenaService.TEAM_ARENA_ROLE, req.getCaptainId())) {
                Long teamId = teamArenaService.getTeamIdByRid(req.getCaptainId());
                Asserts.isTrue(teamId != null && teamId.longValue() == team.getTeamId(), ErrorCode.TEAM_ARENA_MEMBER_ILLEGAL.getValue(),
                        String.format("玩家{%s}不在队伍{%s}", playerContext.getId(), team.getCaptainId()));
                team.setCaptainId(req.getCaptainId());
                teamArenaService.update(team);
            }
        }
        TeamArenaGMsg.GResTeamArenaChangeCaptain.Builder builder = TeamArenaGMsg.GResTeamArenaChangeCaptain.newBuilder();
        builder.setTeam(teamArenaService.builderTeamPB(team));
        playerContext.write(CmdCode._66015, builder.build());

        teamArenaService.broadcastTeam(team);

        teamArenaRedService.sendRedState(playerContext.getId());
        teamArenaRedService.sendRedState(req.getCaptainId());
    }

    @CMD(id = CmdCode._66016)
    public void clearAllInvites(PlayerContext playerContext, TeamArenaGMsg.GReqTeamArenaClearAllInvite req) {
        List<ArenaTeamInvite> invitesByRid = teamArenaService.getInvitesByRid(playerContext.getId());
        teamArenaService.remove(invitesByRid);
        playerContext.write(CmdCode._66016, TeamArenaGMsg.GResTeamArenaClearAllInvite.getDefaultInstance());
    }

    @CMD(id = CmdCode._66017)
    public void recommendPlayer(PlayerContext playerContext, TeamArenaGMsg.GResTeamArenaRecommendRole req) {

        ArenaTeam team = teamArenaService.getTeamByRid(playerContext.getId());

        Asserts.notNull(team, ErrorCode.TEAM_ARENA_NOT_HAD_TEAM.getValue(), String.format("玩家未加入队伍{%s}", playerContext.getId()));
        Asserts.isTrue(playerContext.getId() == team.getCaptainId(), ErrorCode.TEAM_ARENA_NOT_CAPTAIN.getValue(),
                String.format("玩家{%s}不是队长{%s}", playerContext.getId(), team.getCaptainId()));

        COpenCondition openCondition = openConditionSysCache.getCondition(EntryType.MAIN_LADDER_WAR);

        List<Long> list = ImmutableList.copyOf(contextManager.getOnlineRids()).stream().filter(rid -> rid > 0).filter(rid -> {
            Role role = roleService.getOrThrow(rid);
            return role.getLevel() >= openCondition.getCondition_value() & teamArenaService.getTeamIdByRid(rid) == null;
        }).collect(Collectors.toList());
        list.stream().filter(rid -> {
            Long teamId = teamArenaService.getTeamIdByRid(rid);
            return teamId == null || teamId.longValue() != team.getTeamId();
        });
        Collections.shuffle(list);
        if (list.size() <= 0) {
            playerContext.write(CmdCode._66017, TeamArenaGMsg.GResTeamArenaRecommendRole.getDefaultInstance());
        } else {
            List<ArenaTeamInvite> invites = teamArenaService.getInvitesByTeamId(team.getTeamId());
            TeamArenaGMsg.GResTeamArenaRecommendRole.Builder builder = TeamArenaGMsg.GResTeamArenaRecommendRole.newBuilder();
            list.subList(0, Math.min(list.size(), 5)).forEach(rid -> {
                TeamArenaGMsg.PBTeamArenaInviteRole.Builder inviteBuilder = TeamArenaGMsg.PBTeamArenaInviteRole.newBuilder();
                inviteBuilder.setRole(teamArenaService.builderMember(rid));
                inviteBuilder.setIsInvite(invites.stream().anyMatch(invite -> invite.getInviteId() == rid));
                builder.addRoles(inviteBuilder);
            });
            playerContext.write(CmdCode._66017, builder.build());
        }
    }

    @CMD(id = CmdCode._66018)
    public void searchPlayer(PlayerContext playerContext, TeamArenaGMsg.GReqTeamArenaSearchRole req) {
        String roleName = req.getRoleName().trim();
        Asserts.isTrue(!StringUtils.isBlank(req.getRoleName()), ErrorCode.TEAM_ARENA_NAME_ILLEGAL.getValue(),
                String.format("队伍名格式不对!name:%s", roleName));

        ArenaTeam team = teamArenaService.getTeamByRid(playerContext.getId());

        Asserts.notNull(team, ErrorCode.TEAM_ARENA_NOT_HAD_TEAM.getValue(), String.format("玩家未加入队伍{%s}", playerContext.getId()));
        Asserts.isTrue(playerContext.getId() == team.getCaptainId(), ErrorCode.TEAM_ARENA_NOT_CAPTAIN.getValue(),
                String.format("玩家{%s}不是队长{%s}", playerContext.getId(), team.getCaptainId()));

        List<Role> searchingRoles = roleService.getNameLike(roleName);
        if (searchingRoles.isEmpty()) {
            playerContext.write(CmdCode._66018, TeamArenaGMsg.GResTeamArenaSearchRole.getDefaultInstance());
        } else {
            List<ArenaTeamInvite> invites = teamArenaService.getInvitesByRid(team.getTeamId());
            TeamArenaGMsg.GResTeamArenaSearchRole.Builder builder = TeamArenaGMsg.GResTeamArenaSearchRole.newBuilder();
            searchingRoles.subList(0, Math.min(searchingRoles.size(), 5)).forEach(role -> {
                TeamArenaGMsg.PBTeamArenaInviteRole.Builder inviteBuilder = TeamArenaGMsg.PBTeamArenaInviteRole.newBuilder();
                inviteBuilder.setRole(teamArenaService.builderMember(role.getId()));
                inviteBuilder.setIsInvite(invites.stream().anyMatch(invite -> invite.getInviteId() == role.getId()));
                builder.addRoles(inviteBuilder);
            });
            playerContext.write(CmdCode._66018, builder.build());
        }
    }

    @CMD(id = CmdCode._66020)
    public void redState(PlayerContext playerContext, TeamArenaGMsg.GReqTeamArenaRedState req) {
        teamArenaRedService.sendRedState(playerContext.getId());
    }

    private enum ApplyResult {
        APPLY_SUCCESS(1),
        JOIN(2),
        TEAM_MAX(3),
        TEAM_CONDITION(4),
        HAD_JOIN(5),
        ;
        private int code;

        ApplyResult(int code) {
            this.code = code;
        }

        public int getCode() {
            return code;
        }
    }
}
