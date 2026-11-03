/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.clanwar.handler;

import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.Faction;
import com.ayjs.mxzg.battle.model.mirror.BattlerVo;
import com.ayjs.mxzg.common.command.serivce.CommandBus;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.gson.GsonUtils;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.ClanWarAllRewardSysCache;
import com.ayjs.mxzg.config.excel.cache.ClanWarRewardSysCache;
import com.ayjs.mxzg.config.excel.constant.ClanWarConst;
import com.ayjs.mxzg.config.excel.entity.CClanWarAllReward;
import com.ayjs.mxzg.config.excel.entity.CClanWarReward;
import com.ayjs.mxzg.config.struct.GameEvent;
import com.ayjs.mxzg.config.struct.LineUpType;
import com.ayjs.mxzg.gameserver.infrastructure.netty.ContextManager;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.backpack.service.ThingService;
import com.ayjs.mxzg.gameserver.module.battle.BattleHelper;
import com.ayjs.mxzg.gameserver.module.clan.domain.Clan;
import com.ayjs.mxzg.gameserver.module.clan.domain.ClanMember;
import com.ayjs.mxzg.gameserver.module.clan.service.ClanService;
import com.ayjs.mxzg.gameserver.module.clanwar.domain.ClanWarInfo;
import com.ayjs.mxzg.gameserver.module.clanwar.event.ClanWarStageEvent;
import com.ayjs.mxzg.gameserver.module.clanwar.event.ClanWarWinEvent;
import com.ayjs.mxzg.gameserver.module.clanwar.service.ClanWarInfoService;
import com.ayjs.mxzg.gameserver.module.clanwar.service.ClanWarService;
import com.ayjs.mxzg.gameserver.module.clanwar.struct.ClanWarBox;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroLineUp;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroLineUpService;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroService;
import com.ayjs.mxzg.gameserver.module.mail.constant.MailScene;
import com.ayjs.mxzg.gameserver.module.mail.domain.Mail;
import com.ayjs.mxzg.gameserver.module.mail.service.MailService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.gameserver.module.server.service.ServerParamService;
import com.ayjs.mxzg.gameserver.module.util.PbUtil;
import com.ayjs.mxzg.message.module.clanwar.ClanWarMessage.*;
import com.ayjs.mxzg.message.module.clanwar.ClanWarMessage.ReqAdjustRoadSortMessage.ReqAdjustRoadSortMessageBuilder;
import com.ayjs.mxzg.message.module.clanwar.ClanWarMessage.ReqClanWarReportRewardMessage.ReqClanWarReportRewardMessageBuilder;
import com.ayjs.mxzg.message.module.clanwar.ClanWarMessage.ReqSaveRoadFormationMessage.ReqSaveRoadFormationMessageBuilder;
import com.ayjs.mxzg.message.module.clanwar.ClanWarMessage.ReqScanBattlingInfoMessage.ReqScanBattlingInfoMessageBuilder;
import com.ayjs.mxzg.message.module.clanwar.ClanWarMessage.ReqScanHisBattlingInfoMessage.ReqScanHisBattlingInfoMessageBuilder;
import com.ayjs.mxzg.message.module.clanwar.ClanWarMessage.ReqScanMemberRoadInfoMessage.ReqScanMemberRoadInfoMessageBuilder;
import com.ayjs.mxzg.message.module.clanwar.ClanWarMessage.ReqScanRoadInfoMessage.ReqScanRoadInfoMessageBuilder;
import com.ayjs.mxzg.message.module.clanwar.ClanWarMessage.ReqScanWarInfoMessage.ReqScanWarInfoMessageBuilder;
import com.ayjs.mxzg.message.module.hero.message.HeroMessage.ResHeroMessage;
import com.ayjs.mxzg.module.battle.command.SaveBattleReportCommand;
import com.ayjs.mxzg.module.clanwar.constant.ClanWarResult;
import com.ayjs.mxzg.module.clanwar.constant.ClanWarStage;
import com.ayjs.mxzg.protocol.BattleGMsg.BattleReport;
import com.ayjs.mxzg.protocol.ClanWarGMsg.*;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.ayjs.rpc.annotation.RemoteMethod;
import com.ayjs.rpc.dispatcher.MessageDispatcher;
import com.ayjs.rpc.dispatcher.MessageHandler;
import com.google.protobuf.InvalidProtocolBufferException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.util.ArrayList;
import java.util.List;

/**
 * @author YY
 *
 */
@Slf4j
@Controller
public class ClanWarHandler extends ProtocolHandler implements MessageHandler {

	@Autowired
	private RoleService roleService;
	@Autowired
	private ClanService clanService;
	@Autowired
	private HeroService heroService;
	@Autowired
	private ClanWarInfoService clanWarInfoService;
	@Autowired
    private ThingService thingService;
	@Autowired
	private ClanWarRewardSysCache clanWarRewardSysCache;
	@Autowired
	private ContextManager contextManager;
	@Autowired
	private BattleHelper battleHelper;
	@Autowired
	private HeroLineUpService heroLineUpService;
	@Autowired
	private MessageDispatcher messageDispatcher;
	@Autowired
	private ServerParamService serverParamService;
	@Autowired
	private ClanWarService clanWarService;
	@Autowired
	private ClanWarAllRewardSysCache clanWarAllRewardSysCache;
	@Autowired
	private MailService mailService;
	@Autowired
	private EventBus eventBus;
	@Autowired
	private CommandBus commandBus;
	
	/**
	 * 查看公会战信息
	 * @param playerContext
	 * @param msg
	 */
	@CMD(id = CmdCode._31001)
	public void scanWarInfo(PlayerContext playerContext, GReqScanWarInfo msg) {

		
		int clanWarFirstTime = TimeDateUtil.getSomedayZeroInt(serverParamService.getServerStartTime())
				+ TimeDateUtil.ONEDAYINT * ClanWarConst.OPEN_DAY;

		if (clanWarService.isStartClanWar()) {
			ReqScanWarInfoMessageBuilder builder = ReqScanWarInfoMessage.builder();
			builder.rid(playerContext.getId());
			messageDispatcher.dispatch(builder.build());
		} else {
			//本服的公会战还没到首轮开放的时间，则直接组装数据返回
			GResScanWarInfo.Builder builder = GResScanWarInfo.newBuilder();
			builder.setRoundStartTime(Integer.MAX_VALUE);
			builder.setRoundEndTime(Integer.MAX_VALUE);
			builder.setStage(ClanWarStage.IDLE);
			builder.setNextStageTime(Integer.MAX_VALUE);
			builder.setFirstRoundTime(clanWarFirstTime);
			playerContext.write(CmdCode._31001, builder.build());
		}
	}
	
	@RemoteMethod
	public void scanWarInfo(ResScanWarInfoMessage message) {
		GResScanWarInfo.Builder builder = GResScanWarInfo.newBuilder();
		builder.setRoundStartTime(message.getRoundStartTime());
		builder.setRoundEndTime(message.getRoundEndTime());
		builder.setStage(message.getStage());
		builder.setNextStageTime(message.getNextStageTime());
		builder.setFirstRoundTime(message.getFirstRoundTime());
		if(message.getWarInfos() != null) {
			for(CSClanWarInfo clanWarInfo : message.getWarInfos()) {
				builder.addWarInfos(serializeWarInfo(clanWarInfo));
			}
		}
		builder.setCanJoin(message.getCanJoin());
		builder.setIsWin(message.getIsWin());
		contextManager.write(message.getRid(), CmdCode._31001, builder.build());
	}
	
	/**
	 * 序列化公会战信息
	 * @param clanWarInfo
	 * @return
	 */
	private PSClanWarInfo serializeWarInfo(CSClanWarInfo clanWarInfo) {
		PSClanWarInfo.Builder builder = PSClanWarInfo.newBuilder();
		builder.setClanId(clanWarInfo.getClanId());
		builder.setName(clanWarInfo.getName());
		builder.setServerId(clanWarInfo.getServerId());
		if(clanWarInfo.getRoads() != null) {
			for(CSClanWarRoad warRoad : clanWarInfo.getRoads()) {
				PSClanWarRoad.Builder roadBuilder = PSClanWarRoad.newBuilder();
				roadBuilder.setRoad(warRoad.getRoad());
				roadBuilder.setBattling(warRoad.getBattling());
				roadBuilder.setTotal(warRoad.getTotal());
				roadBuilder.setAlive(warRoad.getAlive());
				builder.addRoads(roadBuilder.build());
			}
		}
		return builder.build();
	}
	
	
	/**
	 * 查看路况信息
	 * @param playerContext
	 * @param msg
	 */
	@CMD(id = CmdCode._31002)
	public void scanRoadInfo(PlayerContext playerContext, GReqScanRoadInfo msg) {
		ReqScanRoadInfoMessageBuilder builder = ReqScanRoadInfoMessage.builder();
		builder.rid(playerContext.getId());
		messageDispatcher.dispatch(builder.build());
	}
	
	@RemoteMethod
	public void scanRoadInfo(ResScanRoadInfoMessage message) {
		GResScanRoadInfo.Builder builder = GResScanRoadInfo.newBuilder();
		if(message.getDetails() != null) {
			for(CSClanWarRoadDetail detail : message.getDetails()) {
				builder.addDetails(serializeRoadDetail(detail));
			}
		}
		contextManager.write(message.getRid(), CmdCode._31002, builder.build());
	}
	
	private PSClanWarRoadDetail serializeRoadDetail(CSClanWarRoadDetail detail) {
		PSClanWarRoadDetail.Builder builder = PSClanWarRoadDetail.newBuilder();
		builder.setRoad(detail.getRoad());
		if(detail.getTeams() != null) {
			for(CSClanWarTeam clanWarTeam : detail.getTeams()) {
				builder.addTeams(serializeWarTeam(clanWarTeam));
			}
		}
		return builder.build();
	}
	
	private PSClanWarTeam serializeWarTeam(CSClanWarTeam clanWarTeam) {
		PSClanWarTeam.Builder builder = PSClanWarTeam.newBuilder();
		builder.setRid(clanWarTeam.getRid());
		builder.setName(clanWarTeam.getName());
		builder.setHeroLevel(clanWarTeam.getHeroLevel());
		builder.setHeroType(clanWarTeam.getHeroType());
		builder.setHeroStar(clanWarTeam.getHeroStar());
		builder.setFighting(clanWarTeam.getFighting());
		builder.setFashionId(clanWarTeam.getFashionId());
		builder.setEvolve(PbUtil.builderEvolve(clanWarTeam.getEvolveType(),clanWarTeam.getEvolveLevel()));
		return builder.build();
	}
	
	/**
	 * 保存布阵数据
	 * @param playerContext
	 * @param msg
	 */
	@CMD(id = CmdCode._31003)
	public void saveRoadFormation(PlayerContext playerContext, GReqSaveRoadFormation msg) {
		HeroLineUp heroLineUp = heroLineUpService.getLineUpByType(playerContext.getId(), LineUpType.CLAN_WAR);
		Asserts.isTrue(!heroLineUp.getFormationMap().isEmpty(), ErrorCode.WAR_HAS_NO_TEAM.getValue(), "你还没有布阵到公会战当中");
		
		BattlerDo battlerDo = battleHelper.queryPlayerBattler(LineUpType.CLAN_WAR, playerContext.getId(), Faction.ATTACKER);
        BattlerVo battlerVo = battlerDo.toBattlerVo();
        
        int fighting = heroLineUpService.getLineUpFighting(heroLineUp);
		
		ReqSaveRoadFormationMessageBuilder builder = ReqSaveRoadFormationMessage.builder();
		builder.rid(playerContext.getId());
		builder.road(msg.getRoad());
		builder.fighting(fighting);
		builder.battlerVoJson(GsonUtils.toJson(battlerVo));
		messageDispatcher.dispatch(builder.build());
	}
	
	@RemoteMethod
	public void saveRoadFormation(ResSaveRoadFormationMessage message) {
		contextManager.write(message.getRid(), CmdCode._31003, GResSaveRoadFormation.getDefaultInstance());
		
		Role role = roleService.getOrThrow(message.getRid());
		GResRoadInfoChange.Builder builder0 = GResRoadInfoChange.newBuilder();
		builder0.setRid(message.getRid());
		contextManager.writeSome(clanService.getMemberIds(role.getClanId()), CmdCode._31011, builder0.build());
	}
	
	/**
	 * 调整队伍出战分路与出战顺序
	 * @param playerContext
	 * @param msg
	 */
	@CMD(id = CmdCode._31004)
	public void adjustRoadSort(PlayerContext playerContext, GReqAdjustRoadSort msg) {
		Role role = roleService.getOrThrow(playerContext.getId());
		Asserts.isTrue(role.getClanId() > 0, ErrorCode.WAR_NOT_IN_CLAN.getValue(), "你还没有加入任何公会");
		ClanMember member = clanService.selectClanMemberOne(role.getClanId(), role.getId());
		Asserts.isTrue(member != null, ErrorCode.WAR_NOT_IN_CLAN.getValue(), "你还没有加入任何公会");
		
		ReqAdjustRoadSortMessageBuilder builder = ReqAdjustRoadSortMessage.builder();
		builder.rid(playerContext.getId());
		builder.road(msg.getRoad());
		builder.sort(msg.getSort());
		builder.targetRid(msg.getRid());
		builder.pos(member.getPosition());
		messageDispatcher.dispatch(builder.build());
	}
	
	@RemoteMethod
	public void adjustRoadSort(ResAdjustRoadSortMessage message) {
		GResAdjustRoadSort.Builder builder = GResAdjustRoadSort.newBuilder();
		builder.setRid(message.getTargetRid());
		builder.setRoad(message.getRoad());
		builder.setSort(message.getSort());
		contextManager.write(message.getRid(), CmdCode._31004, builder.build());
		
		Role role = roleService.getOrThrow(message.getRid());
		GResRoadInfoChange.Builder builder0 = GResRoadInfoChange.newBuilder();
		builder0.setRid(message.getRid());
		contextManager.writeSome(clanService.getMemberIds(role.getClanId()), CmdCode._31011, builder0.build());
	}
	
	/**
	 * 查看某一路的当前战况
	 * @param playerContext
	 * @param msg
	 */
	@CMD(id = CmdCode._31005)
	public void scanBattlingInfo(PlayerContext playerContext, GReqScanBattlingInfo msg) {
		ReqScanBattlingInfoMessageBuilder builder = ReqScanBattlingInfoMessage.builder();
		builder.rid(playerContext.getId());
		builder.road(msg.getRoad());
		messageDispatcher.dispatch(builder.build());
	}
	
	@RemoteMethod
	public void scanBattlingInfo(ResScanBattlingInfoMessage message) {
		GResScanBattlingInfo.Builder builder = GResScanBattlingInfo.newBuilder();
		if(message.getDetail() != null) {
			builder.setDetail(serializeBattleDetail(message.getDetail()));
		}
		if(message.getBattling() != null) {
			for(CSClanWarBattling battling : message.getBattling()) {
				builder.addBattling(serializeWarBattling(battling));
			}
		}
		contextManager.write(message.getRid(), CmdCode._31005, builder.build());
	}
	
	private PSHisBattleDetail serializeBattleDetail(CSHisBattleDetail battleDetail) {
		PSHisBattleDetail.Builder builder = PSHisBattleDetail.newBuilder();
		builder.setBattleId(battleDetail.getBattleId());
		if(battleDetail.getPlayers() != null) {
			for(CSHisBattlePlayer battlePlayer : battleDetail.getPlayers()) {
				PSHisBattlePlayer.Builder model = PSHisBattlePlayer.newBuilder();
				model.setRid(battlePlayer.getRid());
				model.setName(battlePlayer.getName());
				model.setClanId(battlePlayer.getClanId());
				model.setWin(battlePlayer.getWin());
				model.setFighting(battlePlayer.getFighting());
				if(battlePlayer.getHeros() != null) {
					for(ResHeroMessage hero : battlePlayer.getHeros()) {
						model.addHeros(serializeBrief(hero));
					}
				}
				builder.addPlayers(model.build());
			}
		}
		return builder.build();
	}
	
	private PSClanWarHeroBrief serializeBrief(ResHeroMessage hero) {
		PSClanWarHeroBrief.Builder builder = PSClanWarHeroBrief.newBuilder();
    	builder.setHeroId(hero.getHeroId());
        builder.setHeroType(hero.getHeroType());
        builder.setLevel(hero.getLevel());
        builder.setStar(hero.getStar());
        builder.setFashionId(hero.getFashionId());
        builder.setPos(hero.getPos());
        builder.setAlive(hero.getHp() <= 0 ? 1 : 0);
        builder.setEvolve(PbUtil.builderEvolve(hero.getEvolveType(),hero.getEvolveLevel()));
        return builder.build();
	}
	
	
	private PSClanWarBattling serializeWarBattling(CSClanWarBattling battling) {
		PSClanWarBattling.Builder builder = PSClanWarBattling.newBuilder();
		builder.setClanId(battling.getClanId());
		if(battling.getTeams() != null) {
			for(CSClanWarTeam team : battling.getTeams()) {
				builder.addTeams(serializeWarTeam(team));
			}
		}
		builder.setServerId(battling.getServerId());
		return builder.build();
	}
	
	
	/**
	 * 查看某一路的历史战况
	 * @param playerContext
	 * @param msg
	 */
	@CMD(id = CmdCode._31006)
	public void scanHisBattleInfo(PlayerContext playerContext, GReqScanHisBattlingInfo msg) {
		ReqScanHisBattlingInfoMessageBuilder builder = ReqScanHisBattlingInfoMessage.builder();
		builder.rid(playerContext.getId());
		builder.road(msg.getRoad());
		messageDispatcher.dispatch(builder.build());
	}
	
	@RemoteMethod
	public void scanHisBattleInfo(ResScanHisBattlingInfoMessage message) {
		GResScanHisBattlingInfo.Builder builder = GResScanHisBattlingInfo.newBuilder();
		if(message.getHisInfo() != null) {
			for(CSHisBattleDetail detail : message.getHisInfo()) {
				builder.addHisInfo(serializeBattleDetail(detail));
			}
		}
		contextManager.write(message.getRid(), CmdCode._31006, builder.build());
	}
	
	/**
	 * 查看公会战宝箱
	 * @param playerContext
	 * @param msg
	 */
	@CMD(id = CmdCode._31008)
	public void scanBox(PlayerContext playerContext, GReqScanWarBox msg) {
		Role role = roleService.getOrThrow(playerContext.getId());
		if(role.getClanId() == 0) {
			playerContext.writeError(ErrorCode.WAR_NOT_IN_CLAN);
			return;
		}
		ClanWarInfo mainInfo = clanWarInfoService.getClanWarInfo(role.getClanId());
		if(TimeDateUtil.getCurrentTimeInt() > mainInfo.getBoxEndTime()) {
			playerContext.writeError(ErrorCode.WAR_BOX_END);
			return;
		}
		
		GResScanWarBox.Builder builder = GResScanWarBox.newBuilder();
		builder.setBoxNumber(mainInfo.getBattleMembers().size());
		for(ClanWarBox entry : mainInfo.getBoxMember().values()) {
			builder.addBox(serializeWarBox(entry));
		}
		builder.setBoxType(mainInfo.getBoxType());
		builder.setHasBox(mainInfo.getBattleMembers().contains(role.getId()) ? 1 : 0);
		playerContext.write(CmdCode._31008, builder.build());
	}
	
	/**
	 * 打开公会战宝箱
	 * @param playerContext
	 * @param msg
	 */
	@CMD(id = CmdCode._31009)
	public void openBox(PlayerContext playerContext, GReqOpenWarBox msg) {
		Role role = roleService.getOrThrow(playerContext.getId());
		if(role.getClanId() == 0) {
			playerContext.writeError(ErrorCode.WAR_NOT_IN_CLAN);
			return;
		}
		ClanWarInfo mainInfo = clanWarInfoService.getClanWarInfo(role.getClanId());
		if(TimeDateUtil.getCurrentTimeInt() > mainInfo.getBoxEndTime()) {
			playerContext.writeError(ErrorCode.WAR_BOX_END);
			return;
		}
		if(msg.getBoxIndex() > mainInfo.getBattleMembers().size()) {
			playerContext.writeError(ErrorCode.WAR_BOX_NOT_EXIST);
			return;
		}
		if(!mainInfo.getBattleMembers().contains(playerContext.getId())) {
			playerContext.writeError(ErrorCode.WAR_NOT_BATTLE);
			return;
		}
		
		ClanWarBox rollBox = null;
		synchronized (mainInfo) {
			if(mainInfo.getBoxMember().containsKey(msg.getBoxIndex())) {
				playerContext.writeError(ErrorCode.WAR_BOX_EMPTY);
				return;
			}
			for(ClanWarBox box : mainInfo.getBoxMember().values()) {
				if(box.getRid() == playerContext.getId()) {
					playerContext.writeError(ErrorCode.WAR_BOX_TAKE);
					return;
				}
			}
			CClanWarReward cClanWarReward = clanWarRewardSysCache.randomBoxReward(mainInfo.getBoxType());
			
			rollBox = new ClanWarBox();
			rollBox.setRid(role.getId());
			rollBox.setName(role.getNick());
			rollBox.setNum(cClanWarReward.getReward().get(0).getItem_num());
			rollBox.setPos(msg.getBoxIndex());
			rollBox.setItem(cClanWarReward.getReward().get(0).getItem_type());
			mainInfo.getBoxMember().put(rollBox.getPos(), rollBox);
			clanWarInfoService.updateClanWarInfo(mainInfo);

            thingService.add(role.getId(), cClanWarReward.getReward(), GameEvent.WAR_BOX);
		}
		
		GResOpenWarBox.Builder builder = GResOpenWarBox.newBuilder();
		builder.setBoxNumber(mainInfo.getBattleMembers().size());
		builder.setBox(serializeWarBox(rollBox));
		playerContext.write(CmdCode._31009, builder.build());
		
		//给公会成员推送
		contextManager.writeSome(clanService.getMemberIds(role.getClanId()), CmdCode._31013, GResMemberOpenBox.getDefaultInstance());
	}
	
	private PSClanWarBox serializeWarBox(ClanWarBox box) {
		PSClanWarBox.Builder builder = PSClanWarBox.newBuilder();
		builder.setPosition(box.getPos());
		builder.setItemNum(box.getNum());
		builder.setItemType(box.getItem());
		builder.setName(box.getName());
		builder.setRid(box.getRid());
		return builder.build();
	}
	
	/**
	 * 查看某个公会成员的布路信息
	 * @param playerContext
	 * @param msg
	 */
	@CMD(id = CmdCode._31012)
	public void scanMemberRoadInfo(PlayerContext playerContext, GReqScanMemberRoadInfo msg) {
		ReqScanMemberRoadInfoMessageBuilder builder = ReqScanMemberRoadInfoMessage.builder();
		builder.rid(playerContext.getId());
		builder.targetRid(msg.getRid());
		messageDispatcher.dispatch(builder.build());
	}
	
	@RemoteMethod
	public void scanMemberRoadInfo(ResScanMemberRoadInfoMessage message) {
		Role role = roleService.getOrThrow(message.getRid());
		Clan clan = clanService.getOrThrow(role.getClanId());
		
		Role member = roleService.getOrThrow(message.getPlayerId());
		
		GResScanMemberRoadInfo.Builder builder = GResScanMemberRoadInfo.newBuilder();
		builder.setPlayerId(member.getId());
		builder.setNick(member.getNick());
		builder.setHeadId(member.getHeadId());
		builder.setBorderId(member.getBorderId());
		builder.setLevel(member.getLevel());
		builder.setServerId(member.getServerId());
		builder.setRank(member.getArenaScore());
		builder.setClanId(clan.getId());
		builder.setClanName(clan.getClanName());
		builder.setClanLevel(clan.getClanLevel());
		
		builder.setFighting(message.getFighting());
		if(message.getHeroData() != null) {
			for(ResHeroMessage hero : message.getHeroData()) {
				builder.addHeroData(heroService.serializeBrief(hero));
			}
		}
		contextManager.write(message.getRid(), CmdCode._31012, builder.build());
	}
	
	@RemoteMethod
	public void clanWarStageChange(ResClanWarStageMessage message) {
		clanWarService.updateStageInfo(message.getRoundEndTime(), message.getBattleClans());
	}
	
	@RemoteMethod
	public void clanWarResult(ResClanWarTellEndMessage message) {
		log.info("收到跨服通知的发奖信息");
		ClanWarInfo clanWarInfo = clanWarInfoService.getClanWarInfo(message.getClanId());
		if(message.getRound() <= clanWarInfo.getCrossRound()) {
			//已经发过奖，避免重复发奖
			//上报发奖状态
			ReqClanWarReportRewardMessageBuilder builder = ReqClanWarReportRewardMessage.builder();
			builder.clanId(message.getClanId());
			builder.round(message.getRound());
			messageDispatcher.dispatch(builder.build());
			return;
		}
		//发送公会战结束奖励
		// 开服三天之后才开发工会战，所以判断开启后才发奖励，但是其余状态还是正常维护
		if (clanWarService.isStartClanWar()) {
			List<Mail> mailList = new ArrayList<>();
			List<ClanMember> members = clanService.selectClanMember(message.getClanId());
			CClanWarAllReward allReward = clanWarAllRewardSysCache.getOrThrow(message.getIsWin());
			for (ClanMember member : members) {
				Mail mail = mailService.newSimpleMail(member.getRid(),
						message.getIsWin() == ClanWarResult.WIN.getValue() ? MailScene.CLAN_WAR_WIN
								: MailScene.CLAN_WAR_LOSE,
						allReward.getReward(), GameEvent.CLANWAR_JOIN);
				mailList.add(mail);
			}
			mailService.insertMails(mailList);
		}

		clanWarInfo.setCrossRound(message.getRound());
		clanWarInfo.getBoxMember().clear();
		clanWarInfo.setBoxType(message.getIsWin());
		clanWarInfo.setBoxEndTime(TimeDateUtil.getTomorrowZeroTimeInt());
		clanWarInfo.getBattleMembers().clear();
		if(message.getBattleMembers() != null) {
			clanWarInfo.getBattleMembers().addAll(message.getBattleMembers());
		}
		clanWarInfoService.updateClanWarInfo(clanWarInfo);
		
		if(message.getIsWin() == ClanWarResult.WIN.getValue()) {
			eventBus.post(ClanWarWinEvent.of(message.getClanId()));
		}
		
		//上报发奖状态
		ReqClanWarReportRewardMessageBuilder builder = ReqClanWarReportRewardMessage.builder();
		builder.clanId(message.getClanId());
		builder.round(message.getRound());
		messageDispatcher.dispatch(builder.build());
	}
	
	@RemoteMethod
	public void clanWarStageChange(ResClanWarTellStageMessage message) {
		clanWarService.updateStageInfo(message.getRoundEndTime(), message.getClanIds());
		if(message.getClanIds() != null) {
			eventBus.post(ClanWarStageEvent.of(message.getClanIds(), message.getStage()));
		}
	}
	
	@RemoteMethod
	public void clanWarBattleHappen(ResClanWarTellBattleHappenMessage message) {
		if(message.getClanIds() == null) {
			return;
		}
		List<Long> rids = new ArrayList<>();
		for(Long clanId : message.getClanIds()) {
			//通知客户端有战斗发生
			List<ClanMember> members = clanService.selectClanMember(clanId);
			for(ClanMember member : members) {
				rids.add(member.getRid());
			}
		}
		contextManager.writeSome(rids, CmdCode._31010, GResWarBattleNext.getDefaultInstance());
	}
	
	@RemoteMethod
	public void clanWarSaveBattle(ResClanWarSaveBattleMessage message) {
		if(message.getBattleReports() == null) {
			return;
		}
		for(byte[] battleMsg : message.getBattleReports()) {
			try {
				BattleReport report = BattleReport.parseFrom(battleMsg);
				//保存战报
		        commandBus.invoke(SaveBattleReportCommand.of(report));
			} catch (InvalidProtocolBufferException e) {
				e.printStackTrace();
			}
		}
	}
}
