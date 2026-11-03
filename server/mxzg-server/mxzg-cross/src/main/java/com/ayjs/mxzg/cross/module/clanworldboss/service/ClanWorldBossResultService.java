/**
 * 
 */
package com.ayjs.mxzg.cross.module.clanworldboss.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.common.lifecycle.Lifecycle;
import com.ayjs.mxzg.common.lifecycle.LifecycleInfo;
import com.ayjs.mxzg.cross.module.MessageHelper;
import com.ayjs.mxzg.cross.module.clanworldboss.dao.ClanWorldBossResultDao;
import com.ayjs.mxzg.cross.module.clanworldboss.domain.ClanWorldBossResult;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.CSClanMemberRank;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.CSClanMemberRank.CSClanMemberRankBuilder;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.CSClanRank;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.CSClanRank.CSClanRankBuilder;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ResTellEndMessage;
import com.ayjs.mxzg.message.module.clanworldboss.ClanWorldBossMessage.ResTellEndMessage.ResTellEndMessageBuilder;

/**
 * @author YY
 *
 */
@Service
public class ClanWorldBossResultService implements Lifecycle {

	@Autowired
	private ClanWorldBossResultDao clanWorldBossResultDao;
	@Autowired
	private MessageHelper messageHelper;
	
	private Map<Integer, Map<Integer, List<ClanWorldBossResult>>> resultMap = new ConcurrentHashMap<>();
	
	public void insertResult(List<ClanWorldBossResult> resultList) {
		clanWorldBossResultDao.add(resultList);
		addResultToCache(resultList);
	}
	
	public CSClanRank serialize(ClanWorldBossResult result) {
		CSClanRankBuilder builder = CSClanRank.builder();
		builder.clanId(result.getClanId());
		builder.point(result.getPoint());
		builder.rank(result.getRank());
		builder.bossId(result.getBossId());
		List<CSClanMemberRank> memberList = new ArrayList<>();
		for(Entry<Long, Integer> member : result.getJoinMembers().entrySet()) {
			CSClanMemberRankBuilder model = CSClanMemberRank.builder();
			model.rid(member.getKey());
			model.rank(member.getValue());
			memberList.add(model.build());
		}
		builder.joinMembers(memberList);
		return builder.build();
	}
	
	public void updateResult(int round, int serverId) {
		Map<Integer, List<ClanWorldBossResult>> map = resultMap.get(round);
		if(map == null) {
			return;
		}
		List<ClanWorldBossResult> resultList = map.get(serverId);
		if(resultList == null || resultList.isEmpty()) {
			return;
		}
		for(ClanWorldBossResult result : resultList) {
			result.setStatus(1);
		}
		clanWorldBossResultDao.update(resultList);
		map.remove(serverId);
	}

	@Override
	public LifecycleInfo getInfo() {
		return LifecycleInfo.valueOf("ClanWorldBossResultService");
	}

	@Override
	public void start() throws Exception {
		//查询出哪些还没有发奖的
		List<ClanWorldBossResult> resultList = clanWorldBossResultDao.list("status", 0);
		addResultToCache(resultList);
	}
	
	private void addResultToCache(List<ClanWorldBossResult> resultList) {
		for(ClanWorldBossResult result : resultList) {
			Map<Integer, List<ClanWorldBossResult>> map = resultMap.get(result.getRound());
			if(map == null) {
				map = new ConcurrentHashMap<>();
				resultMap.put(result.getRound(), map);
			}
			List<ClanWorldBossResult> list = map.get(result.getServerId());
			if(list == null) {
				list = new ArrayList<>();
				map.put(result.getServerId(), list);
			}
			list.add(result);
		}
	}
	
	public void runForResult() {
		//推送补发奖励
		for(Entry<Integer, Map<Integer, List<ClanWorldBossResult>>> roundMap : resultMap.entrySet()) {
			int round = roundMap.getKey();
			for(Entry<Integer, List<ClanWorldBossResult>> entry : roundMap.getValue().entrySet()) {
				int serverId = entry.getKey();
				List<CSClanRank> clanList = new ArrayList<>();
				for(ClanWorldBossResult result : entry.getValue()) {
					clanList.add(serialize(result));
				}
				ResTellEndMessageBuilder builder = ResTellEndMessage.builder();
				builder.round(round);
				builder.serverId(serverId);
				builder.clans(clanList);
				messageHelper.pushToMessage(builder.build());
			}
		}
	}
}
