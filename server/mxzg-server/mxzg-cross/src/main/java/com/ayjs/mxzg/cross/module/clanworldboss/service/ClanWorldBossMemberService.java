/**
 * 
 */
package com.ayjs.mxzg.cross.module.clanworldboss.service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.cross.module.clan.event.ClanChangeEvent;
import com.ayjs.mxzg.cross.module.clanworldboss.dao.ClanWorldBossMemberDao;
import com.ayjs.mxzg.cross.module.clanworldboss.domain.ClanWorldBossMember;
import com.ayjs.mxzg.cross.module.clanworldboss.domain.ClanWorldBossStageControl;
import com.ayjs.mxzg.cross.module.crossrole.service.CrossRoleService;
import com.ayjs.mxzg.message.module.role.domain.CrossRole;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

/**
 * @author YY
 *
 */
@Observer
@Service
public class ClanWorldBossMemberService {

	@Autowired
	private ClanWorldBossMemberDao clanWorldBossMemberDao;
	@Autowired
	private ClanWorldBossService clanWorldBossService;
	@Autowired
	private ClanWorldBossRoleRankService clanWorldBossRoleRankService;
	@Autowired
	private CrossRoleService crossRoleService;
	
	public ClanWorldBossMember getBossMember(long rid) {
		ClanWorldBossMember member = clanWorldBossMemberDao.get(rid);
		if(member == null) {
			CrossRole role = crossRoleService.getOrThrow(rid);
			member = new ClanWorldBossMember();
			member.setRid(rid);
			member.setRobingRoles(new ArrayList<>());
			member.setClanId(role.getClanId());
			member.setServerId(role.getServerId());
			member.setRecords(new ArrayList<>());
			clanWorldBossMemberDao.add(member);
		}
		boolean needUpdate = false;
		if(member.getRecords() == null) {
			member.setRecords(new ArrayList<>());
			needUpdate = true;
		}
		if(member.getRobingRoles() == null) {
			member.setRobingRoles(new ArrayList<>());
			needUpdate = true;
		}
		
		ClanWorldBossStageControl stageControl = clanWorldBossService.getClanWorldBossStage();
		if(stageControl != null) {
			if(member.getRound() != stageControl.getRound()) {
				member.setRound(stageControl.getRound());
				member.setChallengeCount(0);
				member.setChallengeCd(0);
				member.setRobCount(0);
				member.setRobCd(0);
				member.setDamage(0);
				member.setPoint(0);
				member.getRobingRoles().clear();
				member.getRecords().clear();
				needUpdate = true;
			}
		}
		if(needUpdate) {
			clanWorldBossMemberDao.update(member);
		}
		return member;
	}
	
	public void update(ClanWorldBossMember member) {
		clanWorldBossMemberDao.update(member);
	}
	
	/**
	 * 获取某一轮活动的参数玩家数据
	 * @param round
	 * @return
	 */
	public List<ClanWorldBossMember> getByRound(int round) {
		return clanWorldBossMemberDao.getByRound(round);
	}
	
	
	@Subscribe
	private void listen(ClanChangeEvent event) {
		CrossRole role = crossRoleService.getOrThrow(event.getRid());
		if(role == null) {
			return;
		}
		ClanWorldBossMember member = getBossMember(event.getRid());
		if(event.getNewClanId() > 0) {
			//加入新公会
			member.setClanId(event.getNewClanId());
			update(member);
		} else {
			CrossRole crossRole = crossRoleService.getOrThrow(event.getRid());
			//离开原公会
			member.setClanId(0);
			member.setPoint(0);
			member.setDamage(0);
			member.getRobingRoles().clear();
			update(member);
			clanWorldBossRoleRankService.removeRank(event.getRid(), event.getOldClanId(), crossRole.getServerId());
		}
	}
}
