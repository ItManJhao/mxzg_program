package com.ayjs.mxzg.gameserver.module.stagematch.battle.dao;

import com.ayjs.mxzg.common.persistence.repository.BaseRepository;
import com.ayjs.mxzg.gameserver.module.stagematch.battle.domain.GreatStyleLog;
import org.springframework.stereotype.Repository;


@Repository
public class GreatStyleLogDao extends BaseRepository<GreatStyleLog> {

    private static final int UNIQUE_ID = 1;

    /**
     * 获取唯一实例
     * @return
     */
    public GreatStyleLog get(){
        GreatStyleLog greatStyleLog = get(UNIQUE_ID);
        if(greatStyleLog == null){
            greatStyleLog = new GreatStyleLog();
            greatStyleLog.setId(UNIQUE_ID);
            add(greatStyleLog);
        }
        return greatStyleLog;
    }

}
