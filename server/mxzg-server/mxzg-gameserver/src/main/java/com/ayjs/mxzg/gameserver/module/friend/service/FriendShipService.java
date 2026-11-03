/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.friend.service;

import java.util.ArrayList;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.gameserver.module.friend.dao.FriendShipDao;
import com.ayjs.mxzg.gameserver.module.friend.domain.FriendShip;
import com.ayjs.mxzg.gameserver.module.friend.domain.Relationship;

/**
 * @author YY
 *
 */
@Service
public class FriendShipService {
	@Autowired
	private FriendShipDao friendShipDao;
	@Autowired
	private RelationshipService relationshipService;

	public FriendShip getFriendShip(long rid) {
		FriendShip friendShip = friendShipDao.get(rid);
		if(friendShip == null) {
			friendShip = new FriendShip();
			friendShip.setRid(rid);
			friendShipDao.add(friendShip);
		}
		if(TimeDateUtil.getCurrentTimeInt() >= friendShip.getDailyTime()) {
			friendShip.setDailyTime(TimeDateUtil.getTomorrowZeroTimeInt());
			friendShip.setAdventure(0);
			friendShip.setBefall(0);
			friendShip.getGiveFriends().clear();
			friendShip.setReceiveNum(0);
			friendShipDao.update(friendShip);
			
			Map<Long, Relationship> shipMap = relationshipService.getRelationships(rid);
			for(Relationship ship : shipMap.values()) {
				ship.setHasGift(0);
			}
			if(!shipMap.isEmpty()) {
				relationshipService.updateRelationships(new ArrayList<>(shipMap.values()));
			}
		}
		return friendShip;
	}
	
	public void updateFriendShip(FriendShip friendShip) {
		friendShipDao.update(friendShip);
	}
}
