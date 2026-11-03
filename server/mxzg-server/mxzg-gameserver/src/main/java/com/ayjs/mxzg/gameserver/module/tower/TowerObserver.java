package com.ayjs.mxzg.gameserver.module.tower;


import com.ayjs.mxzg.common.event.annotation.Observer;
import com.ayjs.mxzg.common.event.annotation.Subscribe;
import com.ayjs.mxzg.gameserver.module.tower.dao.TowerRaidersLogDao;
import com.ayjs.mxzg.gameserver.module.tower.domain.TowerRaidersLog;
import com.ayjs.mxzg.gameserver.module.tower.event.TowerPassEvent;
import org.springframework.beans.factory.annotation.Autowired;

@Observer
public class TowerObserver {

    @Autowired
    private TowerRaidersLogDao towerRaidersLogDao;

    @Subscribe
    public void onTowerPass(TowerPassEvent event) {
        TowerRaidersLog towerRaidersLog = towerRaidersLogDao.getOrCreate(event.getNewStage());
        if(towerRaidersLog.fastestIsEmpty() || event.getStageRaiders().getDuration() < towerRaidersLog.getFastest().getDuration()){
            towerRaidersLog.setFastest(event.getStageRaiders());
            towerRaidersLogDao.update(towerRaidersLog);
        }

        if(towerRaidersLog.lowestIsEmpty() || event.getStageRaiders().getAbility() < towerRaidersLog.getLowest().getAbility()){
            towerRaidersLog.setLowest(event.getStageRaiders());
            towerRaidersLogDao.update(towerRaidersLog);
        }
    }
}
