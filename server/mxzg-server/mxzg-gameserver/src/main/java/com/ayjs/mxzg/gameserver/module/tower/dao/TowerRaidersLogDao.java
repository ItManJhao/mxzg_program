/**
 * 
 */
package com.ayjs.mxzg.gameserver.module.tower.dao;

import com.ayjs.mxzg.common.persistence.repository.BaseRepository;
import com.ayjs.mxzg.gameserver.module.tower.domain.TowerRaiders;
import com.ayjs.mxzg.gameserver.module.tower.domain.TowerRaidersLog;
import org.springframework.stereotype.Repository;


@Repository
public class TowerRaidersLogDao extends BaseRepository<TowerRaidersLog> {

    /**
     * 获取日志，如果没有则创建
     * @param stage
     * @return
     */
    public TowerRaidersLog getOrCreate(int stage){
        TowerRaidersLog log = get(stage);
        if(log == null){
            synchronized (this){
                log = get(stage);
                if(log == null){
                    log = new TowerRaidersLog();
                    log.setStage(stage);
                    TowerRaiders defaultRaiders = new TowerRaiders();
                    log.setLowest(defaultRaiders);
                    log.setFastest(defaultRaiders);
                    add(log);
                }
            }
        }
        return log;
    }

}
