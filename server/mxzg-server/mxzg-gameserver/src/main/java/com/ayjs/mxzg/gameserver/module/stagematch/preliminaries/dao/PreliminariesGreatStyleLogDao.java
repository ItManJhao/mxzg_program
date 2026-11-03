package com.ayjs.mxzg.gameserver.module.stagematch.preliminaries.dao;

import com.ayjs.mxzg.common.persistence.repository.BaseRepository;
import com.ayjs.mxzg.gameserver.module.stagematch.preliminaries.domain.PreliminariesGreatStyleLog;
import org.springframework.stereotype.Repository;


@Repository
public class PreliminariesGreatStyleLogDao extends BaseRepository<PreliminariesGreatStyleLog> {

    private static final int UNIQUE_ID = 1;

    /**
     * 获取唯一实例
     * @return
     */
    public PreliminariesGreatStyleLog get(){
        PreliminariesGreatStyleLog preliminariesGreatStyleLog = get(UNIQUE_ID);
        if(preliminariesGreatStyleLog == null){
            preliminariesGreatStyleLog = new PreliminariesGreatStyleLog();
            preliminariesGreatStyleLog.setId(UNIQUE_ID);
            add(preliminariesGreatStyleLog);
        }
        return preliminariesGreatStyleLog;
    }

}
