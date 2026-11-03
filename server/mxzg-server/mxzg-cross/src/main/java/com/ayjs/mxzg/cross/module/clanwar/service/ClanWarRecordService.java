/**
 * 
 */
package com.ayjs.mxzg.cross.module.clanwar.service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.battle.command.BattleCommand;
import com.ayjs.mxzg.battle.model.BattleResult;
import com.ayjs.mxzg.battle.model.BattleType;
import com.ayjs.mxzg.battle.model.BattlerDo;
import com.ayjs.mxzg.battle.model.Faction;
import com.ayjs.mxzg.battle.model.UnitType;
import com.ayjs.mxzg.battle.model.mirror.BattlerVo;
import com.ayjs.mxzg.battle.model.mirror.HeroVo;
import com.ayjs.mxzg.common.command.serivce.CommandBus;
import com.ayjs.mxzg.common.util.RandomUtil;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.cross.module.clanwar.dao.ClanWarRecordDao;
import com.ayjs.mxzg.cross.module.clanwar.domain.ClanWarRecord;
import com.ayjs.mxzg.cross.module.clanwar.domain.ClanWarStageControl;
import com.ayjs.mxzg.cross.module.clanwar.domain.ClanWarTeam;
import com.ayjs.mxzg.cross.module.crossrole.service.CrossRoleService;
import com.ayjs.mxzg.cross.module.hero.service.HeroService;
import com.ayjs.mxzg.message.module.clanwar.ClanWarMessage.CSHisBattleDetail;
import com.ayjs.mxzg.message.module.clanwar.ClanWarMessage.CSHisBattleDetail.CSHisBattleDetailBuilder;
import com.ayjs.mxzg.message.module.clanwar.ClanWarMessage.CSHisBattlePlayer;
import com.ayjs.mxzg.message.module.clanwar.ClanWarMessage.CSHisBattlePlayer.CSHisBattlePlayerBuilder;
import com.ayjs.mxzg.message.module.hero.message.HeroMessage.ResHeroMessage;
import com.ayjs.mxzg.message.module.role.domain.CrossRole;
import com.ayjs.mxzg.module.battle.BattleTemplate;

import lombok.extern.slf4j.Slf4j;

/**
 * @author YY
 *
 */
@Slf4j
@Service
public class ClanWarRecordService {

	@Autowired
	private ClanWarRecordDao clanWarRecordDao;
	@Autowired
	private BattleTemplate battleTemplate;
	@Autowired
	private CommandBus commandBus;
	@Autowired
	private CrossRoleService crossRoleService;
	@Autowired
	private HeroService heroService;
	
	
	public List<ClanWarRecord> getByRound(int round) {
		return clanWarRecordDao.list("round", round);
	}
	
	public void insert(List<ClanWarRecord> records) {
		clanWarRecordDao.add(records);
	}
	
	/**
	 * 公会战战斗
	 * @param stageControl
	 * @param atkTeam
	 * @param defTeam
	 * @return
	 */
	public ClanWarRecord fightForClanWar(ClanWarStageControl stageControl, ClanWarTeam atkTeam, ClanWarTeam defTeam) {
		
		ClanWarRecord clanWarRecord = new ClanWarRecord();
		
		log.info("玩家{}与玩家{}进行对战", atkTeam.getRid(), defTeam.getRid());
		
		CrossRole atkRole = crossRoleService.getOrThrow(atkTeam.getRid());
		CrossRole defRole = crossRoleService.getOrThrow(defTeam.getRid());
		
        BattlerDo attacker = battleTemplate.queryBattler(atkTeam.getBattlerVo(), atkRole.getNick(), Faction.ATTACKER, UnitType.HERO);
		BattlerDo defender = battleTemplate.queryBattler(defTeam.getBattlerVo(), defRole.getNick(), Faction.DEFENDER, UnitType.HERO);
        //进行对战
		BattleCommand battleCommand = BattleCommand.createOf(BattleType.CLAN_WAR, attacker, defender);
        
        clanWarRecord.setRound(stageControl.getRound());
        clanWarRecord.setRoad(atkTeam.getRoad());
        clanWarRecord.setAtkClanId(atkRole.getClanId());
        clanWarRecord.setDefClanId(defRole.getClanId());
        clanWarRecord.setAtkRid(atkRole.getId());
        clanWarRecord.setDefRid(defRole.getId());
        clanWarRecord.setAtkVo(atkTeam.getBattlerVo());
        clanWarRecord.setDefVo(defTeam.getBattlerVo());
        clanWarRecord.setTime(TimeDateUtil.getCurrentTimeInt());
        clanWarRecord.setAtkFight(atkTeam.getFighting());
        clanWarRecord.setDefFight(defTeam.getFighting());
        
        String battleId = null;
        boolean isWin = false;
        try {
        	commandBus.invoke(battleCommand);
        	BattleResult battleResult = battleCommand.getResult();
        	isWin = battleResult.isWin();
        	
        	//保存双方的血量信息
        	atkTeam.setBattlerVo(battleResult.buildAttackerVo());
        	defTeam.setBattlerVo(battleResult.buildDefenderVo());
        	
			battleId = battleResult.getReport().getBattleId();
			clanWarRecord.setBattleReport(battleResult.getReport());
			//保存战报
//TODO	        commandBus.invoke(SaveBattleReportCommand.of(battleResult.getReport()));
		} catch (Exception e) {
			log.error("战斗出现异常");
			isWin = RandomUtil.getRandomInt(1, 2) == 1;
			battleId = "CLANWAR_1_1_2";
		}
        
        if(isWin) {
			clanWarRecord.setWhichWin(1);
			//防守方死亡
			defTeam.setAlive(0);
		} else {
			clanWarRecord.setWhichWin(2);
			//进攻方死亡
			atkTeam.setAlive(0);
		}
        clanWarRecord.setBattleId(battleId);
        return clanWarRecord;
	}
	
	public CSHisBattleDetail buildWarRecord(ClanWarRecord record) {
		CSHisBattleDetailBuilder builder = CSHisBattleDetail.builder();
		builder.battleId(record.getBattleId());
		List<CSHisBattlePlayer> players = new ArrayList<>();
		players.add(serializeBattlePlayer(record.getAtkRid(), record.getWhichWin() == 1, record.getAtkVo(),
				record.getAtkFight()));
		players.add(serializeBattlePlayer(record.getDefRid(), record.getWhichWin() == 2, record.getDefVo(),
				record.getDefFight()));
		builder.players(players);
		return builder.build();
	}
	
	
	private CSHisBattlePlayer serializeBattlePlayer(long rid, boolean isWin, BattlerVo battlerVo, int fighting) {
		CSHisBattlePlayerBuilder builder = CSHisBattlePlayer.builder();
		CrossRole role = crossRoleService.getOrThrow(rid);
		
		builder.rid(role.getId());
		builder.clanId(role.getClanId());
		builder.win(isWin ? 1 : 0);
		builder.name(role.getNick());
		//对站位进行排序
		Collections.sort(battlerVo.getHeros(), Comparator.comparingInt(HeroVo::getPos));
		
		List<ResHeroMessage> heroList = new ArrayList<>();
		for(HeroVo heroVo : battlerVo.getHeros()) {
			heroList.add(heroService.serialize(heroVo));
		}
		builder.heros(heroList);
		builder.fighting(fighting);
		return builder.build();
	}
}
