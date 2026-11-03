/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.friend.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.common.util.ListMapUtil;
import com.ayjs.mxzg.gameserver.module.friend.dao.RelationshipDao;
import com.ayjs.mxzg.gameserver.module.friend.domain.Relationship;

/**
 * @author YY
 *
 */
@Service
public class RelationshipService {

	@Autowired
	private RelationshipDao relationshipDao;
	@Autowired
	private FriendShipService friendShipService;
	
	
	public Map<Long, Relationship> getShipMap(long rid) {
		//触发每日重置
		friendShipService.getFriendShip(rid);
		return getRelationships(rid);
	}
	
	protected Map<Long, Relationship> getRelationships(long rid) {
		List<Relationship> list = relationshipDao.list("rid", rid);
		return ListMapUtil.listToMap(list, Relationship::getRelationRid);
	}
	
	public Relationship getRelationship(long rid, long targetRid) {
		return getShipMap(rid).get(targetRid);
	}
	
	public void addRelationships(List<Relationship> list) {
		relationshipDao.add(list);
	}
	
	public void deleteRelationships(List<Relationship> list) {
		relationshipDao.remove(list);
	}
	
	public void updateRelationship(Relationship relationship) {
		relationshipDao.update(relationship);
	}
	
	public void updateRelationships(List<Relationship> list) {
		relationshipDao.update(list);
	}
}
