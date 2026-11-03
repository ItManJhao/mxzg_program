package com.ayjs.mxzg.gameserver.module.stagematch.battle.dao;

import com.ayjs.mxzg.common.persistence.repository.BaseRepository;
import com.ayjs.mxzg.gameserver.module.stagematch.battle.domain.RoleStageMatchLog;
import org.springframework.stereotype.Repository;

/**
 * 角色段位赛信息
 */
@Repository
public class RoleStageMatchLogDao extends BaseRepository<RoleStageMatchLog> {

    public RoleStageMatchLog getOrCreate(long rid){
        RoleStageMatchLog roleStageMatchLog = get(rid);
        if(roleStageMatchLog == null){
            roleStageMatchLog = new RoleStageMatchLog();
            roleStageMatchLog.setId(rid);
            add(roleStageMatchLog);
        }
        return roleStageMatchLog;
    }

}
