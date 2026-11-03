/**
 *
 */
package com.ayjs.mxzg.gameserver.module.clanworldboss.handler;

import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.Faction;
import com.ayjs.mxzg.battle.model.mirror.BattlerVo;
import com.ayjs.mxzg.common.command.serivce.CommandBus;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.gson.GsonUtils;
import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.ClanWorldBossRewardClanSysCache;
import com.ayjs.mxzg.config.excel.cache.ClanWorldBossRewardPlayerSysCache;
import com.ayjs.mxzg.config.excel.cache.ClanWorldBossSysCache;
import com.ayjs.mxzg.config.excel.constant.ClanWorldBossConst;
import com.ayjs.mxzg.config.excel.entity.CClanWorldBoss;
import com.ayjs.mxzg.config.excel.entity.CClanWorldBossRewardClan;
import com.ayjs.mxzg.config.excel.entity.CClanWorldBossRewardPlayer;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.LineUpType;
import com.ayjs.mxzg.gameserver.infrastructure.constant.ServerConfig;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.battle.BattleHelper;
import com.ayjs.mxzg.gameserver.module.clanworldboss.constant.ClanWorldBossStage;
import com.ayjs.mxzg.gameserver.module.clanworldboss.domain.ClanWorldBossReport;
import com.ayjs.mxzg.gameserver.module.clanworldboss.event.ClanWorldBossBattleEvent;
import com.ayjs.mxzg.gameserver.module.clanworldboss.event.ClanWorldBossEndEvent;
import com.ayjs.mxzg.gameserver.module.clanworldboss.event.ClanWorldBossFirstEvent;
import com.ayjs.mxzg.gameserver.module.clanworldboss.event.ClanWorldBossStageEvent;
import com.ayjs.mxzg.gameserver.module.clanworldboss.service.ClanWorldBossReportService;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroLineUp;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroLineUpService;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.mail.constant.MailScene;
import com.ayjs.mxzg.gameserver.module.mail.domain.Mail;
import com.ayjs.mxzg.gameserver.module.mail.service.MailService;
import com.ayjs.mxzg.gameserver.module.mail.struct.MailParams;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.server.service.ServerParamService;
import com.ayjs.mxzg.gameserver.module.video.constant.VideoType;
import com.ayjs.mxzg.gameserver.module.video.event.VideoRecordEvent;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.CSClanMemberRank;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.CSClanRank;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.CSClanWorldBossClanRank;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.CSClanWorldBossRoleRank;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.CSRobRecord;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.CSRobableRole;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ReqChallengeClanWorldBossMessage;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ReqChallengeClanWorldBossMessage.ReqChallengeClanWorldBossMessageBuilder;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ReqGetRobableRoleMessage;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ReqGetRobableRoleMessage.ReqGetRobableRoleMessageBuilder;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ReqReadRobRecordMessage;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ReqReadRobRecordMessage.ReqReadRobRecordMessageBuilder;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ReqReportCwbRewardMessage;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ReqReportCwbRewardMessage.ReqReportCwbRewardMessageBuilder;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ReqRobOtherMessage;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ReqRobOtherMessage.ReqRobOtherMessageBuilder;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ReqScanClanRankMessage;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ReqScanClanRankMessage.ReqScanClanRankMessageBuilder;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ReqScanClanWorldBossMessage;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ReqScanClanWorldBossMessage.ReqScanClanWorldBossMessageBuilder;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ReqScanRobRecordMessage;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ReqScanRobRecordMessage.ReqScanRobRecordMessageBuilder;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ReqScanRoleRankMessage;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ReqScanRoleRankMessage.ReqScanRoleRankMessageBuilder;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ResChallengeClanWorldBossMessage;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ResGetRobableRoleMessage;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ResReadRobRecordMessage;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ResRobOtherMessage;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ResScanClanRankMessage;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ResScanClanWorldBossMessage;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ResScanRobRecordMessage;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ResScanRoleRankMessage;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ResTellEndMessage;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ResTellFirstMessage;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ResTellRobMessage;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ResTellStageChangeMessage;
import com.ayjs.mxzg.message.module.hero.message.HeroMessage.ResHeroMessage;
import com.ayjs.mxzg.module.battle.command.SaveBattleReportCommand;
import com.ayjs.mxzg.protocol.BattleGMsg.BattleReport;
import com.ayjs.mxzg.protocol.ClanWorldBossGMsg.GReqChallengeBoss;
import com.ayjs.mxzg.protocol.ClanWorldBossGMsg.GReqGetRobableRole;
import com.ayjs.mxzg.protocol.ClanWorldBossGMsg.GReqReadNewRecord;
import com.ayjs.mxzg.protocol.ClanWorldBossGMsg.GReqRobOtherRole;
import com.ayjs.mxzg.protocol.ClanWorldBossGMsg.GReqScanClanRank;
import com.ayjs.mxzg.protocol.ClanWorldBossGMsg.GReqScanRobHis;
import com.ayjs.mxzg.protocol.ClanWorldBossGMsg.GReqScanRoleRank;
import com.ayjs.mxzg.protocol.ClanWorldBossGMsg.GReqScanWorldBoss;
import com.ayjs.mxzg.protocol.ClanWorldBossGMsg.GResBossPointChange;
import com.ayjs.mxzg.protocol.ClanWorldBossGMsg.GResChallengeBoss;
import com.ayjs.mxzg.protocol.ClanWorldBossGMsg.GResGetRobableRole;
import com.ayjs.mxzg.protocol.ClanWorldBossGMsg.GResReadNewRecord;
import com.ayjs.mxzg.protocol.ClanWorldBossGMsg.GResRobByOtherRole;
import com.ayjs.mxzg.protocol.ClanWorldBossGMsg.GResRobOtherRole;
import com.ayjs.mxzg.protocol.ClanWorldBossGMsg.GResScanClanRank;
import com.ayjs.mxzg.protocol.ClanWorldBossGMsg.GResScanRobHis;
import com.ayjs.mxzg.protocol.ClanWorldBossGMsg.GResScanRoleRank;
import com.ayjs.mxzg.protocol.ClanWorldBossGMsg.GResScanWorldBoss;
import com.ayjs.mxzg.protocol.ClanWorldBossGMsg.PSBossClanRank;
import com.ayjs.mxzg.protocol.ClanWorldBossGMsg.PSBossRoleRank;
import com.ayjs.mxzg.protocol.ClanWorldBossGMsg.PSRobRecord;
import com.ayjs.mxzg.protocol.ClanWorldBossGMsg.PSRobableRole;
import com.ayjs.mxzg.protocol.HeroGMsg.ResHeroData;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.ayjs.rpc.annotation.RemoteMethod;
import com.ayjs.rpc.dispatcher.MessageDispatcher;
import com.ayjs.rpc.dispatcher.MessageHandler;
import com.google.protobuf.InvalidProtocolBufferException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

/**
 * @author YY
 *
 */
@Slf4j
@Controller
public class ClanWorldBossHandler extends ProtocolHandler implements MessageHandler {
    @Autowired
    private EventBus eventBus;
    @Autowired
    private RoleService roleService;
    @Autowired
    private HeroLineUpService heroLineUpService;
    @Autowired
    private ContextManager contextManager;
    @Autowired
    private BattleHelper battleHelper;
    @Autowired
    private CommandBus commandBus;
    @Autowired
    private MessageDispatcher messageDispatcher;
    @Autowired
    private ServerConfig serverConfig;
    @Autowired
    private ClanWorldBossSysCache clanWorldBossSysCache;
    @Autowired
    private ClanWorldBossRewardClanSysCache clanWorldBossRewardClanSysCache;
    @Autowired
    private ClanWorldBossRewardPlayerSysCache clanWorldBossRewardPlayerSysCache;
    @Autowired
    private MailService mailService;
    @Autowired
    private ClanWorldBossReportService clanWorldBossReportService;
    @Autowired
    private HeroService heroService;
    @Autowired
    private ServerParamService serverParamService;

    /**
     * 查看公会世界BOSS信息
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._33001)
    public void scanWorldBoss(PlayerContext playerContext, GReqScanWorldBoss msg) {

        int nowTime = TimeDateUtil.getCurrentTimeInt();

        int clanWorldBossFirstTime = TimeDateUtil.getSomedayZeroInt(serverParamService.getServerStartTime())
                + TimeDateUtil.ONEDAYINT * ClanWorldBossConst.OPEN_DAY;
        if (nowTime >= clanWorldBossFirstTime) {
            ReqScanClanWorldBossMessageBuilder builder = ReqScanClanWorldBossMessage.builder();
            builder.rid(playerContext.getId());
            messageDispatcher.dispatch(builder.build());
        } else {
            GResScanWorldBoss.Builder builder = GResScanWorldBoss.newBuilder();
            builder.setRoundStartTime(Integer.MAX_VALUE);
            builder.setRoundEndTime(Integer.MAX_VALUE);
            builder.setBossId(1);
            builder.setNextStageTime(Integer.MAX_VALUE);
            builder.setStage(ClanWorldBossStage.IDLE);
            playerContext.write(CmdCode._33001, builder.build());
        }
    }

    @RemoteMethod
    public void scanWorldBoss(ResScanClanWorldBossMessage message) {
        GResScanWorldBoss.Builder builder = GResScanWorldBoss.newBuilder();
        builder.setRoundStartTime(message.getRoundStartTime());
        builder.setRoundEndTime(message.getRoundEndTime());
        builder.setBossId(message.getBossId());
        builder.setNextStageTime(message.getNextStageTime());
        builder.setStage(message.getStage());
        builder.setChallengeCd(message.getChallengeCd());
        builder.setChallengeCount(message.getChallengeCount());
        builder.setRobCd(message.getRobCd());
        builder.setRobCount(message.getRobCount());
        builder.setHasNewRecord(message.getHasNewRecord());
        contextManager.write(message.getRid(), CmdCode._33001, builder.build());
    }


    /**
     * 挑战公会世界BOSS
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._33002)
    public void challengeBoss(PlayerContext playerContext, GReqChallengeBoss msg) {
        Role role = roleService.getOrThrow(playerContext.getId());

        Asserts.isTrue(role.getClanId() > 0, ErrorCode.WAR_NOT_IN_CLAN.getValue(), "你还没有加入任何公会");

        HeroLineUp heroLineUp = heroLineUpService.getLineUpByType(playerContext.getId(), LineUpType.CLAN_WORLD_BOSS);
        Asserts.isTrue(!heroLineUp.getFormationMap().isEmpty(), ErrorCode.CWB_NO_FORMATION.getValue(), "还没有布设世界BOSS战斗阵容");

        BattlerDo battlerDo = battleHelper.queryPlayerBattler(LineUpType.CLAN_WORLD_BOSS, role.getId(), Faction.ATTACKER);
        BattlerVo battlerVo = battlerDo.toBattlerVo();

        int fighting = heroLineUpService.getLineUpFighting(heroLineUp);

        ReqChallengeClanWorldBossMessageBuilder builder = ReqChallengeClanWorldBossMessage.builder();
        builder.rid(role.getId());
        builder.battlerVoJson(GsonUtils.toJson(battlerVo));
        builder.fighting(fighting);
        messageDispatcher.dispatch(builder.build());
    }

    @RemoteMethod
    public void challengeBoss(ResChallengeClanWorldBossMessage message) {
        try {
            GResChallengeBoss.Builder builder = GResChallengeBoss.newBuilder();
            builder.setChallengeCount(message.getChallengeCount());
            builder.setChallengeCd(message.getChallengeCd());
            builder.setPoint(message.getPoint());
            builder.setReport(BattleReport.parseFrom(message.getBattleReport()));
            builder.setDamage(message.getDamage());
            builder.setAddPoint(message.getAddPoint());
            contextManager.write(message.getRid(), CmdCode._33002, builder.build());

            //通知本服务器内的玩家boss积分发生变化
            contextManager.writeAll(CmdCode._33008, GResBossPointChange.getDefaultInstance());

            eventBus.post(ClanWorldBossBattleEvent.of(message.getRid()));

        } catch (InvalidProtocolBufferException e) {
            throw new RuntimeException(e);
        }
    }


    /**
     * 查看可掠夺的玩家列表
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._33003)
    public void getRobableList(PlayerContext playerContext, GReqGetRobableRole msg) {
        ReqGetRobableRoleMessageBuilder builder = ReqGetRobableRoleMessage.builder();
        builder.rid(playerContext.getId());
        messageDispatcher.dispatch(builder.build());
    }

    @RemoteMethod
    public void getRobableList(ResGetRobableRoleMessage message) {
        GResGetRobableRole.Builder builder = GResGetRobableRole.newBuilder();
        List<PSRobableRole> list = new ArrayList<>();
        if (message.getRoles() != null) {
            for (CSRobableRole other : message.getRoles()) {
                list.add(serializeRobableRole(other));
            }
        }
        list.sort(Comparator.comparingInt(PSRobableRole::getRank));
        builder.addAllRoles(list);
        contextManager.write(message.getRid(), CmdCode._33003, builder.build());
    }


    /**
     * 序列化可被掠夺的玩家
     * @param rid
     * @return
     */
    private PSRobableRole serializeRobableRole(CSRobableRole role) {
        PSRobableRole.Builder builder = PSRobableRole.newBuilder();
        builder.setRid(role.getRid());
        builder.setNick(role.getNick());
        builder.setRank(role.getRank());
        builder.setPoint(role.getPoint());
        builder.setClanName(role.getClanName());
        builder.setFighting(role.getFighting());
        builder.setServerId(role.getServerId());
        if (role.getHeros() != null) {
            for (ResHeroMessage hero : role.getHeros()) {
                ResHeroData model = heroService.serialize(hero);
                builder.addHeros(model);
            }
        }
        return builder.build();
    }

    /**
     * 掠夺玩家
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._33004)
    public void robOther(PlayerContext playerContext, GReqRobOtherRole msg) {
        Role role = roleService.getOrThrow(playerContext.getId());
        Asserts.isTrue(role.getClanId() > 0, ErrorCode.WAR_NOT_IN_CLAN.getValue(), "你还没有加入任何公会");

        HeroLineUp heroLineUp = heroLineUpService.getLineUpByType(playerContext.getId(), LineUpType.CLAN_WORLD_BOSS);
        Asserts.isTrue(!heroLineUp.getFormationMap().isEmpty(), ErrorCode.CWB_NO_FORMATION.getValue(), "还没有布设世界BOSS战斗阵容");

        BattlerDo battlerDo = battleHelper.queryPlayerBattler(LineUpType.CLAN_WORLD_BOSS, playerContext.getId(), Faction.ATTACKER);
        BattlerVo battlerVo = battlerDo.toBattlerVo();

        int fighting = heroLineUpService.getLineUpFighting(heroLineUp);

        ReqRobOtherMessageBuilder builder = ReqRobOtherMessage.builder();
        builder.rid(playerContext.getId());
        builder.targetRid(msg.getRid());
        builder.battlerVoJson(GsonUtils.toJson(battlerVo));
        builder.fighting(fighting);
        messageDispatcher.dispatch(builder.build());
    }

    @RemoteMethod
    public void robOther(ResRobOtherMessage message) {
        try {
            BattleReport report = BattleReport.parseFrom(message.getBattleReport());

            //保存战报
            commandBus.invoke(SaveBattleReportCommand.of(report));

            GResRobOtherRole.Builder builder = GResRobOtherRole.newBuilder();
            builder.setRobCount(message.getRobCount());
            builder.setRobCd(message.getRobCd());
            builder.setPoint(message.getPoint());
            builder.setReport(report);
            builder.setDamage(message.getDamage());
            builder.setAddPoint(message.getAddPoint());
            contextManager.write(message.getRid(), CmdCode._33004, builder.build());

            //进行战斗录像保存
            eventBus.post(VideoRecordEvent.of(VideoType.WORLD_BOSS, 0, report, ""));
            //通知本服务器内的玩家boss积分发生变化
            contextManager.writeAll(CmdCode._33008, GResBossPointChange.getDefaultInstance());
        } catch (InvalidProtocolBufferException e) {
            e.printStackTrace();
        }
    }

    /**
     * 查看公会排名
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._33005)
    public void scanClanRank(PlayerContext playerContext, GReqScanClanRank msg) {
        ReqScanClanRankMessageBuilder builder = ReqScanClanRankMessage.builder();
        builder.rid(playerContext.getId());
        messageDispatcher.dispatch(builder.build());
    }

    @RemoteMethod
    public void scanClanRank(ResScanClanRankMessage message) {
        GResScanClanRank.Builder builder = GResScanClanRank.newBuilder();
        builder.setMyClan(serialize(message.getMyClan()));
        if (message.getRanks() != null) {
            for (CSClanWorldBossClanRank rank : message.getRanks()) {
                builder.addRanks(serialize(rank));
            }
        }
        contextManager.write(message.getRid(), CmdCode._33005, builder.build());
    }

    private PSBossClanRank serialize(CSClanWorldBossClanRank clanRank) {
        PSBossClanRank.Builder builder = PSBossClanRank.newBuilder();
        if (clanRank != null) {
            builder.setClanId(clanRank.getClanId());
            builder.setClanName(clanRank.getClanName());
            builder.setPoint(clanRank.getPoint());
            builder.setRank(clanRank.getRank());
            builder.setServerId(clanRank.getServerId());
        }
        return builder.build();
    }

    /**
     * 查看玩家排名
     * @param playerContext
     * @param msg
     */
    @CMD(id = CmdCode._33006)
    public void scanRoleRank(PlayerContext playerContext, GReqScanRoleRank msg) {
        ReqScanRoleRankMessageBuilder builder = ReqScanRoleRankMessage.builder();
        builder.rid(playerContext.getId());
        messageDispatcher.dispatch(builder.build());
    }

    @RemoteMethod
    public void scanRoleRank(ResScanRoleRankMessage message) {
        GResScanRoleRank.Builder builder = GResScanRoleRank.newBuilder();
        builder.setMyRank(serialize(message.getMyRank()));
        if (message.getRanks() != null) {
            for (CSClanWorldBossRoleRank data : message.getRanks()) {
                builder.addRanks(serialize(data));
            }
        }
        contextManager.write(message.getRid(), CmdCode._33006, builder.build());
    }

    private PSBossRoleRank serialize(CSClanWorldBossRoleRank roleRank) {
        PSBossRoleRank.Builder builder = PSBossRoleRank.newBuilder();
        builder.setRid(roleRank.getRid());
        builder.setNick(roleRank.getNick());
        builder.setPoint(roleRank.getPoint());
        builder.setRank(roleRank.getRank());
        builder.setServerId(roleRank.getServerId());
        return builder.build();
    }


    @CMD(id = CmdCode._33009)
    public void scanRobRecord(PlayerContext playerContext, GReqScanRobHis msg) {
        ReqScanRobRecordMessageBuilder builder = ReqScanRobRecordMessage.builder();
        builder.rid(playerContext.getId());
        messageDispatcher.dispatch(builder.build());
    }

    @RemoteMethod
    public void scanRobRecord(ResScanRobRecordMessage message) {
        GResScanRobHis.Builder builder = GResScanRobHis.newBuilder();

        if (message.getRecords() != null) {
            for (CSRobRecord record : message.getRecords()) {
                PSRobRecord.Builder model = PSRobRecord.newBuilder();
                model.setBattleId(record.getBattleId());
                model.setNick(record.getNick());
                model.setStrength(record.getStrength());
                model.setHeadId(record.getHeadId());
                model.setBorderId(record.getBorderId());
                model.setLevel(record.getLevel());
                model.setTime(record.getTime());
                model.setType(record.getType());
                model.setDelta(record.getDelta());
                model.setWin(record.getWin());
                model.setRid(record.getRid());
                model.setServerId(record.getServerId());
                builder.addRecords(model);
            }
        }
        contextManager.write(message.getRid(), CmdCode._33009, builder.build());
    }


    @CMD(id = CmdCode._33010)
    public void readRobRecord(PlayerContext playerContext, GReqReadNewRecord msg) {
        ReqReadRobRecordMessageBuilder builder = ReqReadRobRecordMessage.builder();
        builder.rid(playerContext.getId());
        messageDispatcher.dispatch(builder.build());
    }

    @RemoteMethod
    public void readRobRecord(ResReadRobRecordMessage message) {
        contextManager.write(message.getRid(), CmdCode._33010, GResReadNewRecord.getDefaultInstance());
    }

    @RemoteMethod
    public void tellRob(ResTellRobMessage message) {
        //通知对方被掠夺了
        if (message.getIsWin() == 1) {
            GResRobByOtherRole.Builder sendBuilder = GResRobByOtherRole.newBuilder();
            sendBuilder.setPoint(message.getPoint());
            contextManager.write(message.getRid(), CmdCode._33007, sendBuilder.build());

            if (!serverConfig.matchServerId(message.getAtkServerId())) {
                //通知本服务器内的玩家boss积分发生变化
                contextManager.writeAll(CmdCode._33008, GResBossPointChange.getDefaultInstance());
            } else {
                //如果战斗双方是在同一个服务器，那么在进攻方的跨服回调中已经进行了积分变化推送
            }
        }

        if (!serverConfig.matchServerId(message.getAtkServerId())) {
            try {
                BattleReport report = BattleReport.parseFrom(message.getBattleReport());
                //保存战报
                commandBus.invoke(SaveBattleReportCommand.of(report));
                //进行战斗录像保存
                eventBus.post(VideoRecordEvent.of(VideoType.WORLD_BOSS, 0, report, ""));
            } catch (InvalidProtocolBufferException e) {
                e.printStackTrace();
            }
        } else {
            //如果战斗双方是在同一个服务器，那么在进攻方的跨服回调中已经进行了战斗录像的保存
        }
    }

    @RemoteMethod
    public void tellFirst(ResTellFirstMessage message) {
        eventBus.post(ClanWorldBossFirstEvent.of(message.getFristRole(), message.getFirstRoleServer(),
                message.getFirstClan(), message.getFirstClanServer()));
    }

    @RemoteMethod
    public void tellEnd(ResTellEndMessage message) {
        ReqReportCwbRewardMessageBuilder builder = ReqReportCwbRewardMessage.builder();
        builder.round(message.getRound());
        builder.serverId(message.getServerId());

        synchronized (this) {
            ClanWorldBossReport report = clanWorldBossReportService.getByRound(message.getRound())
                    .stream().filter(reportTemp -> reportTemp.getServerId() == message.getServerId()).findFirst().orElse(null);
            if (report != null) {
                //判断已经发过奖则只行进数据回报
                messageDispatcher.dispatch(builder.build());
                log.info("跨服重复发送对世界BOSS轮次{}的发奖通知", message.getRound());
                return;
            }
            report = new ClanWorldBossReport();
            report.setRound(message.getRound());
            report.setServerId(message.getServerId());
            report.setState(1);
            report.setInsertTime(DateTimeUtil.currentSecond());
            clanWorldBossReportService.insert(report);
        }

        List<Mail> mailList = new ArrayList<>();

        for (CSClanRank clan : message.getClans()) {
            if (clan.getJoinMembers() == null) {
                continue;
            }
            CClanWorldBoss cClanWorldBoss = clanWorldBossSysCache.getOrThrow(clan.getBossId());

            CClanWorldBossRewardClan clanReward = clanWorldBossRewardClanSysCache
                    .getByTypeRank(cClanWorldBoss.getReward_rank_type_clan(), clan.getRank());

            for (CSClanMemberRank member : clan.getJoinMembers()) {
                CClanWorldBossRewardPlayer roleReward = clanWorldBossRewardPlayerSysCache
                        .getByTypeRank(cClanWorldBoss.getReward_rank_type_player(), member.getRank());
                long memberId = member.getRid();
                int roleRank = member.getRank();
                if (clanReward != null) {
                    Mail mail = mailService.newMailNoTitle(memberId, MailScene.CWB_CLAN_RANK,
                            MailParams.build(clan.getRank()), clanReward.getRank_reward(), GameEvent.CWB_CLAN_REWARD);
                    mailList.add(mail);
                }
                if (roleReward != null) {
                    Mail mail = mailService.newMailNoTitle(memberId, MailScene.CWB_ROLE_RANK,
                            MailParams.build(roleRank), roleReward.getRank_reward(), GameEvent.CWB_ROLE_REWARD);
                    mailList.add(mail);
                }
            }
            if (clan.getRank() > 0 && clan.getPoint() > 0) {
                eventBus.post(ClanWorldBossEndEvent.of(clan.getClanId(), clan.getRank(), clan.getPoint()));
            }
        }
        if (!mailList.isEmpty()) {
            mailService.insertMails(mailList);
        }
        //上报发奖状态
        messageDispatcher.dispatch(builder.build());
        log.info("向跨服回报世界BOSS轮次{}的发奖状态", message.getRound());
    }

    @RemoteMethod
    public void tellStageChange(ResTellStageChangeMessage message) {
        eventBus.post(ClanWorldBossStageEvent.of(message.getStage(), message.getNextStageTime()));
    }
}
