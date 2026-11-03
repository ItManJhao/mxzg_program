package com.ayjs.mxzg.gameserver.module.friend.service;

import com.ayjs.mxzg.gameserver.infrastructure.constant.ServerConfig;
import com.ayjs.mxzg.gameserver.module.friend.dao.BlackListDao;
import com.ayjs.mxzg.gameserver.module.friend.domain.BlackList;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * @Author: CWJ
 * @Date: 2020/3/3
 **/
@Service
public class BlackListService {

    @Autowired
    private BlackListDao blackListDao;
    @Autowired
    private ServerConfig serverConfig;

    public BlackList load(long rid) {
        BlackList blackList = blackListDao.get(rid);
        if (blackList == null) {
            blackList = new BlackList();
            blackList.setRid(rid);
            blackListDao.add(blackList);
        }
        if (!blackList.isRepair()) {
            for (Long blackId : blackList.getBlacks()) {
                blackList.getCrossBlacks().put(blackId, serverConfig.getServerId());
            }
            blackList.setRepair(true);
            update(blackList);
        }
        return blackList;
    }

    public void update(BlackList blackList) {
        blackListDao.update(blackList);
    }

    public boolean inMyBlacklist(long rid, long targetId) {
        if (rid == 0) {
            return false;
        }
        return load(rid).getCrossBlacks().containsKey(targetId);
    }
}
