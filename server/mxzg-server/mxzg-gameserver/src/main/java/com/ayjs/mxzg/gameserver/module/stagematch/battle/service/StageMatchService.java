package com.ayjs.mxzg.gameserver.module.stagematch.battle.service;

import com.ayjs.mxzg.common.util.time.DateTimeUtil;
import com.ayjs.mxzg.gameserver.module.stagematch.battle.dao.RoleStageMatchDao;
import com.ayjs.mxzg.gameserver.module.stagematch.battle.domain.RoleStageMatch;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * 段位赛servic
 */
@Service
public class StageMatchService {

    @Autowired
    private RoleStageMatchDao roleStageMatchDao;

    /**
     * 获取角色段位赛信息，每日重置跟赛季重置在这里执行
     * @param rid
     * @param roleRequest   玩家主动请求时要检测是否跨赛季结算了
     * @return
     */
    public RoleStageMatch getOrCreate(long rid, boolean roleRequest){
        RoleStageMatch roleStageMatch = roleStageMatchDao.get(rid);
        if(roleStageMatch == null){
            roleStageMatch = new RoleStageMatch();
            roleStageMatch.setRid(rid);
            roleStageMatch.initialize();
            roleStageMatchDao.add(roleStageMatch);
        }

        if(!roleStageMatch.isMatchCool() && roleStageMatch.isMatching()){
            roleStageMatch.matchReset();
            roleStageMatchDao.update(roleStageMatch);
        }

        if(!DateTimeUtil.isSameDate(DateTimeUtil.currentSecond(), roleStageMatch.getResetTime())){
            roleStageMatch.dailyReset();
            roleStageMatchDao.update(roleStageMatch);
        }

        if(roleRequest && roleStageMatch.isSettlement()){
            roleStageMatch.setSettlement(false);
            roleStageMatchDao.update(roleStageMatch);
        }

        return roleStageMatch;
    }

    /**
     * 获取角色段位赛信息，每日重置跟赛季重置在这里执行
     * @param rid
     * @return
     */
    public RoleStageMatch getRoleStageMatch(long rid){
        return getOrCreate(rid, false);
    }

}
