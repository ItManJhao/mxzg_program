/**
 *
 */
package com.ayjs.mxzg.gameserver.module.tower.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ayjs.mxzg.common.util.time.TimeDateUtil;
import com.ayjs.mxzg.config.excel.constant.TowerConst;
import com.ayjs.mxzg.gameserver.module.tower.dao.TowerDao;
import com.ayjs.mxzg.gameserver.module.tower.domain.Tower;

import java.util.List;

/**
 * @author YY
 *
 */
@Service
public class TowerService {
    @Autowired
    private TowerDao towerDao;

    public Tower getTower(long rid) {
        Tower tower = towerDao.get(rid);
        if (tower == null) {
            tower = new Tower();
            tower.setRid(rid);
            tower.setStage(1);
            tower.setEnergy(TowerConst.TICKETS_LIMIT);
            tower.setDailyTime(TimeDateUtil.getTomorrowZeroTimeInt());
            towerDao.add(tower);
        }
        if(TimeDateUtil.getCurrentTimeInt() >= tower.getDailyTime()) {
        	tower.setDailyTime(TimeDateUtil.getTomorrowZeroTimeInt());
        	tower.setSweepTimes(0);
        }
        return tower;
    }

    public List<Tower> getAll() {
        return towerDao.listAll();
    }

    public void updateTower(Tower tower) {
        towerDao.update(tower);
    }
}
