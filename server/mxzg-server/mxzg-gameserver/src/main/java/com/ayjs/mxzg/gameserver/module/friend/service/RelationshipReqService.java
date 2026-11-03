/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.friend.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.gameserver.module.friend.dao.RelationshipReqDao;
import com.ayjs.mxzg.gameserver.module.friend.domain.RelationshipReq;

/**
 * @author YY
 *
 */
@Service
public class RelationshipReqService {
	
	@Autowired
	private RelationshipReqDao relationshipReqDao;
	
	public List<RelationshipReq> getRelationshipReqs(long rid) {
		return relationshipReqDao.list("rid", rid);
	}
	
	public void addRelationshipReq(RelationshipReq req) {
		relationshipReqDao.add(req);
	}

	/**
	 *
	 * @param rid
	 * @param requestRid
	 * @return
	 */
	public RelationshipReq selectRelationShipReq(long rid, long requestRid) {
		RelationshipReq relationshipReq = getRelationshipReqs(rid).stream()
				.filter(req -> req.getRequestRid() == requestRid).findFirst().orElse(null);
		return relationshipReq;
	}
	
	
	public void deleteRelationshipReq(RelationshipReq req) {
		relationshipReqDao.remove(req);
	}
	public void deleteRelationshipReq(List<RelationshipReq> list) {
		relationshipReqDao.remove(list);
	}
}
