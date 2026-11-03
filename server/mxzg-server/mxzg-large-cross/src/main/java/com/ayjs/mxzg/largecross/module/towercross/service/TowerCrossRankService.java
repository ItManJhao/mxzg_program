/**
 * 
 */
package com.ayjs.mxzg.largecross.module.towercross.service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.common.event.annotation.Subscribe.AsyncType;
import com.ayjs.mxzg.largecross.module.rank.service.AbstractCrossRankService;
import com.ayjs.mxzg.largecross.module.towercross.domain.TowerCrossRole;
import com.ayjs.mxzg.largecross.module.towercross.event.TimeTowerRankEvent;
import com.ayjs.mxzg.largecross.servergroup.domain.CrossServerGroup;
import com.ayjs.mxzg.largecross.servergroup.service.ServerGroupService;
import com.ayjs.mxzg.message.center.dto.CrossGroup;
import com.ayjs.mxzg.message.module.floatingIslands.struct.RankData;
import com.ayjs.mxzg.message.module.rank.dto.CrossRankType;
import com.ayjs.mxzg.message.module.role.dao.CrossRoleRedisDao;
import com.ayjs.mxzg.message.module.role.domain.CrossRole;
import com.ayjs.mxzg.message.module.timetower.TimeTowerMessage.CSTimeTowerRank;
import com.ayjs.rpc.server.Connection;

import lombok.extern.slf4j.Slf4j;

/**
 * @author YY
 *
 */
@Slf4j
@Service
public class TowerCrossRankService extends AbstractCrossRankService<CSTimeTowerRank> {

	@Autowired
	private TowerCrossRoleService towerCrossRoleService;
	@Autowired
	private ServerGroupService serverGroupService;
	//FIXME
	@Autowired
	private CrossRoleRedisDao crossRoleRedisDao;
	
	
	@Override
	public List<CSTimeTowerRank> getAll(int serverGroup) {
		return Collections.emptyList();
	}

	@Override
	public void pullToAllGame() {
	}

	@Override
	public void pullToGame(int serverId, Connection connection) {
	}

	@Override
	public CrossRankType getRankType() {
		return CrossRankType.TIME_TOWER;
	}

	@Override
	protected Map<Integer, List<RankData>> startLoadRank() {
		List<TowerCrossRole> towerList = towerCrossRoleService.getAll();
		log.info("时空魔塔加载排行榜玩家数据：" + towerList.size());
		CrossServerGroup crossServerGroup = serverGroupService.get();
		
		Map<Integer, List<RankData>> groupRankMap = new HashMap<>();
		
		for(TowerCrossRole tower : towerList) {
			if(tower.getCurrLayer() == 0) {
				continue;
			}
			CrossRole crossRole = crossRoleRedisDao.get(tower.getRid());
			if(crossRole == null) {
				log.warn("时空魔塔获取redis中role数据时未找到玩家：" + tower.getRid());
				continue;
			}
			CrossGroup crossGroup = crossServerGroup.getGroupByServerId(crossRole.getServerId());
			if(crossGroup == null) {
				continue;
			}
			int groupId = crossGroup.getGroupId();
			List<RankData> rankList = groupRankMap.get(groupId);
			if(rankList == null) {
				rankList = new ArrayList<>();
				groupRankMap.put(groupId, rankList);
			}
			
			RankData crossRank = new RankData();
            crossRank.setRankId(tower.getRid());
            crossRank.setRankTime(tower.getTime());
            crossRank.setRankValue(tower.getCurrLayer());
			rankList.add(crossRank);
		}
		for(Entry<Integer, List<RankData>> entry : groupRankMap.entrySet()) {
			log.info("时空魔塔加载排行榜玩家数据，跨服分组：" + entry.getKey() + "，排行榜数据条数："+entry.getValue().size());
		}
		return groupRankMap;
	}
	
	@Subscribe(async = AsyncType.Async)
	private void listen(TimeTowerRankEvent event) {
        CrossGroup crossGroup = crossServerGroupDao.get().getGroupByServerId(event.getServerId());
		
		RankData newRank = new RankData();
		newRank.setRankId(event.getRid());
		newRank.setRankTime(event.getTime());
		newRank.setRankValue(event.getCurrLayer());

		if (crossGroup != null) {
            addRank(newRank, crossGroup.getGroupId());
        }
	}
	
}
