/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.rainbow.handler;

import com.ayjs.mxzg.battle.model.BattleResult;
import com.ayjs.mxzg.battle.model.BattleType;
import com.ayjs.mxzg.common.command.serivce.CommandBus;
import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.handler.CMD;
import com.ayjs.mxzg.common.handler.ProtocolHandler;
import com.ayjs.mxzg.common.util.Asserts;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.cache.LanguageSysCache;
import com.ayjs.mxzg.config.excel.cache.RainbowMissionSysCache;
import com.ayjs.mxzg.config.excel.cache.RainbowSysCache;
import com.ayjs.mxzg.config.excel.constant.RainbowConst;
import com.ayjs.mxzg.config.excel.constant.VideoConst;
import com.ayjs.mxzg.config.excel.entity.CLanguage;
import com.ayjs.mxzg.config.excel.entity.CRainbow;
import com.ayjs.mxzg.config.excel.entity.CRainbowMission;
import com.ayjs.mxzg.config.struct.LineUpType;
import com.ayjs.mxzg.gameserver.infrastructure.netty.PlayerContext;
import com.ayjs.mxzg.gameserver.infrastructure.protocol.CmdCode;
import com.ayjs.mxzg.gameserver.module.battle.BattleHelper;
import com.ayjs.mxzg.gameserver.module.hero.domain.HeroLineUp;
import com.ayjs.mxzg.gameserver.module.hero.service.HeroLineUpService;
import com.ayjs.mxzg.gameserver.module.pvp.domain.PvpInfo;
import com.ayjs.mxzg.gameserver.module.pvp.service.PvpInfoService;
import com.ayjs.mxzg.gameserver.module.rainbow.domain.RainbowRecord;
import com.ayjs.mxzg.gameserver.module.rainbow.domain.RainbowSlot;
import com.ayjs.mxzg.gameserver.module.rainbow.event.RainbowChallengeEvent;
import com.ayjs.mxzg.gameserver.module.rainbow.service.RainbowService;
import com.ayjs.mxzg.gameserver.module.rank.service.impl.ArenaRankService;
import com.ayjs.mxzg.gameserver.module.role.domain.Role;
import com.ayjs.mxzg.gameserver.module.role.service.RoleService;
import com.ayjs.mxzg.module.battle.command.SaveBattleReportCommand;
import com.ayjs.mxzg.protocol.BattleGMsg.BattleLog;
import com.ayjs.mxzg.protocol.RainbowGMsg.GReqRainbowChallenge;
import com.ayjs.mxzg.protocol.RainbowGMsg.GReqRainbowInfo;
import com.ayjs.mxzg.protocol.RainbowGMsg.GReqRainbowRecord;
import com.ayjs.mxzg.protocol.RainbowGMsg.GResRainbowChallenge;
import com.ayjs.mxzg.protocol.RainbowGMsg.GResRainbowInfo;
import com.ayjs.mxzg.protocol.RainbowGMsg.GResRainbowRecord;
import com.ayjs.mxzg.protocol.RainbowGMsg.PSRainbowNpc;
import com.ayjs.mxzg.protocol.RainbowGMsg.PSRainbowRecord;
import com.ayjs.mxzg.protocol.RainbowGMsg.PSRainbowSlot;
import com.ayjs.mxzg.template.constant.ErrorCode;
import com.ayjs.mxzg.template.language.LanguageHelper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import java.io.UnsupportedEncodingException;
import java.util.List;

/**
 * @author YY
 *
 */
@Slf4j
@Controller
public class RainbowHandler extends ProtocolHandler {
	
	@Autowired
	private RainbowService rainbowService;
	@Autowired
	private ArenaRankService arenaRankService;
	@Autowired
	private RoleService roleService;
	@Autowired
	private RainbowMissionSysCache rainbowMissionSysCache;
	@Autowired
	private RainbowSysCache rainbowSysCache;
	@Autowired
	private HeroLineUpService heroLineUpService;
	@Autowired
	private BattleHelper battleHelper;
	@Autowired
	private CommandBus commandBus;
	@Autowired
	private EventBus eventBus;
	@Autowired
	private PvpInfoService pvpInfoService;
	@Autowired
	private LanguageSysCache languageSysCache;
	@Autowired
	private LanguageHelper languageHelper;
	
	
	@CMD(id = CmdCode._57001)
	public void scanRainbow(PlayerContext playerContext, GReqRainbowInfo msg) {
		List<RainbowSlot> slotList = rainbowService.getAllSlot();
		
		PvpInfo pvpInfo = pvpInfoService.getPvpInfo(playerContext.getId());
		
		GResRainbowInfo.Builder builder = GResRainbowInfo.newBuilder();
		for(RainbowSlot slot : slotList) {
			builder.addSlots(serializeSlot(slot));
		}
		int rank = arenaRankService.getRank(playerContext.getId());
		builder.setRank(rank);
		builder.setRainbowCd(pvpInfo.getRainbowTime());
		playerContext.write(CmdCode._57001, builder.build());
	}
	
	private PSRainbowSlot serializeSlot(RainbowSlot slot) {
		PSRainbowSlot.Builder builder = PSRainbowSlot.newBuilder();
		builder.setId(slot.getId());
		builder.setEvolution(slot.getLevel());
		builder.setType(slot.getType());
		builder.setPos(slot.getPos());
		if(slot.getRid() != 0 && slot.getEndTime() > TimeDateUtil.getCurrentTimeInt()) {
			Role role = roleService.getOrThrow(slot.getRid());
			builder.setRid(role.getId());
			builder.setName(role.getNick());
			builder.setImageId(role.getImageId());
			builder.setLevel(role.getLevel());
			builder.setHeadId(role.getHeadId());
			builder.setBorderId(role.getBorderId());
		}
		List<CRainbowMission> missionList = rainbowMissionSysCache.getMission(slot.getType(), slot.getLevel());
		for(CRainbowMission mission : missionList) {
			PSRainbowNpc.Builder model = PSRainbowNpc.newBuilder();
			model.setType(mission.getHero_type());
			model.setStar(mission.getHero_star());
			model.setSkillShow(mission.getSkill_show());
			model.setPassiveSkillShow(mission.getPassive_skill_show());
			builder.addNpcList(model.build());
			break;
		}
		return builder.build();
	}
	
	@CMD(id = CmdCode._57002)
	public void challenge(PlayerContext playerContext, GReqRainbowChallenge msg) {
		Asserts.isTrue(msg.getEvolution() == 1 || msg.getEvolution() == 5 || msg.getEvolution() == 10,
				ErrorCode.ERROR_PARAM.getValue(), "参数错误：" + msg.getEvolution());
		
		Role role = roleService.getOrThrow(playerContext.getId());
		Asserts.isTrue(role.getLevel() >= RainbowConst.CHALLENGE_LEVEL, ErrorCode.RAINBOW_LV_LOW.getValue(), "你已经占据了该彩虹圣殿位置");
		
		RainbowSlot rainbowSlot = rainbowService.getRainbowSlot(msg.getId());
		
		int nowTime = TimeDateUtil.getCurrentTimeInt();
		Asserts.isTrue(rainbowSlot.getRid() != playerContext.getId() || rainbowSlot.getEndTime() < nowTime,
				ErrorCode.RAINBOW_HOLDING.getValue(), "你已经占据了该彩虹圣殿位置");
		
		PvpInfo pvpInfo = pvpInfoService.getPvpInfo(playerContext.getId());
		Asserts.isTrue(nowTime > pvpInfo.getRainbowTime(), ErrorCode.RAINBOW_CD.getValue(), "彩虹圣殿的挑战时间还在冷却中");
		
		CRainbow rainbow = rainbowSysCache.getOrThrow(rainbowSlot.getType());
		
		int rank = arenaRankService.getRank(playerContext.getId());
		Asserts.isTrue(rank > 0 && rank <= rainbow.getNeed_rank(), ErrorCode.RAINBOW_RANK_LOW.getValue(),
				"竞技场排名未达到挑战要求" + rank);

		HeroLineUp heroLineUp = heroLineUpService.getLineUpByType(playerContext.getId(), LineUpType.RAINBOW);
		Asserts.isTrue(!heroLineUp.getFormationMap().isEmpty(), ErrorCode.RAINBOW_FORMATION_EMPTY.getValue(),
				"彩虹圣殿的挑战阵容不能为空");
		
		//原先占领的神位
		RainbowSlot oriSlot = null;
		for(RainbowSlot slot : rainbowService.getAllSlot()) {
			if(slot.getId() != rainbowSlot.getId() && slot.getRid() == playerContext.getId()) {
				oriSlot = slot;
				break;
			}
		}
		BattleResult battleResult = null;
		if(oriSlot == null) {
			synchronized (rainbowSlot) {
				battleResult = rainbowBattle(playerContext.getId(), rainbowSlot, msg.getEvolution(), null, pvpInfo);
			}
		} else {
			RainbowSlot smallSlot = null;
			RainbowSlot bigSlot = null;
			if(rainbowSlot.getId() < oriSlot.getId()) {
				smallSlot = rainbowSlot;
				bigSlot = oriSlot;
			} else {
				smallSlot = oriSlot;
				bigSlot = rainbowSlot;
			}
			synchronized (smallSlot) {
				synchronized (bigSlot) {
					battleResult = rainbowBattle(playerContext.getId(), rainbowSlot, msg.getEvolution(), oriSlot, pvpInfo);
				}
			}
		}
		
		List<RainbowSlot> slotList = rainbowService.getAllSlot();
		GResRainbowChallenge.Builder builder = GResRainbowChallenge.newBuilder();
		builder.setReport(battleResult.getReport());
		for(RainbowSlot slot : slotList) {
			builder.addSlots(serializeSlot(slot));
		}
		if(rainbowSlot.getRid() ==  playerContext.getId()) {
			builder.setMyType(rainbowSlot.getType());
		}
		builder.setRainbowCd(pvpInfo.getRainbowTime());
		playerContext.write(CmdCode._57002, builder.build());
	}
	
	private BattleResult rainbowBattle(long rid, RainbowSlot rainbowSlot, int evolution, RainbowSlot oriSlot, PvpInfo pvpInfo) {
		//挑战的等级=当前等级+玩家选择进化的等级
		int level = rainbowSlot.getLevel() + evolution;
		
		List<CRainbowMission> missionList = rainbowMissionSysCache.getMission(rainbowSlot.getType(), level);
		
		CRainbow cRainbow = rainbowSysCache.getOrThrow(rainbowSlot.getType());
		CLanguage cLanguage = languageSysCache.getByKey(cRainbow.getName_lang());
		
		String npcName = languageHelper.getLanguageBy(cLanguage) + level;
		
		BattleResult battleResult = battleHelper.invokePVEBattle(BattleType.RAINBOW, rid, missionList, npcName);
		
		int nowTime = TimeDateUtil.getCurrentTimeInt();
		
		long oldRid = 0;
		if(rainbowSlot.getRid() > 0 && rainbowSlot.getEndTime() > nowTime) {
			oldRid = rainbowSlot.getRid();
		}
		
		boolean isWin = battleResult.isWin();
		if(isWin) {
			String battleLog = "";
			try {
				battleLog = new String(battleResult.getReport().getLog().toByteArray(), VideoConst.ISO);
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
			RainbowRecord record = new RainbowRecord();
			record.setBattleId(battleResult.getReport().getBattleId());
			record.setSlotId(rainbowSlot.getId());
			record.setTime(nowTime);
			record.setEvolution(evolution);
			record.setBattleLog(battleLog);
			rainbowService.addRecord(record);
			
            rainbowSlot.setLevel(missionList.get(0).getLevel());
            rainbowSlot.setRid(rid);
            rainbowSlot.setEndTime(nowTime + cRainbow.getTime());
            rainbowService.updateSlot(rainbowSlot);
            
            if(oriSlot != null) {
            	//撤销回来占据的神位
            	oriSlot.setRid(0);
            	oriSlot.setEndTime(0);
            	rainbowService.updateSlot(oriSlot);
            }
            
            //保存战报
            commandBus.invoke(SaveBattleReportCommand.of(battleResult.getReport()));
            //挑战事件
            eventBus.post(RainbowChallengeEvent.of(rid, rainbowSlot, oriSlot, oldRid));
		} else {
			pvpInfo.setRainbowTime(nowTime + RainbowConst.CHALLENGE_CD);
			pvpInfoService.updatePvpInfo(pvpInfo);
		}
		return battleResult;
	}
	
	@CMD(id = CmdCode._57003)
	public void scanRecord(PlayerContext playerContext, GReqRainbowRecord msg) {
		//验证数据ID是否合法，避免查空数据
		rainbowService.getRainbowSlot(msg.getId());
		
		GResRainbowRecord.Builder builder = GResRainbowRecord.newBuilder();
		List<RainbowRecord> recordList = rainbowService.getRainbowRecord(msg.getId());
		for(RainbowRecord record : recordList) {
			builder.addRecords(serializeRecord(record));
		}
		playerContext.write(CmdCode._57003, builder.build());
	}
	
	
	private PSRainbowRecord serializeRecord(RainbowRecord record) {
		PSRainbowRecord.Builder builder = PSRainbowRecord.newBuilder();
		builder.setTime(record.getTime());
		builder.setEvolution(record.getEvolution());
		builder.setBattleId(record.getBattleId());
		if(record.getBattleLog() != null) {
			try {
				builder.setBattleLog(BattleLog.parseFrom(record.getBattleLog().getBytes(VideoConst.ISO)));
			} catch (Exception e) {
				log.error("彩虹圣殿战斗" + record.getBattleId() + "无法转化战报");
			}
		}
		return builder.build();
	}
}
