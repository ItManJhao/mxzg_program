package com.ayjs.mxzg.cross.module.crossrole.service;

import com.ayjs.mxzg.cross.module.crossrole.dao.CrossRoleDao;
import com.ayjs.mxzg.message.module.role.domain.CrossRole;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Objects;

@Service
public class CrossRoleService {

    @Autowired
    private CrossRoleDao crossRoleDao;

    public CrossRole getOrThrow(Long rid) {
        CrossRole crossRole = crossRoleDao.get(rid);
        if (Objects.isNull(crossRole)) {
            throw new NullPointerException("cross role is null rid:" + rid);
        }
        return crossRole;
    }
    
    public CrossRole getNotThrow(long rid) {
    	return crossRoleDao.get(rid);
    }

    public List<CrossRole> getAllRoles() {
        return crossRoleDao.listAll();
    }

    public boolean isCrossRole(long rid) {
        if (rid <= 0) {
            return false;
        }
        return Objects.nonNull(crossRoleDao.get(rid));
    }
}
