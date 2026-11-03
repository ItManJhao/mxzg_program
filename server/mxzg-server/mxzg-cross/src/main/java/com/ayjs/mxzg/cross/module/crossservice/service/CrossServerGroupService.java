/**
 * 
 */
package com.ayjs.mxzg.cross.module.crossservice.service;

import com.ayjs.mxzg.cross.module.crossservice.dao.CrossServerGroupDao;
import com.ayjs.mxzg.cross.module.crossservice.domain.CrossServerGroup;
import com.ayjs.mxzg.message.center.dto.CrossGroup;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * @author YY
 *
 */
@Service
public class CrossServerGroupService {
	
	@Autowired
	private CrossServerGroupDao crossServerGroupDao;
	
	public CrossGroup getCrossGroup(int serverId) {
		CrossServerGroup crossServerGroup = crossServerGroupDao.get();
        return crossServerGroup.getGroupByServerId(serverId);
	}
	
	public int getGroupId(int serverId) {
		CrossServerGroup crossServerGroup = crossServerGroupDao.get();
		CrossGroup crossGroup = crossServerGroup.getGroupByServerId(serverId);
		if(crossGroup == null) {
			return 0;
		}
		return crossGroup.getGroupId();
	}

    public CrossServerGroup getCrossServerGroup() {
        return crossServerGroupDao.get();
    }
}
