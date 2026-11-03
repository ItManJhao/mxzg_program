/**
 * 
 */
package com.ayjs.mxzg.largecross.module.towercross.handler;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.ayjs.mxzg.common.event.bus.EventBus;
import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.largecross.module.towercross.domain.TowerCrossRole;
import com.ayjs.mxzg.largecross.module.towercross.domain.TowerCrossSystem;
import com.ayjs.mxzg.largecross.module.towercross.event.TimeTowerRankEvent;
import com.ayjs.mxzg.largecross.module.towercross.service.TowerCrossRankService;
import com.ayjs.mxzg.largecross.module.towercross.service.TowerCrossRoleService;
import com.ayjs.mxzg.largecross.module.towercross.service.TowerCrossSystemService;
import com.ayjs.mxzg.message.module.floatingIslands.struct.RankData;
import com.ayjs.mxzg.message.module.role.dao.CrossRoleRedisDao;
import com.ayjs.mxzg.message.module.role.domain.CrossRole;
import com.ayjs.mxzg.message.module.timetower.TimeTowerMessage.CSTimeTowerRank;
import com.ayjs.mxzg.message.module.timetower.TimeTowerMessage.CSTimeTowerRank.CSTimeTowerRankBuilder;
import com.ayjs.mxzg.message.module.timetower.TimeTowerMessage.ReqTimeTowerGmRewardMessage;
import com.ayjs.mxzg.message.module.timetower.TimeTowerMessage.ReqTimeTowerInfoMessage;
import com.ayjs.mxzg.message.module.timetower.TimeTowerMessage.ReqTimeTowerPassMessage;
import com.ayjs.mxzg.message.module.timetower.TimeTowerMessage.ReqTimeTowerRankMessage;
import com.ayjs.mxzg.message.module.timetower.TimeTowerMessage.ResTimeTowerInfoMessage;
import com.ayjs.mxzg.message.module.timetower.TimeTowerMessage.ResTimeTowerInfoMessage.ResTimeTowerInfoMessageBuilder;
import com.ayjs.mxzg.message.module.timetower.TimeTowerMessage.ResTimeTowerRankMessage;
import com.ayjs.mxzg.message.module.timetower.TimeTowerMessage.ResTimeTowerRankMessage.ResTimeTowerRankMessageBuilder;
import com.ayjs.rpc.annotation.RemoteMethod;
import com.ayjs.rpc.dispatcher.MessageHandler;
import com.ayjs.rpc.server.Connection;

import lombok.extern.slf4j.Slf4j;

/**
 * @author YY
 *
 */
@Slf4j
@Controller
public class TimeTowerCrossHandler implements MessageHandler {

	@Autowired
	private TowerCrossRankService towerCrossRankService;
	@Autowired
	private TowerCrossSystemService towerCrossSystemService;
	@Autowired
	private TowerCrossRoleService towerCrossRoleService;
	@Autowired
	private EventBus eventBus;
	//FIXME
	@Autowired
    private CrossRoleRedisDao crossRoleRedisDao;
	
	@RemoteMethod
	public void scanTowerInfo(ReqTimeTowerInfoMessage message, Connection connection) {
		
		TowerCrossSystem towerCrossSystem = towerCrossSystemService.getSystem();
		
		TowerCrossRole towerCrossRole = towerCrossRoleService.getTower(message.getRid());
		if(message.getCurrLayer() > towerCrossRole.getCurrLayer()) {
			towerCrossRole.setCurrLayer(message.getCurrLayer());
			towerCrossRole.setTime(TimeDateUtil.getCurrentTimeInt());
			towerCrossRoleService.updateTower(towerCrossRole);
			//
			eventBus.post(TimeTowerRankEvent.of(message.getRid(), message.getCurrLayer(), TimeDateUtil.getCurrentTimeInt(), message.getServerId()));
		}
		
		ResTimeTowerInfoMessageBuilder builder = ResTimeTowerInfoMessage.builder();
		builder.rid(message.getRid());
		builder.round(towerCrossSystem.getRound());
		builder.startTime(towerCrossSystem.getStartTime());
		builder.endTime(towerCrossSystem.getEndTime());
		connection.send(builder.build());
	}
	
	@RemoteMethod
	public void passTower(ReqTimeTowerPassMessage message, Connection connection) {
		TowerCrossRole towerCrossRole = towerCrossRoleService.getTower(message.getRid());
		boolean needUpdate = false;
		if(message.getFighting() > towerCrossRole.getHisFighting()) {
			towerCrossRole.setHisFighting(message.getFighting());
			towerCrossRole.setTime(TimeDateUtil.getCurrentTimeInt());
			needUpdate = true;
		}
		if(message.getCurrLayer() > towerCrossRole.getCurrLayer()) {
			towerCrossRole.setCurrLayer(message.getCurrLayer());
			needUpdate = true;
			//
			eventBus.post(TimeTowerRankEvent.of(message.getRid(), message.getCurrLayer(), TimeDateUtil.getCurrentTimeInt(), message.getServerId()));
		}
		if(needUpdate) {
			towerCrossRoleService.updateTower(towerCrossRole);
		}
	}
	
	@RemoteMethod
	public void scanTowerRank(ReqTimeTowerRankMessage message, Connection connection) {
		
		int myRank = towerCrossRankService.getEntityRank(message.getServerId(), message.getRid());
		
		ResTimeTowerRankMessageBuilder builder = ResTimeTowerRankMessage.builder();
		builder.rid(message.getRid());
		builder.myRank(myRank);
		List<CSTimeTowerRank> rankList = new ArrayList<>();
		List<RankData> rankDatas = towerCrossRankService.showRanks(message.getServerId(), 50);
		for(RankData rankData : rankDatas) {
			CSTimeTowerRank rank = buildRank(rankData);
			if(rank == null) {
				continue;
			}
			rankList.add(rank);
		}
		builder.ranks(rankList);
		connection.send(builder.build());
	}
	
	private CSTimeTowerRank buildRank(RankData rankData) {
		CrossRole crossRole = crossRoleRedisDao.get(rankData.getRankId());
		if(crossRole == null) {
			log.info("时空魔塔排行榜" + rankData.getRankId() + "找不到redis玩家数据");
			return null;
		}
		TowerCrossRole towerCrossRole = towerCrossRoleService.getTower(rankData.getRankId());
		
		int rankNum = towerCrossRankService.getEntityRank(crossRole.getServerId(), crossRole.getId());
		
		CSTimeTowerRankBuilder builder = CSTimeTowerRank.builder();
		builder.rid(crossRole.getId());
		builder.serverId(crossRole.getServerId());
		builder.name(crossRole.getNick());
		builder.level(crossRole.getLevel());
		builder.headId(crossRole.getHeadId());
		builder.borderId(crossRole.getBorderId());
		builder.imageId(crossRole.getImageId());
		builder.rank(rankNum);
		builder.currLayer((int)rankData.getRankValue());
		builder.fighting(towerCrossRole.getHisFighting());
		return builder.build();
	}
	
	@RemoteMethod
	public void gmReward(ReqTimeTowerGmRewardMessage message, Connection connection) {
		TowerCrossSystem system = towerCrossSystemService.getSystem();
		towerCrossSystemService.sendTowerReward(system.getRound());
	}
}
