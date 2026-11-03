package com.ayjs.mxzg.cross.module.spacetimeAdventure.service;

import com.ayjs.mxzg.cross.module.spacetimeAdventure.dao.CrossFleetInfoDao;
import com.ayjs.mxzg.cross.module.spacetimeAdventure.domain.CrossFleetInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;


@Service
public class CrossFleetInfoService {

    @Autowired
    private CrossFleetInfoDao crossFleetInfoDao;

    public List<CrossFleetInfo> getInfoList() {
        return crossFleetInfoDao.listAll();
    }

    public CrossFleetInfo getInfo(long rid) {
        CrossFleetInfo crossFleetInfo = null;
        for (CrossFleetInfo info : getInfoList()) {
            if (info.getRid() == rid) {
                crossFleetInfo = info;
            }
        }
        return crossFleetInfo;
    }

    public void add(CrossFleetInfo crossFleetInfo) {
        crossFleetInfoDao.add(crossFleetInfo);
    }

    public void update(CrossFleetInfo crossFleetInfo) {
        crossFleetInfoDao.update(crossFleetInfo);
    }

}
