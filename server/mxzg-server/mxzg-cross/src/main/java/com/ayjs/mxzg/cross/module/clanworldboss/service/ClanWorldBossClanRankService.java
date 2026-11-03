/**
 * 
 */
package com.ayjs.mxzg.cross.module.clanworldboss.service;

import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.event.annotation.Subscribe.AsyncType;
import com.ayjs.mxzg.common.util.ListMapUtil;
import com.ayjs.mxzg.cross.module.clanworldboss.domain.ClanWorldBossMember;
import com.ayjs.mxzg.cross.module.clanworldboss.domain.ClanWorldBossStageControl;
import com.ayjs.mxzg.cross.module.clanworldboss.event.ClanWorldBossClanPointEvent;
import com.ayjs.mxzg.cross.module.rank.service.AbstractCrossRankService;
import com.ayjs.mxzg.message.center.dto.CrossGroup;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.CSClanWorldBossClanRank;
import com.ayjs.mxzg.message.module.floatingIslands.struct.RankData;
import com.ayjs.mxzg.message.module.rank.dto.CrossRankType;
import com.ayjs.rpc.server.Connection;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

/**
 * @author YY
 *
 */
@Observer
@Service
public class ClanWorldBossClanRankService extends AbstractCrossRankService<CSClanWorldBossClanRank> {

	@Autowired
	private ClanWorldBossService clanWorldBossService;
	@Autowired
	private ClanWorldBossMemberService clanWorldBossMemberService;
	
	@Override
	public CrossRankType getRankType() {
		return CrossRankType.CLAN_WORLD_BOSS_CLAN;
	}

	@Subscribe(async = AsyncType.Async)
	private void rank(ClanWorldBossClanPointEvent event) {
		RankData newRank = new RankData();
		newRank.setRankId(event.getClanId());
		newRank.setRankTime(event.getTime());
		newRank.setRankValue(clanWorldBossService.getClanPoint(event.getClanId()));

		CrossGroup group = crossServerGroupService.getCrossGroup(event.getServerId());
		if (group != null) {
            addRank(newRank, group.getGroupId());
        }
	}

	@Override
	protected Map<Integer, List<RankData>> startLoadRank() {
		ClanWorldBossStageControl stageControl = clanWorldBossService.getClanWorldBossStage();

		List<ClanWorldBossMember> memberList = clanWorldBossMemberService.getByRound(stageControl.getRound());
		Map<Integer, List<ClanWorldBossMember>> memberMap = ListMapUtil.fillListMap(memberList, ClanWorldBossMember::getServerId);
		
		Map<Integer, Map<Long, RankData>> groupClanMap = new HashMap<>();
		
		for(Entry<Integer, List<ClanWorldBossMember>> entry : memberMap.entrySet()) {
			int serverId = entry.getKey();
			if(serverId <= 0) {
				continue;
			}
			CrossGroup group = crossServerGroupService.getCrossGroup(serverId);
			if(group == null) {
				continue;
			}
			
			Map<Long, RankData> clanMap = groupClanMap.get(group.getGroupId());
			if(clanMap == null) {
				clanMap = new HashMap<>();
				groupClanMap.put(group.getGroupId(), clanMap);
			}
			
			for(ClanWorldBossMember member : entry.getValue()) {
				if(member.getClanId() <= 0 || member.getRound() != stageControl.getRound() || member.getPoint() <= 0) {
					continue;
				}
				RankData rank = clanMap.get(member.getClanId());
				if(rank == null) {
					rank = new RankData();
					rank.setRankId(member.getClanId());
					clanMap.put(rank.getRankId(), rank);
				}
				rank.setRankValue(rank.getRankValue() + member.getPoint());
				if(member.getPointTime() > rank.getRankTime()) {
					rank.setRankTime(member.getPointTime());
				}
			}
		}
		
		Map<Integer, List<RankData>> groupRankMap = new HashMap<>();
		for(Entry<Integer, Map<Long, RankData>> entry : groupClanMap.entrySet()) {
			groupRankMap.put(entry.getKey(), new ArrayList<>(entry.getValue().values()));
		}
		return groupRankMap;
	}

	@Override
	public List<CSClanWorldBossClanRank> getAll(int serverGroup) {
		return Collections.emptyList();
	}

	@Override
	public void pullToAllGame() {

	}

	@Override
	public void pullToGame(int serverId, Connection connection) {

	}
}
