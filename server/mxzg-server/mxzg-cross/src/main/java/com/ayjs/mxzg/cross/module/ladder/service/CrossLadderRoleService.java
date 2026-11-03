/**
 * 
 */
package com.ayjs.mxzg.cross.module.ladder.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.cross.module.ladder.dao.CrossLadderRoleDao;
import com.ayjs.mxzg.cross.module.ladder.domain.CrossLadderRole;

/**
 * @author YY
 *
 */
@Service
public class CrossLadderRoleService {

	@Autowired
	private CrossLadderRoleDao crossLadderRoleDao;
	
	public CrossLadderRole getLadderRole(long rid) {
		CrossLadderRole role = crossLadderRoleDao.get(rid);
		if(role == null) {
			role = new CrossLadderRole();
			role.setRid(rid);
			crossLadderRoleDao.add(role);
		}
		return role;
	}
	
	public void update(CrossLadderRole role) {
		crossLadderRoleDao.update(role);
	}
}
