/**
 * 
 */
package com.ayjs.mxzg.cross.module.clanworldboss.handler;

import com.ayjs.mxzg.battle.command.BattleCommand;
import com.ayjs.mxzg.battle.model.BattleResult;
import com.ayjs.mxzg.battle.model.BattleType;
import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.Faction;
import com.ayjs.mxzg.battle.model.UnitType;
import com.ayjs.mxzg.battle.model.mirror.BattlerVo;
import com.ayjs.mxzg.battle.model.mirror.HeroVo;
import com.ayjs.mxzg.common.command.serivce.CommandBus;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.gson.GsonUtils;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.ClanWorldBossMissionSysCache;
import com.ayjs.mxzg.config.excel.cache.ClanWorldBossStageSysCache;
import com.ayjs.mxzg.config.excel.constant.ClanWorldBossConst;
import com.ayjs.mxzg.config.excel.entity.CClanWorldBossMission;
import com.ayjs.mxzg.config.excel.entity.CClanWorldBossStage;
import com.ayjs.mxzg.cross.module.MessageHelper;
import com.ayjs.mxzg.cross.module.clan.domain.CrossClan;
import com.ayjs.mxzg.cross.module.clan.service.CrossClanService;
import com.ayjs.mxzg.cross.module.clanworldboss.domain.ClanWorldBossMember;
import com.ayjs.mxzg.cross.module.clanworldboss.domain.ClanWorldBossStageControl;
import com.ayjs.mxzg.cross.module.clanworldboss.event.ClanWorldBossRolePointEvent;
import com.ayjs.mxzg.cross.module.clanworldboss.service.ClanWorldBossClanRankService;
import com.ayjs.mxzg.cross.module.clanworldboss.service.ClanWorldBossMemberService;
import com.ayjs.mxzg.cross.module.clanworldboss.service.ClanWorldBossResultService;
import com.ayjs.mxzg.cross.module.clanworldboss.service.ClanWorldBossRoleRankService;
import com.ayjs.mxzg.cross.module.clanworldboss.service.ClanWorldBossService;
import com.ayjs.mxzg.cross.module.clanworldboss.struct.ClanWorldRobRecord;
import com.ayjs.mxzg.cross.module.crossrole.service.CrossRoleService;
import com.ayjs.mxzg.cross.module.hero.service.HeroService;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.CSClanWorldBossClanRank;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.CSClanWorldBossClanRank.CSClanWorldBossClanRankBuilder;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.CSClanWorldBossRoleRank;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.CSClanWorldBossRoleRank.CSClanWorldBossRoleRankBuilder;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.CSRobRecord;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.CSRobRecord.CSRobRecordBuilder;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.CSRobableRole;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.CSRobableRole.CSRobableRoleBuilder;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ReqChallengeClanWorldBossMessage;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ReqGetRobableRoleMessage;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ReqGmCwbChangeStageMessage;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ReqReadRobRecordMessage;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ReqReportCwbRewardMessage;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ReqRobOtherMessage;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ReqScanClanRankMessage;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ReqScanClanWorldBossMessage;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ReqScanRobRecordMessage;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ReqScanRoleRankMessage;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ResChallengeClanWorldBossMessage;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ResChallengeClanWorldBossMessage.ResChallengeClanWorldBossMessageBuilder;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ResGetRobableRoleMessage;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ResGetRobableRoleMessage.ResGetRobableRoleMessageBuilder;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ResReadRobRecordMessage;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ResReadRobRecordMessage.ResReadRobRecordMessageBuilder;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ResRobOtherMessage;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ResRobOtherMessage.ResRobOtherMessageBuilder;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ResScanClanRankMessage;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ResScanClanRankMessage.ResScanClanRankMessageBuilder;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ResScanClanWorldBossMessage;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ResScanClanWorldBossMessage.ResScanClanWorldBossMessageBuilder;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ResScanRobRecordMessage;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ResScanRobRecordMessage.ResScanRobRecordMessageBuilder;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ResScanRoleRankMessage;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ResScanRoleRankMessage.ResScanRoleRankMessageBuilder;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ResTellRobMessage;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ResTellRobMessage.ResTellRobMessageBuilder;
import com.ayjs.mxzg.message.module.floatingIslands.struct.RankData;
import com.ayjs.mxzg.message.module.hero.message.HeroMessage.ResHeroMessage;
import com.ayjs.mxzg.message.module.role.domain.CrossRole;
import com.ayjs.mxzg.module.battle.BattleTemplate;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.ayjs.mxzg.template.constant.GameConstant;
import com.ayjs.rpc.annotation.RemoteMethod;
import com.ayjs.rpc.dispatcher.MessageHandler;
import com.ayjs.rpc.server.Connection;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;


/**
 * @author YY
 *
 */
@Controller
public class ClanWorldBossHandler implements MessageHandler {

	@Autowired
	private ClanWorldBossService clanWorldBossService;
	@Autowired
	private ClanWorldBossMemberService clanWorldBossMemberService;
	@Autowired
	private MessageHelper messageHelper;
	@Autowired
	private ClanWorldBossStageSysCache clanWorldBossStageSysCache;
	@Autowired
	private ClanWorldBossMissionSysCache clanWorldBossMissionSysCache;
	@Autowired
	private BattleTemplate battleTemplate;
	@Autowired
	private CommandBus commandBus;
	@Autowired
	private EventBus eventBus;
	@Autowired
	private ClanWorldBossRoleRankService clanWorldBossRoleRankService;
	@Autowired
	private CrossRoleService crossRoleService;
	@Autowired
	private ClanWorldBossClanRankService clanWorldBossClanRankService;
	@Autowired
	private CrossClanService crossClanService;
	@Autowired
	private ClanWorldBossResultService clanWorldBossResultService;
	@Autowired
	private HeroService heroService;
	
	@RemoteMethod
    public void scanWorldBoss(ReqScanClanWorldBossMessage message, Connection connection) {
		ClanWorldBossStageControl stageControl = clanWorldBossService.getClanWorldBossStage();
		
		ResScanClanWorldBossMessageBuilder builder = ResScanClanWorldBossMessage.builder();
		builder.rid(message.getRid());
		builder.nextStageTime(stageControl.getNextStageTime());
		builder.roundStartTime(stageControl.getRoundStartTime());
		builder.roundEndTime(stageControl.getRoundEndTime());
		builder.bossId(stageControl.getBossId());
		builder.stage(stageControl.getStage());
		
		
		CrossRole role = crossRoleService.getNotThrow(message.getRid());
		
		if(role != null && role.getClanId() > 0) {
			ClanWorldBossMember member = clanWorldBossMemberService.getBossMember(message.getRid());
			builder.challengeCd(member.getChallengeCd());
			builder.challengeCount(member.getChallengeCount());
			builder.robCd(member.getRobCd());
			builder.robCount(member.getRobCount());
			for(ClanWorldRobRecord robRecord : member.getRecords()) {
				if(robRecord.getRead() == 0) {
					builder.hasNewRecord(1);
					break;
				}
			}
		}
		connection.send(builder.build());
	}
	
	@RemoteMethod
	public void challengeBoss(ReqChallengeClanWorldBossMessage message, Connection connection) {
		
		CrossRole role = crossRoleService.getOrThrow(message.getRid());
		
		Asserts.isTrue(role.getClanId() > 0, ErrorCode.WAR_NOT_IN_CLAN.getValue(), "你还没有加入任何公会");
		
		Asserts.isTrue(clanWorldBossService.isCanChallenge(), ErrorCode.CWB_NOT_CHALLENGE.getValue(), "不在世界BOSS挑战阶段");
		
		ClanWorldBossStageControl stageControl = clanWorldBossService.getClanWorldBossStage();
		
		ClanWorldBossMember member = clanWorldBossMemberService.getBossMember(message.getRid());
		
		CClanWorldBossStage cStage = clanWorldBossStageSysCache.getOrThrow(stageControl.getStageConfigId());
		
		Asserts.isTrue(member.getChallengeCount() < cStage.getMax_challenge(), ErrorCode.CWB_NO_CHALLENGE_COUNT.getValue(), "已经没有挑战次数");
		
		int nowTime = TimeDateUtil.getCurrentTimeInt();
		Asserts.isTrue(nowTime > member.getChallengeCd(), ErrorCode.CWB_CHALLENGE_CD.getValue(), "挑战正在冷却中");
		
		//进行战斗
		List<CClanWorldBossMission> missionList = clanWorldBossMissionSysCache.getByRound(stageControl.getBossId());
		
		//玩家对象
		BattlerVo atkVo = GsonUtils.fromJson(message.getBattlerVoJson(), BattlerVo.class);
		BattlerDo attacker = battleTemplate.queryBattler(atkVo, role.getNick(), Faction.ATTACKER, UnitType.HERO);
		//boss对象
		BattlerDo monster = battleTemplate.queryBattler(missionList, "", Faction.DEFENDER, UnitType.MOSTER);
		
		BattleCommand battleCommand = BattleCommand.createOf(BattleType.CLAN_WORLD_BOSS, attacker, monster);
		commandBus.invoke(battleCommand);
		BattleResult battleResult = battleCommand.getResult();
		
		//伤害积分转换
		long damage = battleResult.getTotalDamage(Faction.ATTACKER);
		int addPoint = (int)Math.ceil(damage * 1.0d / ClanWorldBossConst.DAMAGE_TO_POINT);
		member.setBattlerVo(atkVo);
		member.setDamage(member.getDamage() + damage);
		member.setFighting(message.getFighting());
		member.setPoint(member.getPoint() + addPoint);
		member.setChallengeCount(member.getChallengeCount() + 1);
		member.setChallengeCd(nowTime + cStage.getChallenge_cd());
		member.setPointTime(nowTime);
		clanWorldBossMemberService.update(member);
		//添加参与
		clanWorldBossService.joinToWorldBoss(member);
		
		//
		
		ResChallengeClanWorldBossMessageBuilder builder = ResChallengeClanWorldBossMessage.builder();
		builder.rid(member.getRid());
		builder.challengeCount(member.getChallengeCount());
		builder.challengeCd(member.getChallengeCd());
		builder.point(member.getPoint());
		builder.addPoint(addPoint);
		builder.damage(damage);
		builder.battleReport(battleResult.getReport().toByteArray());
		connection.send(builder.build());
		
		//发布玩家积分变化的事情
		eventBus.post(ClanWorldBossRolePointEvent.of(member.getRid(), role.getClanId(), member.getPoint(), nowTime,
				role.getServerId()));
	}
	
	@RemoteMethod
	public void getRobableList(ReqGetRobableRoleMessage message, Connection connection) {
		
		CrossRole role = crossRoleService.getOrThrow(message.getRid());
		
		Asserts.isTrue(role.getClanId() > 0, ErrorCode.WAR_NOT_IN_CLAN.getValue(), "你还没有加入任何公会");
		
		Asserts.isTrue(clanWorldBossService.isCanRob(), ErrorCode.CWB_NOT_ROB.getValue(), "不在世界BOSS掠夺阶段");
		
		ClanWorldBossMember member = clanWorldBossMemberService.getBossMember(message.getRid());
		
		List<ClanWorldBossMember> others = findRobableRoles(message.getRid(), role.getClanId(), role.getServerId());
		member.getRobingRoles().clear();
		for(ClanWorldBossMember other : others) {
			member.getRobingRoles().add(other.getRid());
		}
		clanWorldBossMemberService.update(member);
		
		List<CSRobableRole> list = new ArrayList<>();
		for(long rid : member.getRobingRoles()) {
			list.add(serializeRobableRole(rid));
		}
		list.sort(Comparator.comparingInt(CSRobableRole::getRank));
		
		
		ResGetRobableRoleMessageBuilder builder = ResGetRobableRoleMessage.builder();
		builder.rid(message.getRid());
		builder.roles(list);
		connection.send(builder.build());
	}
	
	/**
	 * 查找可以掠夺的玩家
	 * @return
	 */
	private List<ClanWorldBossMember> findRobableRoles(long rid, long clanId, int serverId) {
		int rank = clanWorldBossRoleRankService.getEntityRank(serverId, rid);
		int maxRank = clanWorldBossRoleRankService.getMaxRank(serverId);
		if(rank == 0) {
			//当前玩家没有进榜，则他的排名应该是最大排名加1，比如现在只有1、2名，再一个玩家进来就应该是站在第3名来找
			rank = maxRank + 1;
		}
		List<ClanWorldBossMember> otherList = new ArrayList<>();
		
		//当玩家处于排行榜第一时，第一次向前会没有任何结果，则需要向后找3 + 3个人
		//当玩家处于排行榜最后一名（或者未进榜），第一次向前找会找到3个结果，但向后找会找不到，则需要再一次向前找
		//先向前找
		int frontRank = rank;
		int frontCount = 0;
		int searchRange = ClanWorldBossConst.SEARCH_RANGE;
		while(frontCount < searchRange && frontRank > 1) {
			frontRank = frontRank - 1;
			RankData rankEntity = clanWorldBossRoleRankService.getByRank(serverId, frontRank);
			if(rankEntity == null) {
				continue;
			}
			ClanWorldBossMember other = clanWorldBossMemberService.getBossMember(rankEntity.getRankId());
			if(other == null || other.getClanId() == clanId || other.getRid() == rid) {
				continue;
			}
			otherList.add(other);
			frontCount++;
		}
		//再向后找
		int behindRank = rank;
		int behindCount = 0;
		while(behindCount < searchRange + searchRange - frontCount && behindRank < maxRank) {
			behindRank = behindRank + 1;
			RankData rankEntity = clanWorldBossRoleRankService.getByRank(serverId, behindRank);
			if(rankEntity == null) {
				continue;
			}
			ClanWorldBossMember other = clanWorldBossMemberService.getBossMember(rankEntity.getRankId());
			if(other == null || other.getClanId() == clanId || other.getRid() == rid) {
				continue;
			}
			otherList.add(other);
			behindCount++;
		}
		//再向前找
		int refrontCount = 0;
		while(refrontCount < searchRange + searchRange - frontCount - behindCount && frontRank > 1) {
			frontRank = frontRank - 1;
			RankData rankEntity = clanWorldBossRoleRankService.getByRank(serverId, frontRank);
			if(rankEntity == null) {
				continue;
			}
			ClanWorldBossMember other = clanWorldBossMemberService.getBossMember(rankEntity.getRankId());
			if(other == null || other.getClanId() == clanId || other.getRid() == rid) {
				continue;
			}
			otherList.add(other);
			refrontCount++;
		}
		return otherList;
	}
	
	/**
	 * 序列化可被掠夺的玩家
	 * @param rid
	 * @return
	 */
	private CSRobableRole serializeRobableRole(long rid) {
		CrossRole role = crossRoleService.getOrThrow(rid);
		
		int rank = clanWorldBossRoleRankService.getEntityRank(role.getServerId(), role.getId());
		ClanWorldBossMember member = clanWorldBossMemberService.getBossMember(role.getId());
		
		CSRobableRoleBuilder builder = CSRobableRole.builder();
		
		builder.rid(member.getRid());
		builder.nick(role.getNick());
		builder.rank(rank);
		builder.point(member.getPoint());
		builder.clanName(role.getClanName() == null ? "" : role.getClanName());
		builder.fighting(member.getFighting());
		builder.serverId(role.getServerId());
		
		if(member.getBattlerVo() != null) {
			List<ResHeroMessage> heroList = new ArrayList<>();
			for(HeroVo heroVo : member.getBattlerVo().getHeros()) {
				heroList.add(heroService.serialize(heroVo));
			}
			heroList.sort(Comparator.comparingInt(ResHeroMessage::getPos));
			builder.heros(heroList);
		}
		return builder.build();
	}
	
	private final static String PREFIX = "CWB:";
	
	/**
	 * 掠夺玩家
	 */
	@RemoteMethod
	public void robOther(ReqRobOtherMessage message, Connection connection) {
		
		CrossRole role = crossRoleService.getOrThrow(message.getRid());
		
		Asserts.isTrue(role.getClanId() > 0, ErrorCode.WAR_NOT_IN_CLAN.getValue(), "你还没有加入任何公会");
		
		Asserts.isTrue(clanWorldBossService.isCanRob(), ErrorCode.CWB_NOT_ROB.getValue(), "不在世界BOSS掠夺阶段");
		
		ClanWorldBossStageControl stageControl = clanWorldBossService.getClanWorldBossStage();
		
		ClanWorldBossMember member = clanWorldBossMemberService.getBossMember(message.getRid());
		
		CClanWorldBossStage cStage = clanWorldBossStageSysCache.getOrThrow(stageControl.getStageConfigId());
		
		Asserts.isTrue(member.getRobCount() < cStage.getMax_rob(), ErrorCode.CWB_NO_ROB_COUNT.getValue(), "已经没有掠夺次数");
		
		int nowTime = TimeDateUtil.getCurrentTimeInt();
		Asserts.isTrue(nowTime > member.getRobCd(), ErrorCode.CWB_ROB_CD.getValue(), "掠夺正在冷却中");
		
		Asserts.isTrue(member.getRobingRoles().contains(message.getTargetRid()), ErrorCode.CWB_NOT_IN_ROBLIST.getValue(), "该玩家不在你的可掠夺列表中");
		
		BattleResult result = null;
		
		int robPoint = 0;
		long damage = 0;
		
		
		CrossRole other = crossRoleService.getOrThrow(message.getTargetRid());
		
		long bigRole = 0;
		long smallRole = 0;
		if(role.getId() > other.getId()) {
			bigRole = role.getId();
			smallRole = other.getId();
		} else {
			bigRole = other.getId();
			smallRole = role.getId();
		}
		
		synchronized ((PREFIX + bigRole).intern()) {
			synchronized ((PREFIX + smallRole).intern()) {
				
				CrossRole atk = role;
				CrossRole def = other;
				
				ClanWorldBossMember otherMember = clanWorldBossMemberService.getBossMember(message.getTargetRid());
				//进攻方
				BattlerVo atkVo = GsonUtils.fromJson(message.getBattlerVoJson(), BattlerVo.class);
				BattlerDo attacker = battleTemplate.queryBattler(atkVo, atk.getNick(), Faction.ATTACKER, UnitType.HERO);
				attacker.setRoleInfo(atk.getServerId(), atk.getHeadId(), atk.getBorderId(), atk.getLevel(), message.getFighting());
				//防守方
				BattlerDo defender = battleTemplate.queryBattler(otherMember.getBattlerVo(), def.getNick(), Faction.DEFENDER, UnitType.HERO);
				defender.setRoleInfo(def.getServerId(), def.getHeadId(), def.getBorderId(), def.getLevel(), otherMember.getFighting());
				
				//进行战斗
				BattleCommand battleCommand = BattleCommand.createOf(BattleType.CLAN_WORLD_BOSS, attacker, defender);
				commandBus.invoke(battleCommand);
				result = battleCommand.getResult();
				
				damage = result.getTotalDamage(Faction.ATTACKER);
				
				member.setRobCount(member.getRobCount() + 1);
				member.setRobCd(nowTime + cStage.getRob_cd());
				member.setFighting(message.getFighting());
				member.setBattlerVo(atkVo);
				
				if(result.isWin()) {
					//掠夺到的积分
	                robPoint = (int) Math.ceil(otherMember.getPoint() * ClanWorldBossConst.ROB_RATE * 1.0d / GameConstant.WAN);
					
					otherMember.setPoint(otherMember.getPoint() - robPoint);
					otherMember.setPointTime(nowTime);
					
					member.setPoint(member.getPoint() + robPoint);
					member.setPointTime(nowTime);
					
					//添加参与
					clanWorldBossService.joinToWorldBoss(member);
					
					//发布玩家积分变化的事情
					eventBus.post(ClanWorldBossRolePointEvent.of(otherMember.getRid(), otherMember.getClanId(), otherMember.getPoint(), nowTime, other.getServerId()));
					//发布玩家积分变化的事情
					eventBus.post(ClanWorldBossRolePointEvent.of(member.getRid(), member.getClanId(), member.getPoint(), nowTime, role.getServerId()));
				}
				
				//通知被掠夺方积分变化，并通知被掠夺方所在的服务器有积分变动
				ResTellRobMessageBuilder sendBuilder = ResTellRobMessage.builder();
				sendBuilder.rid(otherMember.getRid());
				sendBuilder.point(otherMember.getPoint());
				sendBuilder.serverId(def.getServerId());
				sendBuilder.isWin(result.isWin() ? 1 : 0);
				sendBuilder.battleReport(result.getReport().toByteArray());
				sendBuilder.atkServerId(atk.getServerId());
				messageHelper.pushToMessage(sendBuilder.build());
				
				String battleId = result.getReport().getBattleId();
				//进攻方的记录
				addRobRecord(member, other, otherMember, battleId, 1, result.isWin() ? 1 : 2, robPoint);
				clanWorldBossMemberService.update(member);
				//防守方的记录
				addRobRecord(otherMember, role, member, battleId, 2, result.isWin() ? 2 : 1, robPoint);
				clanWorldBossMemberService.update(otherMember);
			}
		}
		
		ResRobOtherMessageBuilder builder = ResRobOtherMessage.builder();
        builder.rid(member.getRid());
		builder.serverId(role.getServerId());
		builder.robCount(member.getRobCount());
		builder.robCd(member.getRobCd());
		builder.point(member.getPoint());
		builder.battleReport(result.getReport().toByteArray());
		builder.damage(damage);
		builder.addPoint(robPoint);
		connection.send(builder.build());
	}
	
	
	private void addRobRecord(ClanWorldBossMember member, CrossRole other, ClanWorldBossMember otherMember, String battleId, int type, int win, int robPoint) {
		ClanWorldRobRecord record = new ClanWorldRobRecord();
		record.setBattleId(battleId);
		record.setRid(other.getId());
		record.setNick(other.getNick());
		record.setStrength(otherMember.getFighting());
		record.setHeadId(other.getHeadId());
		record.setBorderId(other.getBorderId());
		record.setLevel(other.getLevel());
		record.setTime(TimeDateUtil.getCurrentTimeInt());
		record.setType(type);
		record.setDelta(robPoint);
		record.setWin(win);
		record.setServerId(other.getServerId());
		member.getRecords().add(0, record);
		while(member.getRecords().size() > ClanWorldBossConst.MAX_RECORD) {
			member.getRecords().remove(ClanWorldBossConst.MAX_RECORD);
		}
	}
	
	/**
	 * 查看公会排名
	 * @param playerContext
	 * @param msg
	 */
	@RemoteMethod
	public void scanClanRank(ReqScanClanRankMessage message, Connection connection) {
		CrossRole role = crossRoleService.getOrThrow(message.getRid());
		
		Asserts.isTrue(role.getClanId() > 0, ErrorCode.WAR_NOT_IN_CLAN.getValue(), "你还没有加入任何公会");

        List<RankData> rankList = clanWorldBossClanRankService.showRanks(role.getServerId(), 50);
		
        ResScanClanRankMessageBuilder builder = ResScanClanRankMessage.builder();
        builder.rid(role.getId());
        
        RankData myRank = clanWorldBossClanRankService.getRankEntity(role.getServerId(), role.getClanId());
        if(myRank == null) {
        	CSClanWorldBossClanRank myClan = serialize(role.getClanId());
        	if(myClan != null) {
        		builder.myClan(myClan);
        	}
        } else {
        	CSClanWorldBossClanRank myClan = serialize(myRank);
        	if(myClan != null) {
        		builder.myClan(myClan);
        	}
        }
		List<CSClanWorldBossClanRank> ranks = new ArrayList<>();
        for (RankData crossRank : rankList) {
        	CSClanWorldBossClanRank clanRank = serialize(crossRank);
        	if(clanRank != null) {
        		ranks.add(clanRank);
        	}
		}
        builder.ranks(ranks);
        connection.send(builder.build());
	}
	
	private CSClanWorldBossClanRank serialize(long clanId) {
		CrossClan crossClan = crossClanService.get(clanId);
		if(crossClan == null) {
			return null;
		}
		
		int rankNum = clanWorldBossClanRankService.getEntityRank(crossClan.getServerId(), crossClan.getId());
		
		CSClanWorldBossClanRankBuilder builder = CSClanWorldBossClanRank.builder();
		builder.clanId(crossClan.getId());
		builder.clanName(crossClan.getClanName());
		builder.point(clanWorldBossService.getClanPoint(crossClan.getId()));
		builder.rank(rankNum);
		builder.serverId(crossClan.getServerId());
		return builder.build();
	}
	
	private CSClanWorldBossClanRank serialize(RankData crossRank) {
		CrossClan crossClan = crossClanService.get(crossRank.getRankId());
		if(crossClan == null) {
			return null;
		}
		
		int rankNum = clanWorldBossClanRankService.getEntityRank(crossClan.getServerId(), crossClan.getId());
		
		CSClanWorldBossClanRankBuilder builder = CSClanWorldBossClanRank.builder();
		builder.clanId(crossClan.getId());
		builder.clanName(crossClan.getClanName());
		builder.point(crossRank.getRankValue());
		builder.rank(rankNum);
		builder.serverId(crossClan.getServerId());
		return builder.build();
	}
	
	/**
	 * 查看玩家排名
	 */
	@RemoteMethod
	public void scanRoleRank(ReqScanRoleRankMessage message, Connection connection) {
		CrossRole role = crossRoleService.getOrThrow(message.getRid());
		
		Asserts.isTrue(role.getClanId() > 0, ErrorCode.WAR_NOT_IN_CLAN.getValue(), "你还没有加入任何公会");
	
		ClanWorldBossMember member = clanWorldBossMemberService.getBossMember(role.getId());
		
		ResScanRoleRankMessageBuilder builder = ResScanRoleRankMessage.builder();
		builder.rid(role.getId());
		
		List<RankData> rankList = clanWorldBossRoleRankService.showRanks(role.getServerId(), 50);
		
		int rank = clanWorldBossRoleRankService.getEntityRank(role.getServerId(), role.getId());
		
		CSClanWorldBossRoleRankBuilder model = CSClanWorldBossRoleRank.builder();
		model.rid(role.getId());
		model.nick(role.getNick());
		model.point(member.getPoint());
		model.rank(rank);
		model.serverId(role.getServerId());
		builder.myRank(model.build());
		
		List<CSClanWorldBossRoleRank> ranks = new ArrayList<>();
		for(RankData data : rankList) {
			CrossRole other = crossRoleService.getOrThrow(data.getRankId());
			int otherRank = clanWorldBossRoleRankService.getEntityRank(other.getServerId(), other.getId());
			
			CSClanWorldBossRoleRankBuilder model0 = CSClanWorldBossRoleRank.builder();
			model0.rid(other.getId());
			model0.nick(other.getNick());
			model0.point(data.getRankValue());
			model0.rank(otherRank);
			model0.serverId(other.getServerId());
			ranks.add(model0.build());
		}
		builder.ranks(ranks);
		connection.send(builder.build());
	}
	
	@RemoteMethod
	public void scanRobRecord(ReqScanRobRecordMessage message, Connection connection) {
		ClanWorldBossMember member = clanWorldBossMemberService.getBossMember(message.getRid());
		
		ResScanRobRecordMessageBuilder builder = ResScanRobRecordMessage.builder();
		builder.rid(message.getRid());
		
		List<CSRobRecord> records = new ArrayList<>();
		for(ClanWorldRobRecord record : member.getRecords()) {
			CSRobRecordBuilder model = CSRobRecord.builder();
			model.battleId(record.getBattleId());
			model.nick(record.getNick());
			model.strength(record.getStrength());
			model.headId(record.getHeadId());
			model.borderId(record.getBorderId());
			model.level(record.getLevel());
			model.time(record.getTime());
			model.type(record.getType());
			model.delta(record.getDelta());
			model.win(record.getWin());
			model.rid(record.getRid());
			model.serverId(record.getServerId());
			records.add(model.build());
		}
		builder.records(records);
		connection.send(builder.build());
	}
	
	@RemoteMethod
	public void readRobRecord(ReqReadRobRecordMessage message, Connection connection) {
		ClanWorldBossMember member = clanWorldBossMemberService.getBossMember(message.getRid());
		boolean needUpdate = false;
		for(ClanWorldRobRecord record : member.getRecords()) {
			if(record.getRead() == 0) {
				record.setRead(1);
				needUpdate = true;
			}
		}
		if(needUpdate) {
			clanWorldBossMemberService.update(member);
		}
		ResReadRobRecordMessageBuilder builder = ResReadRobRecordMessage.builder();
		builder.rid(message.getRid());
		connection.send(builder.build());
	}
	
	@RemoteMethod
	public void gmChangeStage(ReqGmCwbChangeStageMessage message) {
		System.out.println("ReqGmCwbChangeStageMessage");
		clanWorldBossService.gmTransformStage();
	}
	
	
	@RemoteMethod
	public void reportReward(ReqReportCwbRewardMessage message) {
		clanWorldBossResultService.updateResult(message.getRound(), message.getServerId());
	}
}
